import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/batch_setting_device.dart';
import 'package:ricoms_app/repository/batch_setting_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'select_device_event.dart';
part 'select_device_state.dart';

class SelectDeviceBloc extends Bloc<SelectDeviceEvent, SelectDeviceState> {
  SelectDeviceBloc({
    required User user,
    required int moduleId,
    required BatchSettingRepository batchSettingRepository,
  })  : _user = user,
        _moduleId = moduleId,
        _batchSettingRepository = batchSettingRepository,
        super(const SelectDeviceState()) {
    on<DeviceDataRequested>(_onDeviceDataRequested);
    on<KeywordCleared>(_onKeywordCleared);
    on<KeywordSearched>(_onKeywordSearched);
    on<DeviceItemToggled>(_onDeviceItemToggled);
    on<AllDeviceItemsSelected>(_onAllDeviceItemsSelected);
    on<AllDeviceItemsDeselected>(_onAllDeviceItemsDeselected);

    add(const DeviceDataRequested());
  }

  final User _user;
  final int _moduleId;
  final BatchSettingRepository _batchSettingRepository;
  final List<BatchSettingDevice> _allDevices = [];

  void _onDeviceDataRequested(
    DeviceDataRequested event,
    Emitter<SelectDeviceState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    List<dynamic> result = await _batchSettingRepository.getDeviceData(
      user: _user,
      moduleId: _moduleId,
    );

    if (result[0]) {
      List<BatchSettingDevice> devices = result[1];
      Map<BatchSettingDevice, bool> selectedDevices = {};

      for (BatchSettingDevice device in devices) {
        selectedDevices[device] = false;
      }

      _allDevices.addAll(devices);
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        devices: devices,
        selectedDevices: selectedDevices,
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        requestErrorMsg: result[1],
      ));
    }
  }

  void _onKeywordSearched(
    KeywordSearched event,
    Emitter<SelectDeviceState> emit,
  ) {
    if (event.keyword.isNotEmpty) {
      List<BatchSettingDevice> devices = [];

      devices = _allDevices.where((device) {
        if (device.ip.toLowerCase().contains(state.keyword.toLowerCase()) ||
            device.group.toLowerCase().contains(state.keyword.toLowerCase()) ||
            device.deviceName
                .toLowerCase()
                .contains(state.keyword.toLowerCase()) ||
            device.moduleName
                .toLowerCase()
                .contains(state.keyword.toLowerCase())) {
          return true;
        } else {
          return false;
        }
      }).toList();

      emit(state.copyWith(
        keyword: event.keyword,
        devices: devices,
      ));
    } else {
      emit(state.copyWith(
        keyword: event.keyword,
        devices: _allDevices,
      ));
    }
  }

  void _onKeywordCleared(
    KeywordCleared event,
    Emitter<SelectDeviceState> emit,
  ) {
    emit(state.copyWith(
      keyword: '',
      devices: _allDevices,
    ));
  }

  void _onDeviceItemToggled(
    DeviceItemToggled event,
    Emitter<SelectDeviceState> emit,
  ) {
    Map<BatchSettingDevice, bool> selectedDevices = {};

    selectedDevices.addAll(state.selectedDevices);
    selectedDevices[event.device] = event.value;

    emit(state.copyWith(
      selectedDevices: selectedDevices,
    ));
  }

  void _onAllDeviceItemsSelected(
    AllDeviceItemsSelected event,
    Emitter<SelectDeviceState> emit,
  ) {
    Map<BatchSettingDevice, bool> selectedDevices = {};

    selectedDevices.addAll(state.selectedDevices);

    for (BatchSettingDevice device in selectedDevices.keys) {
      selectedDevices[device] = true;
    }

    emit(state.copyWith(
      selectedDevices: selectedDevices,
    ));
  }

  void _onAllDeviceItemsDeselected(
    AllDeviceItemsDeselected event,
    Emitter<SelectDeviceState> emit,
  ) {
    Map<BatchSettingDevice, bool> selectedDevices = {};

    selectedDevices.addAll(state.selectedDevices);

    for (BatchSettingDevice device in selectedDevices.keys) {
      selectedDevices[device] = false;
    }

    emit(state.copyWith(
      selectedDevices: selectedDevices,
    ));
  }
}
