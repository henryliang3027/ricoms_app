class AlarmSoundConfig {
  static bool activateAlarm = true;
  static List<bool> enableTrapAlarmSound = [
    true, // AlarmType.notice
    true, // AlarmType.normal
    true, // AlarmType.warning
    true, // AlarmType.critical
  ];

  static setAlarmSoundEnableValues(List<bool> alarmSoundEnableValues) {
    activateAlarm = alarmSoundEnableValues[0];

    for (int i = 1; i < alarmSoundEnableValues.length; i++) {
      enableTrapAlarmSound[i - 1] = alarmSoundEnableValues[i];
    }
  }
}
