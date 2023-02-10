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

class RetryFailedSettingRequested extends DeviceSettingResultEvent {
  const RetryFailedSettingRequested();

  @override
  List<Object> get props => [];
}

class RetrySetDeviceParamsRequested extends DeviceSettingResultEvent {
  const RetrySetDeviceParamsRequested(this.indexOfDevice);

  final int indexOfDevice;

  @override
  List<Object> get props => [indexOfDevice];
}

class DeviceParamItemSelected extends DeviceSettingResultEvent {
  const DeviceParamItemSelected(this.index, this.value);

  final int index;
  final bool value;

  @override
  List<Object> get props => [
        index,
        value,
      ];
}

class AllDeviceParamItemsDeselected extends DeviceSettingResultEvent {
  const AllDeviceParamItemsDeselected();

  @override
  List<Object> get props => [];
}

class AllDeviceParamItemsSelected extends DeviceSettingResultEvent {
  const AllDeviceParamItemsSelected();

  @override
  List<Object> get props => [];
}
