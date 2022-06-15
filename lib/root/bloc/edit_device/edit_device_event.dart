part of 'edit_device_bloc.dart';

abstract class EditDeviceEvent extends Equatable {
  const EditDeviceEvent();

  @override
  List<Object> get props => [];
}

class DataRequested extends EditDeviceEvent {
  const DataRequested();

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

class ReadChanged extends EditDeviceEvent {
  const ReadChanged(this.read);
  final String read;

  @override
  List<Object> get props => [read];
}

class WriteChanged extends EditDeviceEvent {
  const WriteChanged(this.write);
  final String write;

  @override
  List<Object> get props => [write];
}

class DescriptionChanged extends EditDeviceEvent {
  const DescriptionChanged(this.description);
  final String description;

  @override
  List<Object> get props => [description];
}

class LocationChanged extends EditDeviceEvent {
  const LocationChanged(this.location);
  final String location;

  @override
  List<Object> get props => [location];
}

class FormSubmitted extends EditDeviceEvent {
  const FormSubmitted();
}
