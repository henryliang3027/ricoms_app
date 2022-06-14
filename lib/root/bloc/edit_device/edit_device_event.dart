part of 'edit_device_bloc.dart';

abstract class EditDeviceEvent extends Equatable {
  const EditDeviceEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends EditDeviceEvent {
  const NameChanged(this.name);
  final String name;

  @override
  List<Object> get props => [name];
}

class DeviceIPChanged extends EditDeviceEvent {
  const DeviceIPChanged(this.deviceIP);
  final String deviceIP;

  @override
  List<Object> get props => [deviceIP];
}

class FormSubmitted extends EditDeviceEvent {
  const FormSubmitted();
}
