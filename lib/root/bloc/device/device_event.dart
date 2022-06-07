part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object> get props => [];
}

class DeviceDataRequested extends DeviceEvent {
  const DeviceDataRequested();

  @override
  List<Object> get props => [];
}

class FormStatusChanged extends DeviceEvent {
  const FormStatusChanged(this.isEditing);

  final bool isEditing;

  @override
  List<Object> get props => [isEditing];
}

class ControllerValueChanged extends DeviceEvent {
  const ControllerValueChanged(this.controllerValues);

  final Map<String, String> controllerValues;

  @override
  List<Object> get props => [];
}

class DeviceParamSaved extends DeviceEvent {
  const DeviceParamSaved(this.param);

  final List<Map<String, String>> param;
}
