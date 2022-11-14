import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';
part 'root_event.dart';
part 'root_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

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
      transformer: throttleDroppable(throttleDuration),
    );
    on<NodeDeleted>(_onNodeDeleted);
    on<NodesExported>(_onNodesExported);
    on<ChildDataUpdated>(_onChildDataUpdated);
    on<DeviceTypeNodeUpdated>(_onDeviceTypeNodeUpdated);
    on<DeviceDataRequested>(_onDeviceDataRequested);
    on<DeviceNavigateRequested>(_onDeviceNavigateRequested);
    on<BookmarksChanged>(_onBookmarksChanged);

    add(const ChildDataRequested(Node(
      id: 0,
      type: 1,
      name: 'Root',
    )));
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

  Future<void> _onChildDataRequested(
    ChildDataRequested event,
    Emitter<RootState> emit,
  ) async {
    final dataStream =
        Stream<int>.periodic(const Duration(seconds: 3), (count) => count);

    _dataStreamSubscription?.cancel();
    _dataStreamSubscription = dataStream.listen((count) {
      if (kDebugMode) {
        print('Root update trigger times: $count');
      }
      add(const ChildDataUpdated());
    });

    // emit(state.copyWith(
    //   formStatus: FormStatus.requestInProgress,
    //   submissionStatus: SubmissionStatus.none,
    // ));

    dynamic data = await _rootRepository.getChilds(
      user: _user,
      parentId: event.parent.id,
    );

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

    if (_initialPath!.isNotEmpty) {
      List<dynamic> result = await _buildDirectorybyPath(
          directory: directory, path: _initialPath!);

      bool isAddedToBookmarks = _checkDeviceInBookmarks(_initialPath![0]);

      final dataStream =
          Stream<int>.periodic(const Duration(seconds: 3), (count) => count);

      _dataStreamSubscription?.cancel();
      _dataStreamSubscription = dataStream.listen((count) {
        if (kDebugMode) {
          print('Device type node updated trigger times: $count');
        }
        add(const DeviceTypeNodeUpdated());
      });

      if (result[0]) {
        if (result[1] == '') {
          // device setting page
          emit(state.copyWith(
            formStatus: FormStatus.requestSuccess,
            submissionStatus: SubmissionStatus.none,
            nodesExportStatus: FormStatus.none,
            isAddedToBookmarks: isAddedToBookmarks,
            directory: directory,
          ));
        } else {
          // node
          emit(state.copyWith(
            formStatus: FormStatus.requestSuccess,
            submissionStatus: SubmissionStatus.none,
            nodesExportStatus: FormStatus.none,
            isAddedToBookmarks: false,
            directory: directory,
            data: result[1],
          ));
        }
      } else {
        // already handle in realtimealarm bloc
      }

      // clear path to avoid go to previous device setting page when user switch back from another page.
      _initialPath!.clear();
    } else {
      if (data is List) {
        emit(state.copyWith(
          formStatus: FormStatus.requestSuccess,
          submissionStatus: SubmissionStatus.none,
          nodesExportStatus: FormStatus.none,
          data: data,
          directory: directory,
        ));
      } else {
        emit(state.copyWith(
          formStatus: FormStatus.requestFailure,
          submissionStatus: SubmissionStatus.none,
          nodesExportStatus: FormStatus.none,
          errmsg: data,
        ));
      }
    }
  }

  Future<void> _onChildDataUpdated(
    ChildDataUpdated event,
    Emitter<RootState> emit,
  ) async {
    // Ｔhe directory is empty because of no internet and user reload the page (switch back from another page)

    // List<Node> directory = [];

    // if (state.directory.isNotEmpty) {
    //   directory.addAll(state.directory);
    // } else {
    //   directory.add(const Node(
    //     id: 0,
    //     type: 1,
    //     name: 'Root',
    //   ));
    // }

    var resultOfChilds = await _rootRepository.getChilds(
      user: _user,
      parentId: state.directory.last.id,
    );

    if (resultOfChilds is List) {
      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.none,
        nodesExportStatus: FormStatus.none,
        data: resultOfChilds,
        directory: state.directory,
      ));
    } else {
      emit(state.copyWith(
        formStatus: FormStatus.requestFailure,
        submissionStatus: SubmissionStatus.none,
        nodesExportStatus: FormStatus.none,
        errmsg: resultOfChilds,
      ));
    }
  }

  Future<void> _onNodeDeleted(
    NodeDeleted event,
    Emitter<RootState> emit,
  ) async {
    emit(state.copyWith(
      nodesExportStatus: FormStatus.none,
      submissionStatus: SubmissionStatus.submissionInProgress,
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

  Future<void> _onNodesExported(
    NodesExported event,
    Emitter<RootState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      nodesExportStatus: FormStatus.requestInProgress,
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

  void _onDeviceDataRequested(
    DeviceDataRequested event,
    Emitter<RootState> emit,
  ) {
    //avoid user click node and dataStream trigger at the same time, stop before Request for child
    _dataStreamSubscription?.cancel();
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
      submissionStatus: SubmissionStatus.none,
      nodesExportStatus: FormStatus.none,
    ));

    List<Node> directory = [];
    directory.addAll(state.directory);

    //_deviceRepository.deviceNodeId = event.node.id.toString();

    !directory.contains(event.node) ? directory.add(event.node) : null;
    int currentIndex =
        directory.indexOf(event.node); // -1 represent to element does not exist
    currentIndex != -1
        ? directory.removeRange(
            currentIndex + 1 < directory.length
                ? currentIndex + 1
                : directory.length,
            directory.length)
        : null;

    bool isAddedToBookmarks = _checkDeviceInBookmarks(event.node.id);

    final dataStream =
        Stream<int>.periodic(const Duration(seconds: 3), (count) => count);

    _dataStreamSubscription = dataStream.listen((count) {
      if (kDebugMode) {
        print('Device type node updated trigger times: $count');
      }
      add(const DeviceTypeNodeUpdated());
    });

    emit(state.copyWith(
      formStatus: FormStatus.requestSuccess,
      directory: directory,
      isAddedToBookmarks: isAddedToBookmarks,
    ));
  }

  // When current form has device setting page
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
          directory: state.directory,
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
              directory: directory,
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
            errmsg:
                'No module in the slot ${state.directory.last.slot.toString()}, please try another.',
          ));
        } else {
          emit(state.copyWith(
            formStatus: FormStatus.requestFailure,
            directory: state.directory,
            errmsg: 'The device does not respond!',
          ));
        }
      } else {
        emit(state.copyWith(
          formStatus: FormStatus.requestFailure,
          directory: state.directory,
          errmsg: resultOfDeviceConnectionStatus[1],
        ));
      }
    }
  }

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
          isAddedToBookmarks: false,
          bookmarksMsg: 'Removed from bookmarks',
        ));
      } else {
        emit(state.copyWith(
          submissionStatus: SubmissionStatus.none,
          nodesExportStatus: FormStatus.none,
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
          isAddedToBookmarks: true,
          bookmarksMsg: 'Added to bookmarks',
        ));
      } else {
        emit(state.copyWith(
          submissionStatus: SubmissionStatus.none,
          nodesExportStatus: FormStatus.none,
          bookmarksMsg:
              'Unable to add to bookmarks, please check your account and login again.',
        ));
      }
    }
  }

  Future<void> _onDeviceNavigateRequested(
    DeviceNavigateRequested event,
    Emitter<RootState> emit,
  ) async {
    //avoid user click node and dataStream trigger at the same time, stop before Request for child
    _dataStreamSubscription?.pause();
    emit(state.copyWith(
      nodesExportStatus: FormStatus.none,
      formStatus: FormStatus.requestInProgress,
      submissionStatus: SubmissionStatus.none,
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

    final dataStream =
        Stream<int>.periodic(const Duration(seconds: 3), (count) => count);

    _dataStreamSubscription = dataStream.listen((count) {
      if (kDebugMode) {
        print('Device type node updated trigger times: $count');
      }
      add(const DeviceTypeNodeUpdated());
    });

    if (result[0]) {
      if (result[1] is List) {
        // node
        emit(state.copyWith(
          formStatus: FormStatus.requestSuccess,
          isAddedToBookmarks: isAddedToBookmarks,
          directory: directory,
          data: result[1],
        ));
      } else {
        // device setting page
        emit(state.copyWith(
          formStatus: FormStatus.requestSuccess,
          isAddedToBookmarks: isAddedToBookmarks,
          directory: directory,
        ));
      }
    } else {
      // already handle in realtimealarm bloc
    }

    //avoid user click node and dataStream trigger at the same time, reaume update periodic
    //_dataStreamSubscription?.resume();
  }

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

  Future<List<dynamic>> _buildDirectorybyPath({
    required List<Node> directory,
    required List path,
  }) async {
    dynamic childs;

    for (int i = path.length - 1; i >= 0; i--) {
      childs = await _rootRepository.getChilds(
        user: _user,
        parentId: directory.last.id,
      );
      if (childs is List) {
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

    // + 1 as root node id because path.length not consider root node id
    if (directory.length == path.length + 1) {
      if (directory.last.type == 2 || directory.last.type == 5) {
        //_deviceRepository.deviceNodeId = directory.last.id.toString();
        return [true, '']; // device setting page
      } else {
        //get child of current node
        childs = await _rootRepository.getChilds(
          user: _user,
          parentId: directory.last.id,
        );
        return [true, childs]; //
      }
    } else {
      return [false, 'No node'];
    }
  }
}
