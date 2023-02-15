import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/view/device_setting_style.dart';
import 'package:ricoms_app/utils/common_request.dart';
import 'package:ricoms_app/utils/request_interval.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceBloc({
    required User user,
    required DeviceRepository deviceRepository,
    required int nodeId,
    required DeviceBlock deviceBlock,
    required VoidCallback descriptionChangedNotifier,
  })  : _user = user,
        _deviceRepository = deviceRepository,
        _nodeId = nodeId,
        _deviceBlock = deviceBlock,
        _descriptionChangedNotifier = descriptionChangedNotifier,
        super(const DeviceState()) {
    on<DeviceDataRequested>(_onDeviceDataRequested);
    on<DeviceRefreshRequested>(_onDeviceRefreshRequested);
    on<FormStatusChanged>(_onFormStatusChanged);
    on<DeviceParamSaved>(_onDeviceParamSaved);
    on<ControllerValueChanged>(_onControllerValueChanged);

    add(const DeviceDataRequested(RequestMode.initial));
    _dataStreamSubscription = _dataStream.listen((count) {
      if (kDebugMode) {
        print(
            'Device Setting update trigger times: $count, current state: ${_deviceBlock.name} => isEditing : ${state.isEditing}');
      }
      state.isEditing == false
          ? add(const DeviceDataRequested(RequestMode.update))
          : null;
    });

    _refreshDeviceTimer = Timer.periodic(
        const Duration(seconds: RequestInterval.deviceRefresh), (timer) {
      add(const DeviceRefreshRequested());
    });
  }

  final User _user;
  final DeviceRepository _deviceRepository;
  final int _nodeId;
  final DeviceBlock _deviceBlock;
  final VoidCallback _descriptionChangedNotifier;

  final _dataStream = Stream<int>.periodic(
      const Duration(seconds: RequestInterval.deviceSetting), (count) => count);
  StreamSubscription<int>? _dataStreamSubscription;
  Timer? _refreshDeviceTimer;

  Future<bool> _getControllerData({
    required List<List<ControllerProperty>> controllerPropertiesCollection,
    required Map<String, String> controllerValues,
    required Map<String, String> controllerInitialValues,
  }) async {
    dynamic data = await _deviceRepository.getDevicePage(
      user: _user,
      nodeId: _nodeId,
      pageId: _deviceBlock.id,
    );
    if (data is List) {
      for (List item in data) {
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
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> close() {
    _dataStreamSubscription?.cancel();
    _refreshDeviceTimer?.cancel();
    return super.close();
  }

  Future<void> _onDeviceDataRequested(
    DeviceDataRequested event,
    Emitter<DeviceState> emit,
  ) async {
    if (event.requestMode == RequestMode.initial) {
      emit(state.copyWith(
        formStatus: FormStatus.requestInProgress,
      ));
    }

    List<List<ControllerProperty>> controllerPropertiesCollection = [];
    Map<String, String> controllerValues = {};
    Map<String, String> controllerInitialValues = {};

    bool resultOfGetControllerData = await _getControllerData(
      controllerPropertiesCollection: controllerPropertiesCollection,
      controllerValues: controllerValues,
      controllerInitialValues: controllerInitialValues,
    );

    if (resultOfGetControllerData) {
      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.none,
        controllerPropertiesCollection: controllerPropertiesCollection,
        controllerValues: controllerValues,
        controllerInitialValues: controllerInitialValues,
        editable: _deviceBlock.editable,
      ));
    } else {
      emit(state.copyWith(
        formStatus: FormStatus.requestFailure,
        submissionStatus: SubmissionStatus.none,
        controllerPropertiesCollection: [],
        controllerValues: {},
        controllerInitialValues: {},
        editable: _deviceBlock.editable,
      ));
    }
  }

  void _onDeviceRefreshRequested(
    DeviceRefreshRequested event,
    Emitter<DeviceState> emit,
  ) {
    _deviceRepository.refreshDeice(
      user: _user,
      nodeId: _nodeId,
    );
  }

  void _onFormStatusChanged(
    FormStatusChanged event,
    Emitter<DeviceState> emit,
  ) {
    // emit(state.copyWith(formStatus: FormStatus.requestInProgress));

    if (event.isEditing) {
      _dataStreamSubscription?.pause();
      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.none,
        isEditing: event.isEditing,
      ));
    } else {
      _dataStreamSubscription?.resume();
      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.none,
        controllerValues: state.controllerInitialValues,
        isEditing: event.isEditing,
      ));
    }
  }

  void _onControllerValueChanged(
    ControllerValueChanged event,
    Emitter<DeviceState> emit,
  ) {
    Map<String, String> controllerValues = {};
    controllerValues.addAll(state.controllerValues);

    controllerValues[event.oid] = event.value;

    emit(state.copyWith(
      controllerValues: controllerValues,
    ));
  }

  Future<void> _onDeviceParamSaved(
    DeviceParamSaved event,
    Emitter<DeviceState> emit,
  ) async {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionInProgress));

    List result = [];
    if (_deviceBlock.name == 'Description') {
      String name = state.controllerValues['9998']!;
      String description = state.controllerValues['9999']!;
      result = await _deviceRepository.setDeviceDescription(
        user: _user,
        nodeId: _nodeId,
        name: name,
        description: description,
      );
    } else {
      List<Map<String, String>> params = [];

      for (MapEntry entry in state.controllerValues.entries) {
        if (entry.value != state.controllerInitialValues[entry.key]) {
          params.add({
            "oid_id": entry.key,
            "value": entry.value,
          });
        }
      }

      result = await _deviceRepository.setDeviceParams(
        user: _user,
        nodeId: _nodeId,
        params: params,
      );
    }

    if (result[0] == true) {
      List<List<ControllerProperty>> controllerPropertiesCollection = [];
      Map<String, String> controllerValues = {};
      Map<String, String> controllerInitialValues = {};

      bool resultOfGetControllerData = await _getControllerData(
        controllerPropertiesCollection: controllerPropertiesCollection,
        controllerValues: controllerValues,
        controllerInitialValues: controllerInitialValues,
      );

      if (resultOfGetControllerData) {
        _dataStreamSubscription?.resume();

        emit(state.copyWith(
          submissionStatus: SubmissionStatus.submissionSuccess,
          saveResultMsg: result[1],
          controllerPropertiesCollection: controllerPropertiesCollection,
          controllerValues: controllerValues,
          controllerInitialValues: controllerInitialValues,
          isEditing: false,
        ));

        if (_deviceBlock.name == 'Description') {
          _descriptionChangedNotifier();
        }
      } else {
        _dataStreamSubscription?.resume();
        emit(state.copyWith(
          submissionStatus: SubmissionStatus.submissionFailure,
          saveResultMsg: result[1],
        ));
      }
    } else {
      _dataStreamSubscription?.resume();
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionFailure,
        saveResultMsg: result[1],
      ));
    }
  }
}
