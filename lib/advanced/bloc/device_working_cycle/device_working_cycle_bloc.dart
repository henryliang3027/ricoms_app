import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:ricoms_app/repository/device_working_cycle_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';

part 'device_working_cycle_event.dart';
part 'device_working_cycle_state.dart';

class DeviceWorkingCycleBloc
    extends Bloc<DeviceWorkingCycleEvent, DeviceWorkingCycleState> {
  DeviceWorkingCycleBloc({
    required User user,
    required DeviceWorkingCycleRepository deviceWorkingCycleRepository,
  })  : _user = user,
        _deviceWorkingCycleRepository = deviceWorkingCycleRepository,
        super(const DeviceWorkingCycleState()) {
    on<DeviceWorkingCycleRequested>(_onDeviceWorkingCycleRequested);
    on<DeviceWorkingCycleChanged>(_onDeviceWorkingCycleChanged);
    on<DeviceWorkingCycleSaved>(_onDeviceWorkingCycleSaved);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);

    add(const DeviceWorkingCycleRequested());
  }

  final User _user;
  final DeviceWorkingCycleRepository _deviceWorkingCycleRepository;

  /// 處理裝置輪詢週期的資料的獲取
  void _onDeviceWorkingCycleRequested(
    DeviceWorkingCycleRequested event,
    Emitter<DeviceWorkingCycleState> emit,
  ) async {
    List<dynamic> result =
        await _deviceWorkingCycleRepository.getWorkingCycleList(user: _user);

    if (result[0]) {
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.none,
        deviceWorkingCycleList: result[1],
        deviceWorkingCycleIndex: result[2],
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        submissionStatus: SubmissionStatus.none,
        deviceWorkingCycleList: [],
        requestErrorMsg: result[1],
      ));
    }

    emit(state.copyWith());
  }

  /// 處理裝置輪詢週期的元件的數值儲存, 向後端更新設定值
  void _onDeviceWorkingCycleSaved(
    DeviceWorkingCycleSaved event,
    Emitter<DeviceWorkingCycleState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<dynamic> result = await _deviceWorkingCycleRepository.setWorkingCycle(
        user: _user, index: state.deviceWorkingCycleIndex);

    if (result[0]) {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionSuccess,
        isEditing: false,
      ));
    } else {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionFailure,
        isEditing: true,
        submissionErrorMsg: CustomErrMsg.connectionFailed,
      ));
    }
  }

  /// 處理裝置輪詢週期的元件的數值更改
  void _onDeviceWorkingCycleChanged(
    DeviceWorkingCycleChanged event,
    Emitter<DeviceWorkingCycleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      deviceWorkingCycleIndex: event.index,
    ));
  }

  /// 處理編輯模式的開啟
  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<DeviceWorkingCycleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isEditing: true,
    ));
  }

  /// 處理編輯模式的關閉
  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<DeviceWorkingCycleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isEditing: false,
    ));
  }
}
