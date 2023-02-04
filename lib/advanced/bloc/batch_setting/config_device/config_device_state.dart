part of 'config_device_bloc.dart';

class ConfigDeviceState extends Equatable {
  const ConfigDeviceState({
    this.status = FormStatus.none,
    this.deviceBlocks = const [],
    this.controllerPropertiesCollectionMap = const {},
    this.controllerValuesMap = const {},
    this.controllerInitialValuesMap = const {},
    this.isControllerContainValue = const {},
    this.isInitialController = false,
    this.requestErrorMsg = '',
  });

  final FormStatus status;
  final List<DeviceBlock> deviceBlocks;
  final Map<int, List<List<ControllerProperty>>>
      controllerPropertiesCollectionMap;
  final Map<int, Map<String, String>> controllerValuesMap;
  final Map<int, Map<String, String>> controllerInitialValuesMap;
  final Map<int, bool> isControllerContainValue;
  final bool isInitialController;
  final String requestErrorMsg;

  ConfigDeviceState copyWith({
    FormStatus? status,
    List<DeviceBlock>? deviceBlocks,
    Map<int, List<List<ControllerProperty>>>? controllerPropertiesCollectionMap,
    Map<int, Map<String, String>>? controllerValuesMap,
    Map<int, Map<String, String>>? controllerInitialValuesMap,
    Map<int, bool>? isControllerContainValue,
    bool? isInitialController,
    String? requestErrorMsg,
  }) {
    return ConfigDeviceState(
      status: status ?? this.status,
      deviceBlocks: deviceBlocks ?? this.deviceBlocks,
      controllerPropertiesCollectionMap: controllerPropertiesCollectionMap ??
          this.controllerPropertiesCollectionMap,
      controllerInitialValuesMap:
          controllerInitialValuesMap ?? this.controllerInitialValuesMap,
      controllerValuesMap: controllerValuesMap ?? this.controllerValuesMap,
      isControllerContainValue:
          isControllerContainValue ?? this.isControllerContainValue,
      isInitialController: isInitialController ?? this.isInitialController,
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
        isControllerContainValue,
        isInitialController,
        requestErrorMsg,
      ];
}
