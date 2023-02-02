part of 'batch_device_setting_bloc.dart';

abstract class BatchDeviceSettingEvent extends Equatable {
  const BatchDeviceSettingEvent();
}

class DeviceSettingDataRequested extends BatchDeviceSettingEvent {
  const DeviceSettingDataRequested();

  @override
  List<Object?> get props => [];
}

class ControllerValueChanged extends BatchDeviceSettingEvent {
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

class SettingDataSaved extends BatchDeviceSettingEvent {
  const SettingDataSaved();

  @override
  List<Object?> get props => [];
}

class ControllerValueCleared extends BatchDeviceSettingEvent {
  const ControllerValueCleared();

  @override
  List<Object?> get props => [];
}
