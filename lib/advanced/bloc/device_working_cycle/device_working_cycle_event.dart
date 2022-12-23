part of 'device_working_cycle_bloc.dart';

abstract class DeviceWorkingCycleEvent extends Equatable {
  const DeviceWorkingCycleEvent();
}

class DeviceWorkingCycleRequested extends DeviceWorkingCycleEvent {
  const DeviceWorkingCycleRequested();

  @override
  List<Object?> get props => [];
}

class DeviceWorkingCycleChanged extends DeviceWorkingCycleEvent {
  const DeviceWorkingCycleChanged(this.index);

  final String index;

  @override
  List<Object?> get props => [];
}

class DeviceWorkingCycleSaved extends DeviceWorkingCycleEvent {
  const DeviceWorkingCycleSaved();

  @override
  List<Object?> get props => [];
}
