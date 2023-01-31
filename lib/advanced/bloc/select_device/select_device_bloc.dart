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
    on<KeywordChanged>(_onKeywordChanged);
    on<DeviceDataSearched>(_onDeviceDataSearched);
    on<DeviceItemToggled>(_onDeviceItemToggled);

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
      Map<int, bool> selectedDeviceIds = {};

      for (BatchSettingDevice device in devices) {
        selectedDeviceIds[device.id] = false;
      }

      _allDevices.addAll(devices);
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        devices: devices,
        selectedDeviceIds: selectedDeviceIds,
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        requestErrorMsg: result[1],
      ));
    }
  }

  void _onKeywordChanged(
    KeywordChanged event,
    Emitter<SelectDeviceState> emit,
  ) {
    emit(state.copyWith(
      keyword: event.keyword,
    ));
  }

  void _onDeviceDataSearched(
    DeviceDataSearched event,
    Emitter<SelectDeviceState> emit,
  ) {
    if (state.keyword.isNotEmpty) {
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
        devices: devices,
      ));
    } else {
      emit(state.copyWith(
        devices: _allDevices,
      ));
    }
  }

  void _onDeviceItemToggled(
    DeviceItemToggled event,
    Emitter<SelectDeviceState> emit,
  ) {
    Map<int, bool> selectedDeviceIds = {};

    selectedDeviceIds.addAll(state.selectedDeviceIds);
    selectedDeviceIds[event.id] = event.value;

    emit(state.copyWith(
      selectedDeviceIds: selectedDeviceIds,
    ));
  }
}
