import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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