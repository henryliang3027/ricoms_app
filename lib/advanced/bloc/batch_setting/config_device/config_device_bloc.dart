import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/advanced_repository/batch_setting_repository/batch_setting_repository.dart';
import 'package:ricoms_app/repository/root_repository/device_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/models/custom_input.dart';
import 'package:ricoms_app/root/view/device_setting_style.dart';

part 'config_device_event.dart';
part 'config_device_state.dart';

class ConfigDeviceBloc extends Bloc<ConfigDeviceEvent, ConfigDeviceState> {
  ConfigDeviceBloc({
    required User user,
    required int moduleId,
    required BatchSettingRepository batchSettingRepository,
  })  : _user = user,
        _moduleId = moduleId,
        _batchSettingRepository = batchSettingRepository,
        super(const ConfigDeviceState()) {
    on<DeviceSettingDataRequested>(_onDeviceSettingDataRequested);
    on<ControllerValueChanged>(_onControllerValueChanged);
    on<ControllerValueCleared>(_onControllerValueCleared);

    add(const DeviceSettingDataRequested());
  }

  final User _user;
  final int _moduleId;
  final BatchSettingRepository _batchSettingRepository;

  /// 將 json data 轉換為 ui 元件所需的資料
  Future<List<dynamic>> _getControllerData({
    required int pageId,
    required List<List<ControllerProperty>> controllerPropertiesCollection,
    required Map<String, dynamic> controllerValues,
    required Map<String, dynamic> controllerInitialValues,
  }) async {
    dynamic result = await _batchSettingRepository.getDevicePageData(
      user: _user,
      moduleId: _moduleId,
      pageId: pageId,
    );
    if (result[0]) {
      for (List item in result[1]) {
        List<ControllerProperty> controllerProperties = [];
        for (var e in item) {
          DeviceSettingStyle.getSettingData(
            e: e,
            controllerProperties: controllerProperties,
            controllerValues: controllerValues,
            controllerInitialValues: controllerInitialValues,
          );
        }
        controllerPropertiesCollection.add(controllerProperties);
      }
      return [true];
    } else {
      return [false, result[1]];
    }
  }

  /// 處理 device 參數設定的頁面建立
  void _onDeviceSettingDataRequested(
    DeviceSettingDataRequested event,
    Emitter<ConfigDeviceState> emit,
  ) async {
    emit(state.copyWith(
      isInitialController: true,
      status: FormStatus.requestInProgress,
    ));

    // 取得所有分頁
    List<dynamic> resultOfGetDeviceBlocks =
        await _batchSettingRepository.getDeviceBlock(
      user: _user,
      moduleId: _moduleId,
    );

    if (resultOfGetDeviceBlocks[0]) {
      List<DeviceBlock> deviceBlocks = resultOfGetDeviceBlocks[1];
      Map<int, List<List<ControllerProperty>>>
          controllerPropertiesCollectionMap = {};

      Map<int, Map<String, dynamic>> controllerValuesMap = {};
      Map<int, Map<String, dynamic>> controllerInitialValuesMap = {};
      Map<int, bool> isControllerContainValue = {};

      // 取得分頁的所有參數設定 json data
      for (DeviceBlock deviceBlock in deviceBlocks) {
        List<List<ControllerProperty>> controllerPropertiesCollection = [];
        Map<String, dynamic> controllerValues = {};
        Map<String, dynamic> controllerInitialValues = {};
        isControllerContainValue[deviceBlock.id] = false;

        List<dynamic> resultOfGetControllerData = await _getControllerData(
          pageId: deviceBlock.id,
          controllerPropertiesCollection: controllerPropertiesCollection,
          controllerValues: controllerValues,
          controllerInitialValues: controllerInitialValues,
        );

        if (resultOfGetControllerData[0]) {
          controllerPropertiesCollectionMap[deviceBlock.id] =
              controllerPropertiesCollection;
          controllerValuesMap[deviceBlock.id] = controllerValues;
          controllerInitialValuesMap[deviceBlock.id] = controllerInitialValues;
        } else {
          emit(state.copyWith(
            status: FormStatus.requestFailure,
            requestErrorMsg: resultOfGetControllerData[1],
          ));
          break;
        }
      }

      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        deviceBlocks: deviceBlocks,
        controllerPropertiesCollectionMap: controllerPropertiesCollectionMap,
        controllerInitialValuesMap: controllerInitialValuesMap,
        controllerValuesMap: controllerValuesMap,
        isControllerContainValue: isControllerContainValue,
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        requestErrorMsg: resultOfGetDeviceBlocks[1],
      ));
    }
  }

  /// 處理 ui 元件數值的改變
  void _onControllerValueChanged(
    ControllerValueChanged event,
    Emitter<ConfigDeviceState> emit,
  ) {
    // emit(state.copyWith(
    //   status: FormStatus.requestInProgress,
    // ));
    Map<int, Map<String, dynamic>> controllerValuesMap = {};
    Map<int, bool> isControllContainValue = {};

    isControllContainValue.addAll(state.isControllerContainValue);
    isControllContainValue[event.pageId] = true;

    // the below modification would not consider as different object
    // controllerValuesMap.addAll(state.controllerValuesMap);
    // controllerValuesMap[event.pageId]![event.oid] = event.value;
    // Use deep copy instead
    for (int pageId in state.controllerValuesMap.keys) {
      controllerValuesMap[pageId] = {};
      for (MapEntry entry in state.controllerValuesMap[pageId]!.entries) {
        controllerValuesMap[pageId]![entry.key] = entry.value;
      }
    }

    _updateControllerValuesMap(
      controllerValuesMap: controllerValuesMap,
      pageId: event.pageId,
      oid: event.oid,
      value: event.value.toString(),
    );

    emit(state.copyWith(
      // status: FormStatus.requestSuccess,
      controllerValuesMap: controllerValuesMap,
      isControllerContainValue: isControllContainValue,
      isInitialController: false,
    ));
  }

  /// 處理 ui 元件數值的清除
  void _onControllerValueCleared(
    ControllerValueCleared event,
    Emitter<ConfigDeviceState> emit,
  ) {
    Map<int, bool> isControllContainValue = {};
    Map<int, Map<String, dynamic>> controllerValuesMap = {};

    isControllContainValue.addAll(state.isControllerContainValue);
    isControllContainValue[event.pageId] = false;

    for (int pageId in state.controllerValuesMap.keys) {
      controllerValuesMap[pageId] = {};
      for (MapEntry entry in state.controllerValuesMap[pageId]!.entries) {
        controllerValuesMap[pageId]![entry.key] = entry.value;
      }
    }

    for (int pageId in state.controllerValuesMap.keys) {
      if (pageId == event.pageId) {
        for (MapEntry entry in state.controllerValuesMap[pageId]!.entries) {
          _updateControllerValuesMap(
            controllerValuesMap: controllerValuesMap,
            pageId: event.pageId,
            oid: entry.key,
            value: '',
          );
        }
      } else {
        for (MapEntry entry in state.controllerValuesMap[pageId]!.entries) {
          _updateControllerValuesMap(
            controllerValuesMap: controllerValuesMap,
            pageId: event.pageId,
            oid: entry.key,
            value: entry.value.toString(),
          );
        }
      }
    }

    emit(state.copyWith(
      controllerValuesMap: controllerValuesMap,
      isControllerContainValue: isControllContainValue,
      isInitialController: false,
    ));
  }

  /// 處理 ui 元件的數值更新
  void _updateControllerValuesMap({
    required Map<int, Map<String, dynamic>> controllerValuesMap,
    required int pageId,
    required String oid,
    required String value,
  }) {
    if (controllerValuesMap[pageId]![oid].runtimeType == Input6) {
      controllerValuesMap[pageId]![oid] = Input6.dirty(value);
    } else if (controllerValuesMap[pageId]![oid].runtimeType == Input7) {
      controllerValuesMap[pageId]![oid] = Input7.dirty(value);
    } else if (controllerValuesMap[pageId]![oid].runtimeType == Input8) {
      controllerValuesMap[pageId]![oid] = Input8.dirty(value);
    } else if (controllerValuesMap[pageId]![oid].runtimeType == Input31) {
      controllerValuesMap[pageId]![oid] = Input31.dirty(value);
    } else if (controllerValuesMap[pageId]![oid].runtimeType == Input63) {
      controllerValuesMap[pageId]![oid] = Input63.dirty(value);
    } else if (controllerValuesMap[pageId]![oid].runtimeType == InputInfinity) {
      controllerValuesMap[pageId]![oid] = InputInfinity.dirty(value);
    } else if (controllerValuesMap[pageId]![oid].runtimeType == IPv4) {
      controllerValuesMap[pageId]![oid] = IPv4.dirty(value);
    } else if (controllerValuesMap[pageId]![oid].runtimeType == IPv6) {
      controllerValuesMap[pageId]![oid] = IPv6.dirty(value);
    } else {
      controllerValuesMap[pageId]![oid] = value;
    }
  }
}
