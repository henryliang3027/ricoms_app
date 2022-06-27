import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc({
    required RootRepository rootRepository,
    required DeviceRepository deviceRepository,
  })  : _rootRepository = rootRepository,
        _deviceRepository = deviceRepository,
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

  final DeviceRepository _deviceRepository;
  final RootRepository _rootRepository;
  final List<Node> _directory = <Node>[];
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

    dynamic data = await _rootRepository.getChilds(event.parent);

    !_directory.contains(event.parent) ? _directory.add(event.parent) : null;
    int currentIndex = _directory
        .indexOf(event.parent); // -1 represent to element does not exist
    currentIndex != -1
        ? _directory.removeRange(
            currentIndex + 1 < _directory.length
                ? currentIndex + 1
                : _directory.length,
            _directory.length)
        : null;

    if (data is List) {
      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.none,
        data: data,
        directory: _directory,
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

  Future<void> _onChildDataUpdated(
    ChildDataUpdated event,
    Emitter<RootState> emit,
  ) async {
    dynamic data =
        await _rootRepository.getChilds(_directory[_directory.length - 1]);

    if (data is List) {
      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.none,
        data: data,
        directory: _directory,
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
        await _rootRepository.deleteNode(currentNode: event.node);
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

    _deviceRepository.deviceNodeId = event.node.id.toString();

    !_directory.contains(event.node) ? _directory.add(event.node) : null;
    int currentIndex = _directory
        .indexOf(event.node); // -1 represent to element does not exist
    currentIndex != -1
        ? _directory.removeRange(
            currentIndex + 1 < _directory.length
                ? currentIndex + 1
                : _directory.length,
            _directory.length)
        : null;

    emit(state.copyWith(
      formStatus: FormStatus.requestSuccess,
      submissionStatus: SubmissionStatus.none,
      directory: _directory,
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

    _directory.removeRange(1, _directory.length);

    List path = event.path;

    for (int i = path.length - 1; i >= 0; i--) {
      dynamic data = await _rootRepository.getChilds(_directory.last);
      if (data is List) {
        for (int j = 0; j < data.length; j++) {
          Node node = data[j];

          if (node.id == path[i]) {
            _directory.add(node);
          }
        }
        // emit(state.copyWith(
        //   formStatus: FormStatus.requestSuccess,
        //   submissionStatus: SubmissionStatus.none,
        //   data: data,
        //   directory: _directory,
        // ));
      } else {
        emit(state.copyWith(
          formStatus: FormStatus.requestFailure,
          submissionStatus: SubmissionStatus.none,
          data: [data],
        ));
        break;
      }
    }

    if (_directory.length == path.length + 1) {
      // + 1 as root node id because path.length not consider root node id
      _deviceRepository.deviceNodeId = _directory.last.id.toString();

      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.none,
        directory: _directory,
      ));
    }

    //avoid user click node and dataStream trigger at the same time, reaume update periodic

    _dataStreamSubscription?.resume();
  }
}
