class AlarmSoundSwitch {
  static bool activateAlarm = true;
  static List<bool> enableTrapAlarmSound = [
    true, // AlarmType.notice
    true, // AlarmType.normal
    true, // AlarmType.warning
    true, // AlarmType.critical
  ];

  static setAlarmSoundSwitch(List<bool> alarmSoundSwitchs) {
    for (int i = 0; i < alarmSoundSwitchs.length - 1; i++) {
      enableTrapAlarmSound[i] = alarmSoundSwitchs[i];
    }

    activateAlarm = alarmSoundSwitchs[4];
  }
}
