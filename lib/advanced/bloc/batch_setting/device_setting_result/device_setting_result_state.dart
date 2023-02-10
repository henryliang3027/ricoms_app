part of 'device_setting_result_bloc.dart';

class DeviceSettingResultState extends Equatable {
  const DeviceSettingResultState({
    this.deviceParamItemsCollection = const [],
    this.deviceProcessingStatusCollection = const [],
    this.isSelectedDevicesCollection = const [],
    this.resultDetailsCollection = const [],
  });

  final List<List<DeviceParamItem>> deviceParamItemsCollection;
  final List<List<ProcessingStatus>> deviceProcessingStatusCollection;
  final List<List<bool>> isSelectedDevicesCollection;
  final List<List<ResultDetail>> resultDetailsCollection;

  DeviceSettingResultState copyWith({
    List<List<DeviceParamItem>>? deviceParamItemsCollection,
    List<List<ProcessingStatus>>? deviceProcessingStatusCollection,
    List<List<bool>>? isSelectedDevicesCollection,
    List<List<ResultDetail>>? resultDetailsCollection,
  }) {
    return DeviceSettingResultState(
      deviceParamItemsCollection:
          deviceParamItemsCollection ?? this.deviceParamItemsCollection,
      deviceProcessingStatusCollection: deviceProcessingStatusCollection ??
          this.deviceProcessingStatusCollection,
      isSelectedDevicesCollection:
          isSelectedDevicesCollection ?? this.isSelectedDevicesCollection,
      resultDetailsCollection:
          resultDetailsCollection ?? this.resultDetailsCollection,
    );
  }

  @override
  List<Object> get props => [
        deviceParamItemsCollection,
        deviceProcessingStatusCollection,
        isSelectedDevicesCollection,
        resultDetailsCollection,
      ];
}

enum ProcessingStatus {
  processing,
  success,
  failure,
}
