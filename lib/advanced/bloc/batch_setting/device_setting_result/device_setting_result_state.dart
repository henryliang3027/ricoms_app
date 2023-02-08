part of 'device_setting_result_bloc.dart';

class DeviceSettingResultState extends Equatable {
  const DeviceSettingResultState({
    this.deviceParamItemsCollection = const [],
    this.deviceProcessingStatusCollection = const [],
    this.isSelectedDevicesCollection = const [],
  });

  final List<List<DeviceParamItem>> deviceParamItemsCollection;
  final List<List<ProcessingStatus>> deviceProcessingStatusCollection;
  final List<List<bool>> isSelectedDevicesCollection;

  DeviceSettingResultState copyWith({
    List<List<DeviceParamItem>>? deviceParamItemsCollection,
    List<List<ProcessingStatus>>? deviceProcessingStatusCollection,
    List<List<bool>>? isSelectedDevicesCollection,
  }) {
    return DeviceSettingResultState(
      deviceParamItemsCollection:
          deviceParamItemsCollection ?? this.deviceParamItemsCollection,
      deviceProcessingStatusCollection: deviceProcessingStatusCollection ??
          this.deviceProcessingStatusCollection,
      isSelectedDevicesCollection:
          isSelectedDevicesCollection ?? this.isSelectedDevicesCollection,
    );
  }

  @override
  List<Object> get props => [
        deviceParamItemsCollection,
        deviceProcessingStatusCollection,
        isSelectedDevicesCollection,
      ];
}

enum ProcessingStatus {
  processing,
  success,
  failure,
}
