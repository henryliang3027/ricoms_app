part of 'log_record_setting_bloc.dart';

abstract class LogRecordSettingEvent extends Equatable {
  const LogRecordSettingEvent();
}

class LogRecordSettingRequest extends LogRecordSettingEvent {
  const LogRecordSettingRequest();

  @override
  List<Object?> get props => [];
}

class EditModeEnabled extends LogRecordSettingEvent {
  const EditModeEnabled();

  @override
  List<Object?> get props => [];
}

class EditModeDisabled extends LogRecordSettingEvent {
  const EditModeDisabled();

  @override
  List<Object?> get props => [];
}

class LogRecordSettingSaved extends LogRecordSettingEvent {
  const LogRecordSettingSaved();

  @override
  List<Object?> get props => [];
}
