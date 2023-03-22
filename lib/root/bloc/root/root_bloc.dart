import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_request.dart';
import 'package:ricoms_app/utils/request_interval.dart';
part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc({
    required User user,
    required RootRepository rootRepository,
    required List initialPath,
  })  : _user = user,
        _rootRepository = rootRepository,
        _initialPath = initialPath,
        super(const RootState()) {
    on<ChildDataRequested>(
      _onChildDataRequested,
      // sequential: 按照順序處理 ChildDataRequested event (使用者點擊節點事件 或 自動更新節點事件)
      transformer: sequential(),
    );
    on<NodeDeleted>(_onNodeDeleted);
    on<NodesExported>(_onNodesExported);
    on<DeviceTypeNodeUpdated>(_onDeviceTypeNodeUpdated);
    on<DeviceNavigateRequested>(_onDeviceNavigateRequested);
    on<BookmarksChanged>(_onBookmarksChanged);
    on<DataSheetOpened>(_onDataSheetOpened);

    // 取得第一層 root node 的子節點
    // root node id = 0
    add(const ChildDataRequested(
        Node(
          id: 0,
          type: 1,
          name: 'Root',
        ),
        RequestMode.initial));

    // 每 3 秒更新目前節點的子節點 data
    final _dataStream = Stream<int>.periodic(
        const Duration(seconds: RequestInterval.rootNode), (count) => count);

    _dataStreamSubscription = _dataStream.listen((count) {
      if (kDebugMode) {
        print('Root update trigger times: $count');
      }
      if (state.directory.isNotEmpty) {
        add(ChildDataRequested(state.directory.last, RequestMode.update));
      }
    });
  }

  final User _user;
  final RootRepository _rootRepository;
  final List? _initialPath;

  StreamSubscription<int>? _dataStreamSubscription;

  @override
  Future<void> close() {
    _dataStreamSubscription?.cancel();
    return super.close();
  }

  /// 處理節點的 data 獲取的事件
  Future<void> _onChildDataRequested(
    ChildDataRequested event,
    Emitter<RootState> emit,
  ) async {
    // Root: 0,
    // Group: 1,
    // Device: 2, (edfa)
    // A8K: 3,
    // Shelf: 4,
    // Slot: 5,

    // 若目前所在節點是 device (edfa or a8k slot), 監控 device 狀態
    if (event.parent.type == 2 || event.parent.type == 5) {
      List<Node> directory = [];

      directory.addAll(state.directory);

      !directory.contains(event.parent) ? directory.add(event.parent) : null;
      int currentIndex = directory
          .indexOf(event.parent); // -1 represent to element does not exist
      currentIndex != -1
          ? directory.removeRange(
              currentIndex + 1 < directory.length
                  ? currentIndex + 1
                  : directory.length,
              directory.length)
          : null;

      bool isAddedToBookmarks = _checkDeviceInBookmarks(event.parent.id);

      List<dynamic> resultOfGetNodeInfo = await _rootRepository.getNodeInfo(
        user: _user,
        nodeId: event.parent.id,
      );

      if (resultOfGetNodeInfo[0]) {
        emit(state.copyWith(
          formStatus: FormStatus.requestSuccess,
          submissionStatus: SubmissionStatus.none,
          dataSheetOpenStatus: FormStatus.none,
          nodesExportStatus: FormStatus.none,
          directory: directory,
          isAddedToBookmarks: isAddedToBookmarks,
        ));
      } else {
        if (resultOfGetNodeInfo[1] == 'No node') {
          //api 回傳 No node, 當作 device 已經在其他地方被刪除, 例如從其他的手機app或從網頁刪除
          if (state.isDeviceHasBeenDeleted == false) {
            // isDeviceHasBeenDeleted 設為 true, 彈出 dialog
            // 回到上一層節點
            // 只有這裡 isDeviceHasBeenDeleted 設為 true, 其他地方都是 false 避免 dialog 重複彈出
            List<Node> directory = [];
            directory.addAll(state.directory);
            directory.removeLast();
            emit(state.copyWith(
              formStatus: FormStatus.requestSuccess,
              submissionStatus: SubmissionStatus.none,
              dataSheetOpenStatus: FormStatus.none,
              nodesExportStatus: FormStatus.none,
              directory: directory,
              isDeviceHasBeenDeleted: true,
            ));
          }
        } else {
          emit(state.copyWith(
            formStatus: FormStatus.requestFailure,
            submissionStatus: SubmissionStatus.none,
            dataSheetOpenStatus: FormStatus.none,
            nodesExportStatus: FormStatus.none,
            isDeviceHasBeenDeleted: false,
            errmsg: resultOfGetNodeInfo[1],
          ));
        }
      }
    } else {
      // 若目前所在節點非 device (edfa or a8k slot), 則更新其下一層子節點data

      if (event.requestMode == RequestMode.initial) {
        // RequestMode.initial 代表使用者點擊某個節點
        // 展開子節點的時候 emit 帶 FormStatus.requestInProgress 來讓畫面顯示loading轉圈圖示

        // 處理 RequestMode.initial 時暫停定時更新
        _dataStreamSubscription?.pause();
        emit(state.copyWith(
          formStatus: FormStatus.requestInProgress,
          submissionStatus: SubmissionStatus.none,
          dataSheetOpenStatus: FormStatus.none,
          nodesExportStatus: FormStatus.none,
          isDeviceHasBeenDeleted: false,
        ));
      }

      // 取得所有子節點data
      dynamic result = await _rootRepository.getChilds(
        user: _user,
        parentId: event.parent.id,
      );

      List<Node> directory = [];
      directory.addAll(state.directory);

      !directory.contains(event.parent) ? directory.add(event.parent) : null;
      int currentIndex =
          directory.indexOf(event.parent); // -1 means to element does not exist
      currentIndex != -1
          ? directory.removeRange(
              currentIndex + 1 < directory.length
                  ? currentIndex + 1
                  : directory.length,
              directory.length)
          : null;

      // 如果從real time alarm 畫面點擊某一筆alarm資料
      // 則會帶 _initialPath 內容
      if (_initialPath!.isNotEmpty) {
        List<dynamic> resultOfBuildDirectory = await _buildDirectorybyPath(
            directory: directory, path: _initialPath!);

        bool isAddedToBookmarks = _checkDeviceInBookmarks(_initialPath![0]);

        if (resultOfBuildDirectory[0]) {
          if (resultOfBuildDirectory[1] == '') {
            // device setting page
            emit(state.copyWith(
              formStatus: FormStatus.requestSuccess,
              submissionStatus: SubmissionStatus.none,
              nodesExportStatus: FormStatus.none,
              dataSheetOpenStatus: FormStatus.none,
              isAddedToBookmarks: isAddedToBookmarks,
              isDeviceHasBeenDeleted: false,
              directory: directory,
            ));
          } else {
            // node
            emit(state.copyWith(
              formStatus: FormStatus.requestSuccess,
              submissionStatus: SubmissionStatus.none,
              nodesExportStatus: FormStatus.none,
              dataSheetOpenStatus: FormStatus.none,
              isAddedToBookmarks: false,
              isDeviceHasBeenDeleted: false,
              directory: directory,
              data: result[1],
            ));
          }
        } else {
          // already handle in realtimealarm bloc
        }

        // 清除 _initialPath 防止頁面重複導航
        // 防止切換到其他畫面再切換回來樹的畫面時,因為 _initialPath 還留著資料而重複導航
        _initialPath!.clear();
      } else {
        if (result[0]) {
          emit(state.copyWith(
            formStatus: FormStatus.requestSuccess,
            submissionStatus: SubmissionStatus.none,
            nodesExportStatus: FormStatus.none,
            dataSheetOpenStatus: FormStatus.none,
            isDeviceHasBeenDeleted: false,
            data: result[1],
            directory: directory,
          ));
        } else {
          emit(state.copyWith(
            formStatus: FormStatus.requestFailure,
            submissionStatus: SubmissionStatus.none,
            nodesExportStatus: FormStatus.none,
            dataSheetOpenStatus: FormStatus.none,
            isDeviceHasBeenDeleted: false,
            errmsg: result[1],
          ));
        }
      }

      //  RequestMode.initial 處理完, 恢復定時更新
      if (event.requestMode == RequestMode.initial) {
        if (_dataStreamSubscription != null) {
          if (_dataStreamSubscription!.isPaused) {
            _dataStreamSubscription?.resume();
          }
        }
      }
    }
  }

  /// 處理刪除節點的事件
  Future<void> _onNodeDeleted(
    NodeDeleted event,
    Emitter<RootState> emit,
  ) async {
    emit(state.copyWith(
      nodesExportStatus: FormStatus.none,
      submissionStatus: SubmissionStatus.submissionInProgress,
      dataSheetOpenStatus: FormStatus.none,
      isDeviceHasBeenDeleted: false,
    ));

    List<dynamic> msg =
        await _rootRepository.deleteNode(user: _user, currentNode: event.node);
    if (msg[0]) {
      emit(state.copyWith(
        deleteResultMsg: msg[1],
        submissionStatus: SubmissionStatus.submissionSuccess,
      ));
    } else {
      emit(state.copyWith(
        deleteResultMsg: msg[1],
        submissionStatus: SubmissionStatus.submissionFailure,
      ));
    }
  }

  /// 處理刪除所有節點匯出的事件
  Future<void> _onNodesExported(
    NodesExported event,
    Emitter<RootState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      nodesExportStatus: FormStatus.requestInProgress,
      dataSheetOpenStatus: FormStatus.none,
      isDeviceHasBeenDeleted: false,
    ));

    List<dynamic> result = await _rootRepository.exportNodes(user: _user);

    if (result[0]) {
      emit(state.copyWith(
        nodesExportStatus: FormStatus.requestSuccess,
        nodesExportMsg: result[1],
        nodesExportFilePath: result[2],
      ));
    } else {
      emit(state.copyWith(
        nodesExportStatus: FormStatus.requestFailure,
        nodesExportMsg: result[1],
        nodesExportFilePath: '',
      ));
    }
  }

  /// 當目前節點在 edfa or a8k slot,
  /// 檢查名稱是否有更新
  /// 也檢查 online or offline
  Future<void> _onDeviceTypeNodeUpdated(
    DeviceTypeNodeUpdated event,
    Emitter<RootState> emit,
  ) async {
    var resultOfDeviceConnectionStatus =
        await _rootRepository.checkDeviceConnectionStatus(
            user: _user, deviceId: state.directory.last.id);

    if (resultOfDeviceConnectionStatus[0]) {
      if (state.formStatus.isRequestFailure) {
        //if current formStatus isRequestFailure, refresh device page content
        emit(state.copyWith(
          formStatus: FormStatus.requestSuccess,
          submissionStatus: SubmissionStatus.none,
          nodesExportStatus: FormStatus.none,
          dataSheetOpenStatus: FormStatus.none,
          directory: state.directory,
          isDeviceHasBeenDeleted: false,
        ));
      } else {
        // if device is still online, check if device name has been changed
        var resultOfDeviceName = await _rootRepository.getDeviceName(
            user: _user, deviceId: state.directory.last.id);

        if (resultOfDeviceName[0]) {
          if (resultOfDeviceName[1] != state.directory.last.name) {
            List<Node> directory = [];

            Node lastNode = Node(
              id: state.directory.last.id,
              name: resultOfDeviceName[1],
              type: state.directory.last.type,
              teg: state.directory.last.teg,
              path: state.directory.last.path,
              shelf: state.directory.last.shelf,
              slot: state.directory.last.slot,
              status: state.directory.last.status,
              sort: state.directory.last.sort,
              info: state.directory.last.info,
            );

            for (int i = 0; i < state.directory.length - 1; i++) {
              directory.add(state.directory[i]);
            }
            directory.add(lastNode);

            emit(state.copyWith(
              formStatus: FormStatus.requestSuccess,
              submissionStatus: SubmissionStatus.none,
              nodesExportStatus: FormStatus.none,
              dataSheetOpenStatus: FormStatus.none,
              directory: directory,
              isDeviceHasBeenDeleted: false,
            ));
          }
        } else {}
      }
    } else {
      if (resultOfDeviceConnectionStatus[1] == 'offline') {
        if (state.directory.last.type == 5) {
          emit(state.copyWith(
            formStatus: FormStatus.requestFailure,
            directory: state.directory,
            isDeviceHasBeenDeleted: false,
            errmsg:
                'No module in the slot ${state.directory.last.slot.toString()}, please try another.',
          ));
        } else {
          emit(state.copyWith(
            formStatus: FormStatus.requestFailure,
            directory: state.directory,
            isDeviceHasBeenDeleted: false,
            errmsg: 'The device does not respond!',
          ));
        }
      } else {
        emit(state.copyWith(
          formStatus: FormStatus.requestFailure,
          directory: state.directory,
          isDeviceHasBeenDeleted: false,
          errmsg: resultOfDeviceConnectionStatus[1],
        ));
      }
    }
  }

  /// 處理開啟 data sheet 的事件
  Future<void> _onDataSheetOpened(
    DataSheetOpened event,
    Emitter<RootState> emit,
  ) async {
    List<dynamic> result = await _rootRepository.getDataSheetURL(
      user: _user,
      nodeId: event.node.id,
    );

    if (result[0]) {
      emit(state.copyWith(
        dataSheetOpenStatus: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.none,
        nodesExportStatus: FormStatus.none,
        isDeviceHasBeenDeleted: false,
        dataSheetOpenPath: result[1],
      ));
    } else {
      emit(state.copyWith(
        dataSheetOpenStatus: FormStatus.requestFailure,
        submissionStatus: SubmissionStatus.none,
        nodesExportStatus: FormStatus.none,
        isDeviceHasBeenDeleted: false,
        dataSheetOpenMsg: result[1],
      ));
    }
  }

  /// 處理書籤的加入與刪除(如果已經在書籤內)的事件
  Future<void> _onBookmarksChanged(
    BookmarksChanged event,
    Emitter<RootState> emit,
  ) async {
    bool exists = _checkDeviceInBookmarks(event.node.id);

    if (exists) {
      // delete node id
      bool isSuccess = await _rootRepository.deleteBookmarks(
          user: _user, nodeId: event.node.id);

      if (isSuccess) {
        emit(state.copyWith(
          submissionStatus: SubmissionStatus.none,
          nodesExportStatus: FormStatus.none,
          dataSheetOpenStatus: FormStatus.none,
          isAddedToBookmarks: false,
          isDeviceHasBeenDeleted: false,
          bookmarksMsg: 'Removed from bookmarks',
        ));
      } else {
        emit(state.copyWith(
          submissionStatus: SubmissionStatus.none,
          nodesExportStatus: FormStatus.none,
          dataSheetOpenStatus: FormStatus.none,
          isDeviceHasBeenDeleted: false,
          bookmarksMsg:
              'Unable to delete from bookmarks, please check your account and login again.',
        ));
      }
    } else {
      // add node id
      bool isSuccess =
          await _rootRepository.addBookmarks(user: _user, node: event.node);

      if (isSuccess) {
        emit(state.copyWith(
          submissionStatus: SubmissionStatus.none,
          nodesExportStatus: FormStatus.none,
          dataSheetOpenStatus: FormStatus.none,
          isAddedToBookmarks: true,
          isDeviceHasBeenDeleted: false,
          bookmarksMsg: 'Added to bookmarks',
        ));
      } else {
        emit(state.copyWith(
          submissionStatus: SubmissionStatus.none,
          nodesExportStatus: FormStatus.none,
          dataSheetOpenStatus: FormStatus.none,
          isDeviceHasBeenDeleted: false,
          bookmarksMsg:
              'Unable to add to bookmarks, please check your account and login again.',
        ));
      }
    }
  }

  /// 處理搜尋節點時導航到目標節點的事件
  Future<void> _onDeviceNavigateRequested(
    DeviceNavigateRequested event,
    Emitter<RootState> emit,
  ) async {
    // 導航時暫停定時更新
    _dataStreamSubscription?.pause();
    emit(state.copyWith(
      nodesExportStatus: FormStatus.none,
      formStatus: FormStatus.requestInProgress,
      submissionStatus: SubmissionStatus.none,
      dataSheetOpenStatus: FormStatus.none,
      isDeviceHasBeenDeleted: false,
    ));

    List<Node> directory = [];
    directory.addAll(state.directory);
    directory.removeRange(1, directory.length);

    List path = event.path;
    List<dynamic> result = await _buildDirectorybyPath(
      directory: directory,
      path: path,
    );

    bool isAddedToBookmarks = _checkDeviceInBookmarks(path[0]);

    if (result[0]) {
      if (result[1] is List) {
        // 導航到某個 節點
        emit(state.copyWith(
          formStatus: FormStatus.requestSuccess,
          isAddedToBookmarks: isAddedToBookmarks,
          directory: directory,
          data: result[1],
        ));
      } else {
        // 導航到某個 device
        emit(state.copyWith(
          formStatus: FormStatus.requestSuccess,
          isAddedToBookmarks: isAddedToBookmarks,
          directory: directory,
        ));
      }
    }

    // 導航完恢復定時更新
    if (_dataStreamSubscription != null) {
      if (_dataStreamSubscription!.isPaused) {
        _dataStreamSubscription?.resume();
      }
    }
  }

  /// 檢查目前的device是否有在書籤內
  bool _checkDeviceInBookmarks(int nodeId) {
    List<DeviceMeta> bookmarks = _rootRepository.getBookmarks(user: _user);
    bool exists = false;

    for (var bookmark in bookmarks) {
      if (bookmark.id == nodeId) {
        exists = true;
        break;
      }
    }

    return exists;
  }

  // 來建立directory, 給導航時用
  Future<List<dynamic>> _buildDirectorybyPath({
    required List<Node> directory,
    required List path,
  }) async {
    List<dynamic> resultOfGetChilds;

    // 導航的順序是 iterate path, 從path的最後的一個 id 開始往第一個id 建立
    // 建到 path 的第一個 id 會對應到目標 node id ( device id or node id )
    for (int i = path.length - 1; i >= 0; i--) {
      resultOfGetChilds = await _rootRepository.getChilds(
        user: _user,
        parentId: directory.last.id,
      );
      if (resultOfGetChilds[0]) {
        List childs = resultOfGetChilds[1];
        for (int j = 0; j < childs.length; j++) {
          Node node = childs[j];

          if (node.id == path[i]) {
            directory.add(node);
          }
        }
      } else {
        return [false, 'No node'];
      }
    }

    if (directory.last.type == 2 || directory.last.type == 5) {
      return [true, '']; // device setting page
    } else {
      // 如果 directory 最後一個節點 是樹的某一層 node, 則還要回傳子節點的data
      resultOfGetChilds = await _rootRepository.getChilds(
        user: _user,
        parentId: directory.last.id,
      );
      return [true, resultOfGetChilds[1]];
    }
  }
}
