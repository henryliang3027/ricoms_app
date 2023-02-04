part of 'config_device_bloc.dart';

abstract class ConfigDeviceEvent extends Equatable {
  const ConfigDeviceEvent();
}

class DeviceSettingDataRequested extends ConfigDeviceEvent {
  const DeviceSettingDataRequested();

  @override
  List<Object?> get props => [];
}

class ControllerValueChanged extends ConfigDeviceEvent {
  const ControllerValueChanged(
    this.pageId,
    this.oid,
    this.value,
  );

  final int pageId;
  final String oid;
  final String value;

  @override
  List<Object?> get props => [
        pageId,
        oid,
        value,
      ];
}

class SettingDataSaved extends ConfigDeviceEvent {
  const SettingDataSaved();

  @override
  List<Object?> get props => [];
}

class ControllerValueCleared extends ConfigDeviceEvent {
  const ControllerValueCleared(this.pageId);

  final int pageId;

  @override
  List<Object?> get props => [];
}
