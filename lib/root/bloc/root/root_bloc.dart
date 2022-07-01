import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc({
    required User user,
    required RootRepository rootRepository,
    required DeviceRepository deviceRepository,
    required List initialPath,
  })  : _user = user,
        _rootRepository = rootRepository,
        _deviceRepository = deviceRepository,
        _initialPath = initialPath,
        super(const RootState()) {
    on<ChildDataRequested>(_onChildDataRequested);
    on<NodeDeleted>(_onNodeDeleted);
    on<ChildDataUpdated>(_onChildDataUpdated);
    on<DeviceDataRequested>(_onDeviceDataRequested);
    on<DeviceNavigateRequested>(_onDeviceNavigateRequested);

    add(const ChildDataRequested(Node(
      id: 0,
      type: 1,
      name: 'Root',
    )));

    _dataStreamSubscription = _dataStream.listen((count) {
      print('Root update trigger times: ${count}');
      add(const ChildDataUpdated());
    });
  }

  final User _user;
  final DeviceRepository _deviceRepository;
  final RootRepository _rootRepository;
  final List? _initialPath;
  final _dataStream =
      Stream<int>.periodic(const Duration(seconds: 3), (count) => count);
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
    //avoid user click node and dataStream trigger at the same time, stop before Request for child
    _dataStreamSubscription?.pause();
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
      submissionStatus: SubmissionStatus.none,
    ));

    dynamic data = await _rootRepository.getChilds(
      user: _user,
      parent: event.parent,
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
      bool isSuccess = await _buildDirectorybyPath(directory, _initialPath!);
      if (isSuccess) {
        emit(state.copyWith(
          formStatus: FormStatus.requestSuccess,
          submissionStatus: SubmissionStatus.none,
          directory: directory,
        ));
      } else {
        // show current directory and childs of the last node if failed
        emit(state.copyWith(
          formStatus: FormStatus.requestFailure,
          submissionStatus: SubmissionStatus.none,
          data: data,
          directory: directory,
          deleteResultMsg: 'The Device does not respond!',
        ));
      }

      // clear path to avoid go to previous device setting page when user switch back from another page.
      _initialPath!.clear();
    } else {
      if (data is List) {
        emit(state.copyWith(
          formStatus: FormStatus.requestSuccess,
          submissionStatus: SubmissionStatus.none,
          data: data,
          directory: directory,
        ));
      } else {
        emit(state.copyWith(
          formStatus: FormStatus.requestFailure,
          submissionStatus: SubmissionStatus.none,
          data: [data],
        ));
      }

      //avoid user click node and dataStream trigger at the same time, reaume update periodic

      _dataStreamSubscription?.resume();
    }
  }

  Future<void> _onChildDataUpdated(
    ChildDataUpdated event,
    Emitter<RootState> emit,
  ) async {
    dynamic data = await _rootRepository.getChilds(
      user: _user,
      parent: state.directory[state.directory.length - 1],
    );

    if (data is List) {
      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.none,
        data: data,
        directory: state.directory,
      ));
    } else {
      emit(state.copyWith(
        formStatus: FormStatus.requestFailure,
        submissionStatus: SubmissionStatus.none,
        data: [data],
      ));
    }
  }

  Future<void> _onNodeDeleted(
    NodeDeleted event,
    Emitter<RootState> emit,
  ) async {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionInProgress));

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

  void _onDeviceDataRequested(
    DeviceDataRequested event,
    Emitter<RootState> emit,
  ) {
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
      submissionStatus: SubmissionStatus.none,
    ));

    List<Node> directory = [];
    directory.addAll(state.directory);

    _deviceRepository.deviceNodeId = event.node.id.toString();

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

    emit(state.copyWith(
      formStatus: FormStatus.requestSuccess,
      submissionStatus: SubmissionStatus.none,
      directory: directory,
    ));
  }

  Future<void> _onDeviceNavigateRequested(
    DeviceNavigateRequested event,
    Emitter<RootState> emit,
  ) async {
    //avoid user click node and dataStream trigger at the same time, stop before Request for child
    _dataStreamSubscription?.pause();
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
      submissionStatus: SubmissionStatus.none,
    ));

    List<Node> directory = [];
    directory.addAll(state.directory);

    directory.removeRange(1, directory.length);

    List path = event.path;

    bool isSuccess = await _buildDirectorybyPath(directory, path);

    if (isSuccess) {
      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.none,
        directory: directory,
      ));
    } else {
      emit(state.copyWith(
        formStatus: FormStatus.requestFailure,
        submissionStatus: SubmissionStatus.none,
        data: ['Device not found!'],
      ));
    }

    //avoid user click node and dataStream trigger at the same time, reaume update periodic
    _dataStreamSubscription?.resume();
  }

  Future<bool> _buildDirectorybyPath(List<Node> directory, List path) async {
    for (int i = path.length - 1; i >= 0; i--) {
      dynamic data = await _rootRepository.getChilds(
        user: _user,
        parent: directory.last,
      );
      if (data is List) {
        for (int j = 0; j < data.length; j++) {
          Node node = data[j];

          if (node.id == path[i]) {
            directory.add(node);
          }
        }
      } else {
        return false;
      }
    }

    if (directory.length == path.length + 1) {
      // + 1 as root node id because path.length not consider root node id
      _deviceRepository.deviceNodeId = directory.last.id.toString();
      return true;
    } else {
      return false;
    }
  }
}
