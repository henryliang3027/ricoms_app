part of 'batch_device_setting_bloc.dart';

class BatchDeviceSettingState extends Equatable {
  const BatchDeviceSettingState({
    this.status = FormStatus.none,
    this.deviceBlocks = const [],
    this.controllerPropertiesCollectionMap = const {},
    this.controllerValuesMap = const {},
    this.controllerInitialValuesMap = const {},
    this.requestErrorMsg = '',
  });

  final FormStatus status;
  final List<DeviceBlock> deviceBlocks;
  final Map<int, List<List<ControllerProperty>>>
      controllerPropertiesCollectionMap;
  final Map<int, Map<String, String>> controllerValuesMap;
  final Map<int, Map<String, String>> controllerInitialValuesMap;
  final String requestErrorMsg;

  BatchDeviceSettingState copyWith({
    FormStatus? status,
    List<DeviceBlock>? deviceBlocks,
    Map<int, List<List<ControllerProperty>>>? controllerPropertiesCollectionMap,
    Map<int, Map<String, String>>? controllerValuesMap,
    Map<int, Map<String, String>>? controllerInitialValuesMap,
    String? requestErrorMsg,
  }) {
    return BatchDeviceSettingState(
      status: status ?? this.status,
      deviceBlocks: deviceBlocks ?? this.deviceBlocks,
      controllerPropertiesCollectionMap: controllerPropertiesCollectionMap ??
          this.controllerPropertiesCollectionMap,
      controllerInitialValuesMap:
          controllerInitialValuesMap ?? this.controllerInitialValuesMap,
      controllerValuesMap: controllerValuesMap ?? this.controllerValuesMap,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        deviceBlocks,
        controllerPropertiesCollectionMap,
        controllerValuesMap,
        controllerInitialValuesMap,
        requestErrorMsg,
      ];
}
