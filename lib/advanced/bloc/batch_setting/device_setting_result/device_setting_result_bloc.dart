import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/batch_setting_device.dart';
import 'package:ricoms_app/repository/batch_setting_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
part 'device_setting_result_event.dart';
part 'device_setting_result_state.dart';

//test

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
    for (BatchSettingDevice device in _devices) {
      List<DeviceParamItem> deviceParamItems = [];
      List<ProcessingStatus> deviceProcessingStatusList = [];
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
      }
      deviceParamItemsCollection.add(deviceParamItems);
      deviceProcessingStatusCollection.add(deviceProcessingStatusList);
    }
    emit(state.copyWith(
      deviceParamItemsCollection: deviceParamItemsCollection,
      deviceProcessingStatusCollection: deviceProcessingStatusCollection,
    ));

    // for (int i = 0; i < deviceParamItemsCollection.length; i++) {
    //   add(SetDeviceParamRequested(i));
    // }

    for (int i = 0; i < deviceParamItemsCollection.length; i++) {
      setDeviceParams(
        indexOfDevice: i,
        deviceParamItems: deviceParamItemsCollection[i],
        emit: emit,
      );
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
      List<List<ProcessingStatus>> deviceProcessingStatusCollection =
          await setDeviceParam(
              indexOfDevice: indexOfDevice,
              indexOfParam: i,
              deviceParamItem: deviceParamItems[i]);

      emit(state.copyWith(
        deviceProcessingStatusCollection: deviceProcessingStatusCollection,
      ));
    }
  }

  Future<void> setDeviceParams({
    required int indexOfDevice,
    required List<DeviceParamItem> deviceParamItems,
    required Emitter<DeviceSettingResultState> emit,
  }) async {
    for (int i = 0; i < deviceParamItems.length; i++) {
      List<dynamic> resultOfSetDeviceParam =
          await _batchSettingRepository.setDeviceParameter(
        user: _user,
        deviceParamItem: deviceParamItems[i],
        // sec: secs[indexOfDevice * 3 + indexOfParam],
      );

      // copy DeviceProcessingStatusCollection
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

      if (resultOfSetDeviceParam[0]) {
        newDeviceProcessingStatusCollection[indexOfDevice][i] =
            ProcessingStatus.success;

        emit(state.copyWith(
          deviceProcessingStatusCollection: newDeviceProcessingStatusCollection,
        ));
      } else {
        newDeviceProcessingStatusCollection[indexOfDevice][i] =
            ProcessingStatus.failure;

        emit(state.copyWith(
          deviceProcessingStatusCollection: newDeviceProcessingStatusCollection,
        ));
      }
    }
  }

  Future<List<List<ProcessingStatus>>> setDeviceParam({
    required int indexOfDevice,
    required int indexOfParam,
    required DeviceParamItem deviceParamItem,
  }) async {
    // mock delay time (sec)
    // List<int> secs = [1, 3, 2, 1, 2, 3];
    // print(indexOfDevice * 3 + indexOfParam);
    // List<dynamic> resultOfSetDeviceParam =
    //     await _batchSettingRepository.testDeviceParameter(
    //   user: _user,
    //   deviceParamItem: deviceParamItem,
    //   sec: secs[indexOfDevice * 3 + indexOfParam],
    // );

    List<dynamic> resultOfSetDeviceParam =
        await _batchSettingRepository.setDeviceParameter(
      user: _user,
      deviceParamItem: deviceParamItem,
      // sec: secs[indexOfDevice * 3 + indexOfParam],
    );

    // copy DeviceProcessingStatusCollection
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

    if (resultOfSetDeviceParam[0]) {
      newDeviceProcessingStatusCollection[indexOfDevice][indexOfParam] =
          ProcessingStatus.success;

      return newDeviceProcessingStatusCollection;
    } else {
      newDeviceProcessingStatusCollection[indexOfDevice][indexOfParam] =
          ProcessingStatus.failure;

      return newDeviceProcessingStatusCollection;
    }
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
