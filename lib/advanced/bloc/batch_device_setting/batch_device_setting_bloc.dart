import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/batch_setting_repository.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/view/device_setting_style.dart';

part 'batch_device_setting_event.dart';
part 'batch_device_setting_state.dart';

class BatchDeviceSettingBloc
    extends Bloc<BatchDeviceSettingEvent, BatchDeviceSettingState> {
  BatchDeviceSettingBloc({
    required User user,
    required int moduleId,
    required BatchSettingRepository batchSettingRepository,
  })  : _user = user,
        _moduleId = moduleId,
        _batchSettingRepository = batchSettingRepository,
        super(const BatchDeviceSettingState()) {
    on<DeviceSettingDataRequested>(_onDeviceSettingDataRequested);
    on<ControllerValueChanged>(_onControllerValueChanged);
    on<ControllerValueCleared>(_onControllerValueCleared);

    add(const DeviceSettingDataRequested());
  }

  final User _user;
  final int _moduleId;
  final BatchSettingRepository _batchSettingRepository;

  Future<List<dynamic>> _getControllerData({
    required int pageId,
    required List<List<ControllerProperty>> controllerPropertiesCollection,
    required Map<String, String> controllerValues,
    required Map<String, String> controllerInitialValues,
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

  void _onDeviceSettingDataRequested(
    DeviceSettingDataRequested event,
    Emitter<BatchDeviceSettingState> emit,
  ) async {
    emit(state.copyWith(
      isInitialController: true,
      status: FormStatus.requestInProgress,
    ));

    List<dynamic> resultOfGetDeviceBlocks =
        await _batchSettingRepository.getDeviceBlock(
      user: _user,
      moduleId: _moduleId,
    );

    if (resultOfGetDeviceBlocks[0]) {
      List<DeviceBlock> deviceBlocks = resultOfGetDeviceBlocks[1];
      Map<int, List<List<ControllerProperty>>>
          controllerPropertiesCollectionMap = {};

      Map<int, Map<String, String>> controllerValuesMap = {};
      Map<int, Map<String, String>> controllerInitialValuesMap = {};
      Map<int, bool> isControllerContainValue = {};

      for (DeviceBlock deviceBlock in deviceBlocks) {
        List<List<ControllerProperty>> controllerPropertiesCollection = [];
        Map<String, String> controllerValues = {};
        Map<String, String> controllerInitialValues = {};
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

  void _onControllerValueChanged(
    ControllerValueChanged event,
    Emitter<BatchDeviceSettingState> emit,
  ) {
    // emit(state.copyWith(
    //   status: FormStatus.requestInProgress,
    // ));
    Map<int, Map<String, String>> controllerValuesMap = {};
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
    controllerValuesMap[event.pageId]![event.oid] = event.value;

    emit(state.copyWith(
      // status: FormStatus.requestSuccess,
      controllerValuesMap: controllerValuesMap,
      isControllerContainValue: isControllContainValue,
      isInitialController: false,
    ));
  }

  void _onControllerValueCleared(
    ControllerValueCleared event,
    Emitter<BatchDeviceSettingState> emit,
  ) {
    Map<int, bool> isControllContainValue = {};
    Map<int, Map<String, String>> controllerValuesMap = {};

    isControllContainValue.addAll(state.isControllerContainValue);
    isControllContainValue[event.pageId] = false;

    for (int pageId in state.controllerValuesMap.keys) {
      controllerValuesMap[pageId] = {};
      if (pageId == event.pageId) {
        for (MapEntry entry in state.controllerValuesMap[pageId]!.entries) {
          controllerValuesMap[pageId]![entry.key] = '';
        }
      } else {
        for (MapEntry entry in state.controllerValuesMap[pageId]!.entries) {
          controllerValuesMap[pageId]![entry.key] = entry.value;
        }
      }
    }

    emit(state.copyWith(
      controllerValuesMap: controllerValuesMap,
      isControllerContainValue: isControllContainValue,
      isInitialController: false,
    ));
  }

  // void _onModuleDataSearched(
  //   ModuleDataSearched event,
  //   Emitter<BatchDeviceSettingState> emit,
  // ) {
  //   if (state.keyword.isNotEmpty) {
  //     List<Module> modules = [];

  //     modules = _allModules
  //         .where((module) =>
  //             module.name.toLowerCase().contains(state.keyword.toLowerCase()))
  //         .toList();

  //     emit(state.copyWith(
  //       modules: modules,
  //     ));
  //   } else {
  //     emit(state.copyWith(
  //       modules: _allModules,
  //     ));
  //   }
  // }
}
