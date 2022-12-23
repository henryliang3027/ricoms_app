import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:ricoms_app/repository/device_working_cycle_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'device_working_cycle_event.dart';
part 'device_working_cycle_state.dart';

class DeviceWorkingCycleBloc
    extends Bloc<DeviceWorkingCycleEvent, DeviceWorkingCycleState> {
  DeviceWorkingCycleBloc({
    required User user,
    required DeviceWorkingCycleRepository deviceWorkingCycleRepository,
  })  : _user = user,
        _deviceWorkingCycleRepository = deviceWorkingCycleRepository,
        super(const DeviceWorkingCycleState()) {
    on<DeviceWorkingCycleRequested>(_onDeviceWorkingCycleRequested);
    on<DeviceWorkingCycleChanged>(_onDeviceWorkingCycleChanged);
    on<DeviceWorkingCycleSaved>(_onDeviceWorkingCycleSaved);

    add(const DeviceWorkingCycleRequested());
  }

  final User _user;
  final DeviceWorkingCycleRepository _deviceWorkingCycleRepository;

  void _onDeviceWorkingCycleRequested(
    DeviceWorkingCycleRequested event,
    Emitter<DeviceWorkingCycleState> emit,
  ) async {
    List<dynamic> result =
        await _deviceWorkingCycleRepository.getWorkingCycleList(user: _user);

    if (result[0]) {
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        deviceWorkingCycleList: result[1],
        deviceWorkingCycleIndex: result[2],
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        deviceWorkingCycleList: [],
        requestErrorMsg: result[1],
      ));
    }

    emit(state.copyWith());
  }

  void _onDeviceWorkingCycleSaved(
    DeviceWorkingCycleSaved event,
    Emitter<DeviceWorkingCycleState> emit,
  ) {
    emit(state.copyWith(status: FormStatus.requestInProgress));

    //repo

    emit(state.copyWith(status: FormStatus.requestSuccess));
  }

  void _onDeviceWorkingCycleChanged(
    DeviceWorkingCycleChanged event,
    Emitter<DeviceWorkingCycleState> emit,
  ) {
    emit(state.copyWith(deviceWorkingCycleIndex: event.index));
  }
}
