import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/log_record_setting.dart';

import 'package:ricoms_app/repository/log_record_setting_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'log_record_setting_event.dart';
part 'log_record_setting_state.dart';

class LogRecordSettingBloc
    extends Bloc<LogRecordSettingEvent, LogRecordSettingState> {
  LogRecordSettingBloc({
    required User user,
    required LogRecordSettingRepository logRecordSettingRepository,
  })  : _user = user,
        _logRecordSettingRepository = logRecordSettingRepository,
        super(const LogRecordSettingState()) {
    on<LogRecordSettingRequested>(_onLogRecordSettingRequested);
    on<ArchivedHistoricalRecordQuanitiyChanged>(
        _onArchivedHistoricalRecordQuanitiyChanged);
    on<ApiLogPreservationEnabled>(_onApiLogPreservationEnabled);
    on<ApiLogPreservedQuantityChanged>(_onApiLogPreservedQuantityChanged);
    on<ApiLogPreservedDaysChanged>(_onApiLogPreservedDaysChanged);
    on<UserSystemLogPreservationEnabled>(_onUserSystemLogPreservationEnabled);
    on<UserSystemLogPreservedQuantityChanged>(
        _onUserSystemLogPreservedQuantityChanged);
    on<UserSystemLogPreservedDaysChanged>(_onUserSystemLogPreservedDaysChanged);
    on<DeviceSystemLogPreservationEnabled>(
        _onDeviceSystemLogPreservationEnabled);
    on<DeviceSystemLogPreservedQuantityChanged>(
        _onDeviceSystemLogPreservedQuantityChanged);
    on<DeviceSystemLogPreservedDaysChanged>(
        _onDeviceSystemLogPreservedDaysChanged);
    on<LogRecordSettingSaved>(_onLogRecordSettingSaved);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);

    add(const LogRecordSettingRequested());
  }

  final User _user;
  final LogRecordSettingRepository _logRecordSettingRepository;

  bool _stringToBool(String enable) {
    return enable == '1' ? true : false;
  }

  String _boolToString(bool enable) {
    return enable ? '1' : '0';
  }

  void _onLogRecordSettingRequested(
    LogRecordSettingRequested event,
    Emitter<LogRecordSettingState> emit,
  ) async {
    List<dynamic> result =
        await _logRecordSettingRepository.getLogRecordSetting(user: _user);

    if (result[0]) {
      LogRecordSetting logRecordSetting = result[1];

      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.none,
        isEditing: false,
        archivedHistoricalRecordQuanitiy:
            logRecordSetting.archivedHistoricalRecordQuanitiy,
        enableApiLogPreservation:
            _stringToBool(logRecordSetting.enableApiLogPreservation),
        apiLogPreservedQuantity: logRecordSetting.apiLogPreservedQuantity,
        apiLogPreservedDays: logRecordSetting.apiLogPreservedDays,
        enableUserSystemLogPreservation:
            _stringToBool(logRecordSetting.enableUserSystemLogPreservation),
        userSystemLogPreservedQuantity:
            logRecordSetting.userSystemLogPreservedQuantity,
        userSystemLogPreservedDays: logRecordSetting.userSystemLogPreservedDays,
        enableDeviceSystemLogPreservation:
            _stringToBool(logRecordSetting.enableDeviceSystemLogPreservation),
        deviceSystemLogPreservedQuantity:
            logRecordSetting.deviceSystemLogPreservedQuantity,
        deviceSystemLogPreservedDays:
            logRecordSetting.deviceSystemLogPreservedDays,
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        submissionStatus: SubmissionStatus.none,
        isEditing: false,
        requestErrorMsg: result[1],
      ));
    }
  }

  void _onArchivedHistoricalRecordQuanitiyChanged(
    ArchivedHistoricalRecordQuanitiyChanged event,
    Emitter<LogRecordSettingState> emit,
  ) {
    emit(state.copyWith(
      archivedHistoricalRecordQuanitiy: event.archivedHistoricalRecordQuanitiy,
    ));
  }

  void _onApiLogPreservationEnabled(
    ApiLogPreservationEnabled event,
    Emitter<LogRecordSettingState> emit,
  ) {
    emit(state.copyWith(
      enableApiLogPreservation: event.enableApiLogPreservation,
    ));
  }

  void _onApiLogPreservedQuantityChanged(
    ApiLogPreservedQuantityChanged event,
    Emitter<LogRecordSettingState> emit,
  ) {
    emit(state.copyWith(
      apiLogPreservedQuantity: event.apiLogPreservedQuantity,
    ));
  }

  void _onApiLogPreservedDaysChanged(
    ApiLogPreservedDaysChanged event,
    Emitter<LogRecordSettingState> emit,
  ) {
    emit(state.copyWith(
      apiLogPreservedDays: event.apiLogPreservedDays,
    ));
  }

  void _onUserSystemLogPreservationEnabled(
    UserSystemLogPreservationEnabled event,
    Emitter<LogRecordSettingState> emit,
  ) {
    emit(state.copyWith(
      enableUserSystemLogPreservation: event.enableUserSystemLogPreservation,
    ));
  }

  void _onUserSystemLogPreservedQuantityChanged(
    UserSystemLogPreservedQuantityChanged event,
    Emitter<LogRecordSettingState> emit,
  ) {
    emit(state.copyWith(
      userSystemLogPreservedQuantity: event.userSystemLogPreservedQuantity,
    ));
  }

  void _onUserSystemLogPreservedDaysChanged(
    UserSystemLogPreservedDaysChanged event,
    Emitter<LogRecordSettingState> emit,
  ) {
    emit(state.copyWith(
      userSystemLogPreservedDays: event.userSystemLogPreservedDays,
    ));
  }

  void _onDeviceSystemLogPreservationEnabled(
    DeviceSystemLogPreservationEnabled event,
    Emitter<LogRecordSettingState> emit,
  ) {
    emit(state.copyWith(
      enableDeviceSystemLogPreservation:
          event.enableDeviceSystemLogPreservation,
    ));
  }

  void _onDeviceSystemLogPreservedQuantityChanged(
    DeviceSystemLogPreservedQuantityChanged event,
    Emitter<LogRecordSettingState> emit,
  ) {
    emit(state.copyWith(
      deviceSystemLogPreservedQuantity: event.deviceSystemLogPreservedQuantity,
    ));
  }

  void _onDeviceSystemLogPreservedDaysChanged(
    DeviceSystemLogPreservedDaysChanged event,
    Emitter<LogRecordSettingState> emit,
  ) {
    emit(state.copyWith(
      deviceSystemLogPreservedDays: event.deviceSystemLogPreservedDays,
    ));
  }

  void _onLogRecordSettingSaved(
    LogRecordSettingSaved event,
    Emitter<LogRecordSettingState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.none,
      submissionStatus: SubmissionStatus.submissionInProgress,
      isEditing: false,
    ));

    List<dynamic> result =
        await _logRecordSettingRepository.setLogRecordSetting(
      user: _user,
      archivedHistoricalRecordQuanitiy: state.archivedHistoricalRecordQuanitiy,
      enableApiLogPreservation: _boolToString(state.enableApiLogPreservation),
      apiLogPreservedQuantity: state.apiLogPreservedQuantity,
      apiLogPreservedDays: state.apiLogPreservedDays,
      enableUserSystemLogPreservation:
          _boolToString(state.enableUserSystemLogPreservation),
      userSystemLogPreservedQuantity: state.userSystemLogPreservedQuantity,
      userSystemLogPreservedDays: state.userSystemLogPreservedDays,
      enableDeviceSystemLogPreservation:
          _boolToString(state.enableDeviceSystemLogPreservation),
      deviceSystemLogPreservedQuantity: state.deviceSystemLogPreservedQuantity,
      deviceSystemLogPreservedDays: state.deviceSystemLogPreservedDays,
    );

    if (result[0]) {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionSuccess,
      ));
    } else {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionFailure,
        submissionErrorMsg: result[1],
      ));
    }
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<LogRecordSettingState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      submissionStatus: SubmissionStatus.none,
      isEditing: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<LogRecordSettingState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      submissionStatus: SubmissionStatus.none,
      isEditing: false,
    ));
  }
}
