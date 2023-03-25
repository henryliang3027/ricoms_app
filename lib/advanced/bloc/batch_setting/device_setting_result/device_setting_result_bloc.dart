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
  final List<BatchSettingDevice> _devices; // batch setting devices
  final Map<String, String> _deviceParamsMap; // oid : 設定值
  final BatchSettingRepository _batchSettingRepository;
  final _maximumNumberOfRetries = 3; // 最多 retry 次數

  /// 建立每個 device 要設定的參數項目,
  /// 項目會包含一到多個 device, 一個 device 會有多個需要設定的參數,
  void _onInitialDeviceParamRequested(
    InitialDeviceParamRequested event,
    Emitter<DeviceSettingResultState> emit,
  ) {
    List<List<DeviceParamItem>> deviceParamItemsCollection =
        []; // 多個 device 有多個參數設定項目
    List<List<ProcessingStatus>> deviceProcessingStatusCollection = [];
    List<List<bool>> isSelectedDevicesCollection = [];
    List<List<ResultDetail>> resultDetailsCollection = [];

    for (BatchSettingDevice device in _devices) {
      // 為單一個 device 建立參數設定項目 List<DeviceParamItem> deviceParamItems
      // 參數設定項目的處理狀態 List<ProcessingStatus> deviceProcessingStatusList
      // 參數設定項目是否被選取(retry用) List<ResultDetail> isSelectedDevices
      // 參數設定項目的設定結果 List<ResultDetail> resultDetails
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

    // 將每一個 device 加到 bloc event 處理, 達到同時對每個 device 執行參數設定
    for (int i = 0; i < deviceParamItemsCollection.length; i++) {
      add(SetDeviceParamRequested(i));
    }
  }

  /// 簞一個 device 裡的多個參數會循序進行設定
  void _onSetDeviceParamRequested(
    SetDeviceParamRequested event,
    Emitter<DeviceSettingResultState> emit,
  ) async {
    int indexOfDevice = event.indexOfDevice;
    List<DeviceParamItem> deviceParamItems =
        state.deviceParamItemsCollection[indexOfDevice];

    for (int i = 0; i < deviceParamItems.length; i++) {
      List<List<ProcessingStatus>> newDeviceProcessingStatusCollection = [];

      // await 關鍵字, 會等待目前參數設定完, 再設定下一個
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

  /// retry 設定失敗的項目, 選中的項目中如果有不同 device 則同時進行 retry, 一個 device 內的多個參數會循序 retry
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

    List<List<bool>> tempSelectedDevicesCollection = [];
    for (List selectedDevices in state.isSelectedDevicesCollection) {
      List<bool> tempSelectedDevices = [];
      for (bool isSelected in selectedDevices) {
        tempSelectedDevices.add(isSelected);
      }
      tempSelectedDevicesCollection.add(tempSelectedDevices);
    }

    emit(state.copyWith(
      isSelectedDevicesCollection: deselectAllFailureItems(),
      deviceProcessingStatusCollection: newDeviceProcessingStatusCollection,
    ));

    for (int i = 0; i < state.deviceParamItemsCollection.length; i++) {
      if (tempSelectedDevicesCollection[i].contains(true)) {
        add(RetrySetDeviceParamsRequested(i, tempSelectedDevicesCollection[i]));
      }
    }
  }

  /// 簞一個 device 裡的多個參數會循序進行 retry
  void _onRetrySetDeviceParamsRequested(
    RetrySetDeviceParamsRequested event,
    Emitter<DeviceSettingResultState> emit,
  ) async {
    int indexOfDevice = event.indexOfDevice;
    List<DeviceParamItem> deviceParamItems =
        state.deviceParamItemsCollection[indexOfDevice];

    for (int i = 0; i < deviceParamItems.length; i++) {
      if (event.isSelectedDevices[i] == true) {
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

  /// 藉由 api 設定參數
  Future<ResultDetail> setDeviceParam({
    required int indexOfDevice,
    required int indexOfParam,
    required DeviceParamItem deviceParamItem,
    required List<List<ProcessingStatus>> newDeviceProcessingStatusCollection,
  }) async {
    // List<int> secs = [1, 1, 1, 1, 1, 1];
    // print(indexOfDevice * 3 + indexOfParam);
    List<dynamic> resultOfSetDeviceParam = [];

    for (int i = 0; i < _maximumNumberOfRetries; i++) {
      resultOfSetDeviceParam = await _batchSettingRepository.setDeviceParameter(
        user: _user,
        deviceParamItem: deviceParamItem,
        // sec: secs[indexOfDevice * 3 + indexOfParam],
      );

      // break if successful, otherwise retry
      if (resultOfSetDeviceParam[0]) {
        break;
      }
    }

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

    print('${indexOfDevice}, ${indexOfParam} done');

    return ResultDetail(
      processingStatus: newDeviceProcessingStatusCollection[indexOfDevice]
          [indexOfParam],
      description: resultOfSetDeviceParam[1],
      endTime: resultOfSetDeviceParam[2],
    );
  }

  /// 處理失敗的項目的選取
  void _onDeviceParamItemSelected(
    DeviceParamItemSelected event,
    Emitter<DeviceSettingResultState> emit,
  ) {
    // 利用項目的 index 換算出 device 的 index
    int indexOfDevice =
        event.index ~/ state.deviceParamItemsCollection.first.length;

    // 利用項目的 index 換算出參數的 index
    int indexOfParam =
        event.index % state.deviceParamItemsCollection.first.length;

    // ex: 選取一個項目 index = 8, 每個 device 總共有 3 個參數要設定
    // 所以是第2個 device (8 ~/ 3 = 2)
    // 的第2個參數 (8 % 3 = 2)
    // print('list item ${event.index} is in ${indexOfDevice} ${indexOfParam}');

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

  /// 處理失敗的項目的全部選取
  void _onAllDeviceParamItemsSelected(
    AllDeviceParamItemsSelected event,
    Emitter<DeviceSettingResultState> emit,
  ) {
    List<List<bool>> newIsSelectedDevicesCollection = selectAllFailureItems();

    emit(state.copyWith(
      isSelectedDevicesCollection: newIsSelectedDevicesCollection,
    ));
  }

  /// 處理失敗的項目的全部取消選取
  void _onAllDeviceParamItemsDeselected(
    AllDeviceParamItemsDeselected event,
    Emitter<DeviceSettingResultState> emit,
  ) {
    List<List<bool>> newIsSelectedDevicesCollection = deselectAllFailureItems();

    emit(state.copyWith(
      isSelectedDevicesCollection: newIsSelectedDevicesCollection,
    ));
  }

  /// 全部取消選取失敗的項目
  List<List<bool>> deselectAllFailureItems() {
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
          newIsSelectedDevicesCollection[i][j] = false;
        }
      }
    }

    return newIsSelectedDevicesCollection;
  }

  /// 全部選取失敗的項目
  List<List<bool>> selectAllFailureItems() {
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

    return newIsSelectedDevicesCollection;
  }
}

/// 儲存單一項目
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

/// 儲存單一項目的設定結果
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
