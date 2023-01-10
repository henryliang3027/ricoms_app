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
        logRecordSetting: logRecordSetting,
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
    LogRecordSetting logRecordSetting = state.logRecordSetting.copyWith(
      archivedHistoricalRecordQuanitiy: event.archivedHistoricalRecordQuanitiy,
    );

    emit(state.copyWith(
      logRecordSetting: logRecordSetting,
    ));
  }

  void _onApiLogPreservationEnabled(
    ApiLogPreservationEnabled event,
    Emitter<LogRecordSettingState> emit,
  ) {
    LogRecordSetting logRecordSetting = state.logRecordSetting.copyWith(
      enableApiLogPreservation: _boolToString(event.enableApiLogPreservation),
    );

    emit(state.copyWith(
      logRecordSetting: logRecordSetting,
    ));
  }

  void _onApiLogPreservedQuantityChanged(
    ApiLogPreservedQuantityChanged event,
    Emitter<LogRecordSettingState> emit,
  ) {
    LogRecordSetting logRecordSetting = state.logRecordSetting.copyWith(
      apiLogPreservedQuantity: event.apiLogPreservedQuantity,
    );

    emit(state.copyWith(
      logRecordSetting: logRecordSetting,
    ));
  }

  void _onApiLogPreservedDaysChanged(
    ApiLogPreservedDaysChanged event,
    Emitter<LogRecordSettingState> emit,
  ) {
    LogRecordSetting logRecordSetting = state.logRecordSetting.copyWith(
      apiLogPreservedDays: event.apiLogPreservedDays,
    );

    emit(state.copyWith(
      logRecordSetting: logRecordSetting,
    ));
  }

  void _onUserSystemLogPreservationEnabled(
    UserSystemLogPreservationEnabled event,
    Emitter<LogRecordSettingState> emit,
  ) {
    LogRecordSetting logRecordSetting = state.logRecordSetting.copyWith(
      enableUserSystemLogPreservation:
          _boolToString(event.enableUserSystemLogPreservation),
    );

    emit(state.copyWith(
      logRecordSetting: logRecordSetting,
    ));
  }

  void _onUserSystemLogPreservedQuantityChanged(
    UserSystemLogPreservedQuantityChanged event,
    Emitter<LogRecordSettingState> emit,
  ) {
    LogRecordSetting logRecordSetting = state.logRecordSetting.copyWith(
      userSystemLogPreservedQuantity: event.userSystemLogPreservedQuantity,
    );

    emit(state.copyWith(
      logRecordSetting: logRecordSetting,
    ));
  }

  void _onUserSystemLogPreservedDaysChanged(
    UserSystemLogPreservedDaysChanged event,
    Emitter<LogRecordSettingState> emit,
  ) {
    LogRecordSetting logRecordSetting = state.logRecordSetting.copyWith(
      userSystemLogPreservedDays: event.userSystemLogPreservedDays,
    );

    emit(state.copyWith(
      logRecordSetting: logRecordSetting,
    ));
  }

  void _onDeviceSystemLogPreservationEnabled(
    DeviceSystemLogPreservationEnabled event,
    Emitter<LogRecordSettingState> emit,
  ) {
    LogRecordSetting logRecordSetting = state.logRecordSetting.copyWith(
      enableDeviceSystemLogPreservation:
          _boolToString(event.enableDeviceSystemLogPreservation),
    );

    emit(state.copyWith(
      logRecordSetting: logRecordSetting,
    ));
  }

  void _onDeviceSystemLogPreservedQuantityChanged(
    DeviceSystemLogPreservedQuantityChanged event,
    Emitter<LogRecordSettingState> emit,
  ) {
    LogRecordSetting logRecordSetting = state.logRecordSetting.copyWith(
      deviceSystemLogPreservedQuantity: event.deviceSystemLogPreservedQuantity,
    );

    emit(state.copyWith(
      logRecordSetting: logRecordSetting,
    ));
  }

  void _onDeviceSystemLogPreservedDaysChanged(
    DeviceSystemLogPreservedDaysChanged event,
    Emitter<LogRecordSettingState> emit,
  ) {
    LogRecordSetting logRecordSetting = state.logRecordSetting.copyWith(
      deviceSystemLogPreservedDays: event.deviceSystemLogPreservedDays,
    );

    emit(state.copyWith(
      logRecordSetting: logRecordSetting,
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
      logRecordSetting: state.logRecordSetting,
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
