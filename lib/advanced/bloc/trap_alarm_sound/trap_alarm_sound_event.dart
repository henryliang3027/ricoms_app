part of 'trap_alarm_sound_bloc.dart';

abstract class TrapAlarmSoundEvent extends Equatable {
  const TrapAlarmSoundEvent();
}

class TrapAlarmSoundEnabled extends TrapAlarmSoundEvent {
  const TrapAlarmSoundEnabled(this.enableTrapAlarmSound);

  final bool enableTrapAlarmSound;

  @override
  List<Object?> get props => [enableTrapAlarmSound];
}

class CriticalAlarmSoundEnabled extends TrapAlarmSoundEvent {
  const CriticalAlarmSoundEnabled(this.enableCriticalAlarmSound);

  final bool enableCriticalAlarmSound;

  @override
  List<Object?> get props => [enableCriticalAlarmSound];
}

class WarningAlarmSoundEnabled extends TrapAlarmSoundEvent {
  const WarningAlarmSoundEnabled(this.enableWarningAlarmSound);

  final bool enableWarningAlarmSound;

  @override
  List<Object?> get props => [enableWarningAlarmSound];
}

class NormalAlarmSoundEnabled extends TrapAlarmSoundEvent {
  const NormalAlarmSoundEnabled(this.enableNormalAlarmSound);

  final bool enableNormalAlarmSound;

  @override
  List<Object?> get props => [enableNormalAlarmSound];
}

class NoticeAlarmSoundEnabled extends TrapAlarmSoundEvent {
  const NoticeAlarmSoundEnabled(this.enableNoticeAlarmSound);

  final bool enableNoticeAlarmSound;

  @override
  List<Object?> get props => [enableNoticeAlarmSound];
}

class TrapAlarmSoundEnableSaved extends TrapAlarmSoundEvent {
  const TrapAlarmSoundEnableSaved();

  @override
  List<Object?> get props => [];
}
