part of 'device_setting_result_bloc.dart';

abstract class DeviceSettingResultEvent extends Equatable {
  const DeviceSettingResultEvent();

  @override
  List<Object> get props => [];
}

class InitialDeviceParamRequested extends DeviceSettingResultEvent {
  const InitialDeviceParamRequested();

  @override
  List<Object> get props => [];
}

class SetDeviceParamRequested extends DeviceSettingResultEvent {
  const SetDeviceParamRequested(this.indexOfDevice);

  final int indexOfDevice;

  @override
  List<Object> get props => [indexOfDevice];
}

class DeviceParamItemSelected extends DeviceSettingResultEvent {
  const DeviceParamItemSelected(this.deviceParamItem);

  final DeviceParamItem deviceParamItem;

  @override
  List<Object> get props => [deviceParamItem];
}
