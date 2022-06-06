part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object> get props => [];
}

class DeviceDataRequested extends DeviceEvent {
  const DeviceDataRequested(this.pageName);

  final String pageName;

  @override
  List<Object> get props => [pageName];
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
}

class DeviceParamSaved extends DeviceEvent {
  const DeviceParamSaved(this.pageName, this.param);

  final String pageName;
  final List<Map<String, String>> param;
}
