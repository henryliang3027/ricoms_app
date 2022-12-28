part of 'trap_alarm_sound_bloc.dart';

class TrapAlarmSoundState extends Equatable {
  const TrapAlarmSoundState({
    this.status = FormStatus.none,
    this.isEditing = false,
    this.enableTrapAlarmSound = false,
    this.enableCriticalAlarmSound = false,
    this.enableWarningAlarmSound = false,
    this.enableNormalAlarmSound = false,
    this.enableNoticeAlarmSound = false,
    this.errmsg = '',
  });

  final FormStatus status;
  final bool isEditing;
  final bool enableTrapAlarmSound;
  final bool enableCriticalAlarmSound;
  final bool enableWarningAlarmSound;
  final bool enableNormalAlarmSound;
  final bool enableNoticeAlarmSound;
  final String errmsg;

  TrapAlarmSoundState copyWith({
    FormStatus? status,
    bool? isEditing,
    bool? enableTrapAlarmSound,
    bool? enableCriticalAlarmSound,
    bool? enableWarningAlarmSound,
    bool? enableNormalAlarmSound,
    bool? enableNoticeAlarmSound,
    String? errmsg,
  }) {
    return TrapAlarmSoundState(
      status: status ?? this.status,
      isEditing: isEditing ?? this.isEditing,
      enableTrapAlarmSound: enableTrapAlarmSound ?? this.enableTrapAlarmSound,
      enableCriticalAlarmSound:
          enableCriticalAlarmSound ?? this.enableCriticalAlarmSound,
      enableWarningAlarmSound:
          enableWarningAlarmSound ?? this.enableWarningAlarmSound,
      enableNormalAlarmSound:
          enableNormalAlarmSound ?? this.enableNormalAlarmSound,
      enableNoticeAlarmSound:
          enableNoticeAlarmSound ?? this.enableNoticeAlarmSound,
      errmsg: errmsg ?? this.errmsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        isEditing,
        enableTrapAlarmSound,
        enableCriticalAlarmSound,
        enableWarningAlarmSound,
        enableNormalAlarmSound,
        enableNoticeAlarmSound,
        errmsg,
      ];
}
