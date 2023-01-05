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
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);

    add(const LogRecordSettingRequest());
  }

  final User _user;
  final LogRecordSettingRepository _logRecordSettingRepository;

  void _onLogRecordSettingRequested(
    LogRecordSettingEvent event,
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
        enableApiLogPreservation: logRecordSetting.enableApiLogPreservation,
        apiLogPreservedQuantity: logRecordSetting.apiLogPreservedQuantity,
        apiLogPreservedDays: logRecordSetting.apiLogPreservedDays,
        enableUserSystemLogPreservation:
            logRecordSetting.enableUserSystemLogPreservation,
        userSystemLogPreservedQuantity:
            logRecordSetting.userSystemLogPreservedQuantity,
        userSystemLogPreservedDays: logRecordSetting.userSystemLogPreservedDays,
        enableDeviceSystemLogPreservation:
            logRecordSetting.enableDeviceSystemLogPreservation,
        deviceSystemLogPreservedQuantity:
            logRecordSetting.deviceSystemLogPreservedQuantity,
        deviceSystemLogPreservedDays:
            logRecordSetting.deviceSystemLogPreservedDays,
        requestErrorMsg: '',
      ));
    } else {}
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
