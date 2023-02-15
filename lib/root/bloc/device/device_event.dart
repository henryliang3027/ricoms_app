part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object> get props => [];
}

class DeviceDataRequested extends DeviceEvent {
  const DeviceDataRequested(this.requestMode);

  final RequestMode requestMode;

  @override
  List<Object> get props => [];
}

class DeviceRefreshRequested extends DeviceEvent {
  const DeviceRefreshRequested();

  @override
  List<Object> get props => [];
}

class FormStatusChanged extends DeviceEvent {
  const FormStatusChanged(this.isEditing);

  final bool isEditing;

  @override
  List<Object> get props => [isEditing];
}

// todo
class ControllerValueChanged extends DeviceEvent {
  const ControllerValueChanged(this.oid, this.value);

  final String oid;
  final String value;

  @override
  List<Object> get props => [
        oid,
        value,
      ];
}

class DeviceParamSaved extends DeviceEvent {
  const DeviceParamSaved();
}
