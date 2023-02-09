import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/batch_setting_device.dart';
import 'package:ricoms_app/repository/batch_setting_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
part 'device_setting_result_event.dart';
part 'device_setting_result_state.dart';

class DeviceSettingResultBloc
    extends Bloc<DeviceSettingResultEvent, DeviceSettingResultState> {
  DeviceSettingResultBloc({
    required User user,
    required List<BatchSettingDevice> devices,
    required Map<String, String> deviceParamsMap,
    required BatchSettingRepository batchSettingRepository,
  })  : _user = user,
        _devices = devices,
        _deviceParamsMap = deviceParamsMap,
        _batchSettingRepository = batchSettingRepository,
        super(const DeviceSettingResultState()) {
    on<InitialDeviceParamRequested>(_onInitialDeviceParamRequested);
    on<SetDeviceParamRequested>(_onSetDeviceParamRequested,
        transformer: concurrent());
    on<RetryFailedSettingRequested>(_onRetryFailedSettingRequested);
    on<RetrySetDeviceParamsRequested>(_onRetrySetDeviceParamsRequested,
        transformer: concurrent());
    on<DeviceParamItemSelected>(_onDeviceParamItemSelected);
    on<AllDeviceParamItemsSelected>(_onAllDeviceParamItemsSelected);
    on<AllDeviceParamItemsDeselected>(_onAllDeviceParamItemsDeselected);

    add(const InitialDeviceParamRequested());
  }

  final User _user;
  final List<BatchSettingDevice> _devices;
  final Map<String, String> _deviceParamsMap;
  final BatchSettingRepository _batchSettingRepository;

  void _onInitialDeviceParamRequested(
    InitialDeviceParamRequested event,
    Emitter<DeviceSettingResultState> emit,
  ) {
    List<List<DeviceParamItem>> deviceParamItemsCollection = [];
    List<List<ProcessingStatus>> deviceProcessingStatusCollection = [];
    List<List<bool>> isSelectedDevicesCollection = [];
    List<List<ResultDetail>> resultDetailsCollection = [];
    for (BatchSettingDevice device in _devices) {
      List<DeviceParamItem> deviceParamItems = [];
      List<ProcessingStatus> deviceProcessingStatusList = [];
      List<bool> isSelectedDevices = [];
      List<ResultDetail> resultDetails = [];
      for (MapEntry entry in _deviceParamsMap.entries) {
        deviceParamItems.add(DeviceParamItem(
          id: device.id,
          ip: device.ip,
          deviceName: device.deviceName,
          group: device.group,
          moduleName: device.moduleName,
          shelf: device.shelf,
          slot: device.slot,
          oid: entry.key,
          param: entry.value,
        ));

        deviceProcessingStatusList.add(ProcessingStatus.processing);
        isSelectedDevices.add(false);
        resultDetails.add(const ResultDetail(
          processingStatus: ProcessingStatus.processing,
          description: '',
          endTime: '',
        ));
      }
      deviceParamItemsCollection.add(deviceParamItems);
      deviceProcessingStatusCollection.add(deviceProcessingStatusList);
      isSelectedDevicesCollection.add(isSelectedDevices);
      resultDetailsCollection.add(resultDetails);
    }
    emit(state.copyWith(
      deviceParamItemsCollection: deviceParamItemsCollection,
      deviceProcessingStatusCollection: deviceProcessingStatusCollection,
      isSelectedDevicesCollection: isSelectedDevicesCollection,
      resultDetailsCollection: resultDetailsCollection,
    ));

    for (int i = 0; i < deviceParamItemsCollection.length; i++) {
      add(SetDeviceParamRequested(i));
    }
  }

  void _onSetDeviceParamRequested(
    SetDeviceParamRequested event,
    Emitter<DeviceSettingResultState> emit,
  ) async {
    int indexOfDevice = event.indexOfDevice;
    List<DeviceParamItem> deviceParamItems =
        state.deviceParamItemsCollection[indexOfDevice];

    for (int i = 0; i < deviceParamItems.length; i++) {
      List<List<ProcessingStatus>> newDeviceProcessingStatusCollection = [];
      ResultDetail resultDetail = await setDeviceParam(
          indexOfDevice: indexOfDevice,
          indexOfParam: i,
          deviceParamItem: deviceParamItems[i],
          newDeviceProcessingStatusCollection:
              newDeviceProcessingStatusCollection);

      List<List<ResultDetail>> resultDetailsCollection =
          state.resultDetailsCollection;

      resultDetailsCollection[indexOfDevice][i] = resultDetail;

      emit(state.copyWith(
        deviceProcessingStatusCollection: newDeviceProcessingStatusCollection,
        resultDetailsCollection: resultDetailsCollection,
      ));
    }
  }

  void _onRetryFailedSettingRequested(
    RetryFailedSettingRequested event,
    Emitter<DeviceSettingResultState> emit,
  ) async {
    // deep copy DeviceProcessingStatusCollection
    List<List<ProcessingStatus>> newDeviceProcessingStatusCollection = [];
    for (List<ProcessingStatus> deviceProcessingStatusList
        in state.deviceProcessingStatusCollection) {
      List<ProcessingStatus> newDeviceProcessingStatusList = [];
      for (ProcessingStatus deviceProcessingStatus
          in deviceProcessingStatusList) {
        newDeviceProcessingStatusList.add(deviceProcessingStatus);
      }
      newDeviceProcessingStatusCollection.add(newDeviceProcessingStatusList);
    }

    // iterate isSelectedDevicesCollection and check if it is true,
    // set correspond DeviceProcessingStatus to ProcessingStatus.processing
    for (int i = 0; i < state.isSelectedDevicesCollection.length; i++) {
      for (int j = 0; j < state.isSelectedDevicesCollection[i].length; j++) {
        bool isSelected = state.isSelectedDevicesCollection[i][j];
        if (isSelected) {
          newDeviceProcessingStatusCollection[i][j] =
              ProcessingStatus.processing;
        }
      }
    }

    emit(state.copyWith(
        deviceProcessingStatusCollection: newDeviceProcessingStatusCollection));

    for (int i = 0; i < state.deviceParamItemsCollection.length; i++) {
      add(RetrySetDeviceParamsRequested(i));
    }
  }

  void _onRetrySetDeviceParamsRequested(
    RetrySetDeviceParamsRequested event,
    Emitter<DeviceSettingResultState> emit,
  ) async {
    int indexOfDevice = event.indexOfDevice;
    List<DeviceParamItem> deviceParamItems =
        state.deviceParamItemsCollection[indexOfDevice];

    for (int i = 0; i < deviceParamItems.length; i++) {
      if (state.isSelectedDevicesCollection[indexOfDevice][i] == true) {
        List<List<ProcessingStatus>> newDeviceProcessingStatusCollection = [];
        ResultDetail resultDetail = await setDeviceParam(
            indexOfDevice: indexOfDevice,
            indexOfParam: i,
            deviceParamItem: deviceParamItems[i],
            newDeviceProcessingStatusCollection:
                newDeviceProcessingStatusCollection);

        List<List<ResultDetail>> resultDetailsCollection =
            state.resultDetailsCollection;

        resultDetailsCollection[indexOfDevice][i] = resultDetail;

        emit(state.copyWith(
          deviceProcessingStatusCollection: newDeviceProcessingStatusCollection,
          resultDetailsCollection: resultDetailsCollection,
        ));
      }
    }
  }

  Future<ResultDetail> setDeviceParam({
    required int indexOfDevice,
    required int indexOfParam,
    required DeviceParamItem deviceParamItem,
    required List<List<ProcessingStatus>> newDeviceProcessingStatusCollection,
  }) async {
    // List<int> secs = [1, 1, 1, 1, 1, 1];
    // print(indexOfDevice * 3 + indexOfParam);
    List<dynamic> resultOfSetDeviceParam =
        await _batchSettingRepository.setDeviceParameter(
      user: _user,
      deviceParamItem: deviceParamItem,
      // sec: secs[indexOfDevice * 3 + indexOfParam],
    );

    // deep copy DeviceProcessingStatusCollection
    for (List<ProcessingStatus> deviceProcessingStatusList
        in state.deviceProcessingStatusCollection) {
      List<ProcessingStatus> newDeviceProcessingStatusList = [];
      for (ProcessingStatus deviceProcessingStatus
          in deviceProcessingStatusList) {
        newDeviceProcessingStatusList.add(deviceProcessingStatus);
      }
      newDeviceProcessingStatusCollection.add(newDeviceProcessingStatusList);
    }

    if (resultOfSetDeviceParam[0]) {
      newDeviceProcessingStatusCollection[indexOfDevice][indexOfParam] =
          ProcessingStatus.success;
    } else {
      newDeviceProcessingStatusCollection[indexOfDevice][indexOfParam] =
          ProcessingStatus.failure;
    }

    return ResultDetail(
      processingStatus: newDeviceProcessingStatusCollection[indexOfDevice]
          [indexOfParam],
      description: resultOfSetDeviceParam[1],
      endTime: resultOfSetDeviceParam[2],
    );
  }

  void _onDeviceParamItemSelected(
    DeviceParamItemSelected event,
    Emitter<DeviceSettingResultState> emit,
  ) {
    int indexOfDevice =
        event.index ~/ state.deviceParamItemsCollection.first.length;
    int indexOfParam =
        event.index % state.deviceParamItemsCollection.first.length;

    print('list item ${event.index} is in ${indexOfDevice} ${indexOfParam}');

    List<List<bool>> newIsSelectedDevicesCollection = [];

    for (List<bool> isSelectedDevices in state.isSelectedDevicesCollection) {
      List<bool> newIsSelectedDevices = [];
      for (bool isSelected in isSelectedDevices) {
        newIsSelectedDevices.add(isSelected);
      }
      newIsSelectedDevicesCollection.add(newIsSelectedDevices);
    }
    newIsSelectedDevicesCollection[indexOfDevice][indexOfParam] = event.value;

    emit(state.copyWith(
      isSelectedDevicesCollection: newIsSelectedDevicesCollection,
    ));
  }

  void _onAllDeviceParamItemsSelected(
    AllDeviceParamItemsSelected event,
    Emitter<DeviceSettingResultState> emit,
  ) {
    List<List<bool>> newIsSelectedDevicesCollection = [];

    for (List<bool> isSelectedDevices in state.isSelectedDevicesCollection) {
      List<bool> newIsSelectedDevices = [];
      for (bool isSelected in isSelectedDevices) {
        newIsSelectedDevices.add(isSelected);
      }
      newIsSelectedDevicesCollection.add(newIsSelectedDevices);
    }

    for (int i = 0; i < state.isSelectedDevicesCollection.length; i++) {
      for (int j = 0; j < state.isSelectedDevicesCollection[i].length; j++) {
        if (state.deviceProcessingStatusCollection[i][j] ==
            ProcessingStatus.failure) {
          newIsSelectedDevicesCollection[i][j] = true;
        }
      }
    }

    emit(state.copyWith(
      isSelectedDevicesCollection: newIsSelectedDevicesCollection,
    ));
  }

  void _onAllDeviceParamItemsDeselected(
    AllDeviceParamItemsDeselected event,
    Emitter<DeviceSettingResultState> emit,
  ) {
    List<List<bool>> newIsSelectedDevicesCollection = [];

    for (List<bool> isSelectedDevices in state.isSelectedDevicesCollection) {
      List<bool> newIsSelectedDevices = [];
      for (bool isSelected in isSelectedDevices) {
        newIsSelectedDevices.add(false);
      }
      newIsSelectedDevicesCollection.add(newIsSelectedDevices);
    }

    emit(state.copyWith(
      isSelectedDevicesCollection: newIsSelectedDevicesCollection,
    ));
  }
}

class DeviceParamItem {
  const DeviceParamItem({
    required this.id,
    required this.ip,
    required this.deviceName,
    required this.group,
    required this.moduleName,
    required this.shelf,
    required this.slot,
    required this.oid,
    required this.param,
  });

  final int id;
  final String ip;
  final String deviceName;
  final String group;
  final String moduleName;
  final int shelf;
  final int slot;
  final String oid;
  final String param;
}

class ResultDetail {
  const ResultDetail({
    required this.processingStatus,
    required this.description,
    required this.endTime,
  });

  final ProcessingStatus processingStatus;
  final String description;
  final String endTime;
}
