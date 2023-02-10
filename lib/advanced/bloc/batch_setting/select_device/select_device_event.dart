part of 'select_device_bloc.dart';

abstract class SelectDeviceEvent extends Equatable {
  const SelectDeviceEvent();
}

class DeviceDataRequested extends SelectDeviceEvent {
  const DeviceDataRequested();

  @override
  List<Object?> get props => [];
}

class KeywordSearched extends SelectDeviceEvent {
  const KeywordSearched(this.keyword);

  final String keyword;

  @override
  List<Object?> get props => [keyword];
}

class KeywordCleared extends SelectDeviceEvent {
  const KeywordCleared();

  @override
  List<Object?> get props => [];
}

class DeviceItemToggled extends SelectDeviceEvent {
  const DeviceItemToggled(
    this.device,
    this.value,
  );

  final BatchSettingDevice device;
  final bool value;

  @override
  List<Object?> get props => [
        device,
        value,
      ];
}

class AllDeviceItemsSelected extends SelectDeviceEvent {
  const AllDeviceItemsSelected();

  @override
  List<Object?> get props => [];
}

class AllDeviceItemsDeselected extends SelectDeviceEvent {
  const AllDeviceItemsDeselected();

  @override
  List<Object?> get props => [];
}

class BatchDeviceSettingPageRequested extends SelectDeviceEvent {
  const BatchDeviceSettingPageRequested();

  @override
  List<Object?> get props => [];
}
