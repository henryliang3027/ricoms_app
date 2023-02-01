part of 'select_device_bloc.dart';

abstract class SelectDeviceEvent extends Equatable {
  const SelectDeviceEvent();
}

class DeviceDataRequested extends SelectDeviceEvent {
  const DeviceDataRequested();

  @override
  List<Object?> get props => [];
}

class KeywordChanged extends SelectDeviceEvent {
  const KeywordChanged(this.keyword);

  final String keyword;

  @override
  List<Object?> get props => [keyword];
}

class DeviceDataSearched extends SelectDeviceEvent {
  const DeviceDataSearched();

  @override
  List<Object?> get props => [];
}

class DeviceItemToggled extends SelectDeviceEvent {
  const DeviceItemToggled(
    this.id,
    this.value,
  );

  final int id;
  final bool value;

  @override
  List<Object?> get props => [
        id,
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
