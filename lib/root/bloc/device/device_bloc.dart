import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceBloc({
    required User user,
    required DeviceRepository deviceRepository,
    required String pageName,
  })  : _user = user,
        _deviceRepository = deviceRepository,
        _pageName = pageName,
        super(const DeviceState()) {
    on<DeviceDataRequested>(_onDeviceDataRequested);
    on<DeviceDataUpdateRequested>(_onDeviceDataUpdateRequested);
    on<FormStatusChanged>(_onFormStatusChanged);
    on<DeviceParamSaved>(_onDeviceParamSaved);
    on<ControllerValueChanged>(_onControllerValueChanged);

    add(const DeviceDataRequested());
    _dataStreamSubscription = _dataStream.listen((count) {
      print(
          'Device Setting update trigger times: ${count}, current state: ${pageName} => isEditing : ${state.isEditing}');
      state.isEditing == false ? add(const DeviceDataUpdateRequested()) : null;
    });
  }

  final User _user;
  final DeviceRepository _deviceRepository;
  final String _pageName;
  final _dataStream =
      Stream<int>.periodic(const Duration(seconds: 5), (count) => count);
  StreamSubscription<int>? _dataStreamSubscription;

  @override
  Future<void> close() {
    _dataStreamSubscription?.cancel();
    return super.close();
  }

  Future<void> _onDeviceDataRequested(
    DeviceDataRequested event,
    Emitter<DeviceState> emit,
  ) async {
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
    ));

    dynamic data = await _deviceRepository.getDevicePage(
      user: _user,
      pageName: _pageName,
    );
    bool isEditable = _deviceRepository.isEditable(_pageName);

    if (data is List) {
      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.none,
        data: data,
        editable: isEditable,
      ));
    } else {
      emit(state.copyWith(
        formStatus: FormStatus.requestFailure,
        submissionStatus: SubmissionStatus.none,
        data: [data],
        editable: isEditable,
      ));
    }
  }

  Future<void> _onDeviceDataUpdateRequested(
    DeviceDataUpdateRequested event,
    Emitter<DeviceState> emit,
  ) async {
    emit(state.copyWith(
      formStatus: FormStatus.updating,
    ));

    dynamic data = await _deviceRepository.getDevicePage(
      user: _user,
      pageName: _pageName,
    );
    bool isEditable = _deviceRepository.isEditable(_pageName);

    if (data is List) {
      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.none,
        data: data,
        editable: isEditable,
      ));
    } else {
      emit(state.copyWith(
        formStatus: FormStatus.requestFailure,
        submissionStatus: SubmissionStatus.none,
        data: [data],
        editable: isEditable,
      ));
    }
  }

  void _onFormStatusChanged(
    FormStatusChanged event,
    Emitter<DeviceState> emit,
  ) {
    //emit(state.copyWith(formStatus: FormStatus.requestInProgress));
    emit(state.copyWith(
      formStatus: FormStatus.requestSuccess,
      submissionStatus: SubmissionStatus.none,
      isEditing: event.isEditing,
    ));
  }

  void _onControllerValueChanged(
    ControllerValueChanged event,
    Emitter<DeviceState> emit,
  ) {
    emit(state.copyWith(controllerValues: event.controllerValues));
  }

  Future<void> _onDeviceParamSaved(
    DeviceParamSaved event,
    Emitter<DeviceState> emit,
  ) async {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionInProgress));

    List result = [];
    if (_pageName == 'Description') {
      String name = event.param[0]['value']!;
      String description = event.param[1]['value']!;
      result = await _deviceRepository.setDeviceDescription(
        user: _user,
        name: name,
        description: description,
      );
    } else {
      result = await _deviceRepository.setDeviceParams(
        user: _user,
        params: event.param,
      );
    }

    if (result[0] == true) {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionSuccess,
        saveResultMsg: result[1],
        isEditing: false,
      ));
    } else {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionFailure,
        saveResultMsg: result[1],
      ));
    }
  }
}
