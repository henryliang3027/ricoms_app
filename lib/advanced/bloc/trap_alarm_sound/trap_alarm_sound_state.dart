part of 'trap_alarm_sound_bloc.dart';

class TrapAlarmSoundState extends Equatable {
  const TrapAlarmSoundState({
    this.status = FormStatus.none,
    this.enableTrapAlarmSound = false,
    this.enableCriticalAlarmSound = false,
    this.enableWarningAlarmSound = false,
    this.enableNormalAlarmSound = false,
    this.enableNoticeAlarmSound = false,
  });

  final FormStatus status;
  final bool enableTrapAlarmSound;
  final bool enableCriticalAlarmSound;
  final bool enableWarningAlarmSound;
  final bool enableNormalAlarmSound;
  final bool enableNoticeAlarmSound;

  TrapAlarmSoundState copyWith({
    FormStatus? status,
    bool? enableTrapAlarmSound,
    bool? enableCriticalAlarmSound,
    bool? enableWarningAlarmSound,
    bool? enableNormalAlarmSound,
    bool? enableNoticeAlarmSound,
  }) {
    return TrapAlarmSoundState(
      status: status ?? this.status,
      enableTrapAlarmSound: enableTrapAlarmSound ?? this.enableTrapAlarmSound,
      enableCriticalAlarmSound:
          enableCriticalAlarmSound ?? this.enableCriticalAlarmSound,
      enableWarningAlarmSound:
          enableWarningAlarmSound ?? this.enableWarningAlarmSound,
      enableNormalAlarmSound:
          enableNormalAlarmSound ?? this.enableNormalAlarmSound,
      enableNoticeAlarmSound:
          enableNoticeAlarmSound ?? this.enableNoticeAlarmSound,
    );
  }

  @override
  List<Object> get props => [
        status,
        enableTrapAlarmSound,
        enableCriticalAlarmSound,
        enableWarningAlarmSound,
        enableNormalAlarmSound,
        enableNoticeAlarmSound,
      ];
}
