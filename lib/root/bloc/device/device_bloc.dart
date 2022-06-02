import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/device/form_status.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceBloc({required RootRepository rootRepository})
      : _rootRepository = rootRepository,
        super(const DeviceState()) {
    on<DeviceDataRequested>(_onDeviceDataRequested);
    on<FormStatusChanged>(_onFormStatusChanged);
    on<DeviceParamSaved>(_onDeviceParamSaved);
    on<ControllerValueChanged>(_onControllerValueChanged);
  }

  final RootRepository _rootRepository;

  Future<void> _onDeviceDataRequested(
    DeviceDataRequested event,
    Emitter<DeviceState> emit,
  ) async {
    emit(state.copyWith(formStatus: FormStatus.requestInProgress));

    dynamic data = await _rootRepository.getDevicePage(event.pageName);
    bool isEditable = _rootRepository.isEditable(event.pageName);

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
    emit(state.copyWith(formStatus: FormStatus.requestInProgress));
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

    List result = await _rootRepository.setDeviceParams(event.param);

    if (result[0] == true) {
      emit(state.copyWith(
          submissionStatus: SubmissionStatus.submissionSuccess,
          saveResultMsg: result[1]));
    } else {
      emit(state.copyWith(
          submissionStatus: SubmissionStatus.submissionFailure,
          saveResultMsg: result[1]));
    }
  }
}
