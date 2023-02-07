part of 'device_setting_result_bloc.dart';

class DeviceSettingResultState extends Equatable {
  const DeviceSettingResultState({
    this.deviceParamItemsCollection = const [],
    this.deviceProcessingStatusCollection = const [],
  });

  final List<List<DeviceParamItem>> deviceParamItemsCollection;
  final List<List<ProcessingStatus>> deviceProcessingStatusCollection;

  DeviceSettingResultState copyWith({
    List<List<DeviceParamItem>>? deviceParamItemsCollection,
    List<List<ProcessingStatus>>? deviceProcessingStatusCollection,
  }) {
    return DeviceSettingResultState(
      deviceParamItemsCollection:
          deviceParamItemsCollection ?? this.deviceParamItemsCollection,
      deviceProcessingStatusCollection: deviceProcessingStatusCollection ??
          this.deviceProcessingStatusCollection,
    );
  }

  @override
  List<Object> get props => [
        deviceParamItemsCollection,
        deviceProcessingStatusCollection,
      ];
}

enum ProcessingStatus {
  processing,
  success,
  failure,
}
