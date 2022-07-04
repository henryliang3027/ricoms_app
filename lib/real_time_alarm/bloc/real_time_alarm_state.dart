part of 'real_time_alarm_bloc.dart';

class RealTimeAlarmState extends Equatable {
  const RealTimeAlarmState({
    this.allAlarms = const [],
    this.criticalAlarms = const [],
    this.warningAlarms = const [],
    this.normalAlarms = const [],
    this.noticeAlarms = const [],
    this.allAlarmsStatus = FormStatus.none,
    this.criticalAlarmsStatus = FormStatus.none,
    this.warningAlarmsStatus = FormStatus.none,
    this.normalAlarmsStatus = FormStatus.none,
    this.noticeAlarmsStatus = FormStatus.none,
    this.targetDeviceStatus = FormStatus.none,
    this.errmsg = '',
  });

  final FormStatus allAlarmsStatus;
  final FormStatus criticalAlarmsStatus;
  final FormStatus warningAlarmsStatus;
  final FormStatus normalAlarmsStatus;
  final FormStatus noticeAlarmsStatus;
  final List allAlarms;
  final List criticalAlarms;
  final List warningAlarms;
  final List normalAlarms;
  final List noticeAlarms;
  final FormStatus targetDeviceStatus;
  final String errmsg;

  RealTimeAlarmState copyWith({
    FormStatus? allAlarmsStatus,
    FormStatus? criticalAlarmsStatus,
    FormStatus? warningAlarmsStatus,
    FormStatus? normalAlarmsStatus,
    FormStatus? noticeAlarmsStatus,
    List? allAlarms,
    List? criticalAlarms,
    List? warningAlarms,
    List? normalAlarms,
    List? noticeAlarms,
    FormStatus? targetDeviceStatus,
    String? errmsg,
  }) {
    return RealTimeAlarmState(
      allAlarmsStatus: allAlarmsStatus ?? this.allAlarmsStatus,
      criticalAlarmsStatus: criticalAlarmsStatus ?? this.criticalAlarmsStatus,
      warningAlarmsStatus: warningAlarmsStatus ?? this.warningAlarmsStatus,
      normalAlarmsStatus: normalAlarmsStatus ?? this.normalAlarmsStatus,
      noticeAlarmsStatus: noticeAlarmsStatus ?? this.noticeAlarmsStatus,
      allAlarms: allAlarms ?? this.allAlarms,
      criticalAlarms: criticalAlarms ?? this.criticalAlarms,
      warningAlarms: warningAlarms ?? this.warningAlarms,
      normalAlarms: normalAlarms ?? this.normalAlarms,
      noticeAlarms: noticeAlarms ?? this.noticeAlarms,
      targetDeviceStatus: targetDeviceStatus ?? this.targetDeviceStatus,
      errmsg: errmsg ?? this.errmsg,
    );
  }

  @override
  List<Object?> get props => [
        allAlarmsStatus,
        criticalAlarmsStatus,
        warningAlarmsStatus,
        normalAlarmsStatus,
        noticeAlarmsStatus,
        allAlarms,
        criticalAlarms,
        warningAlarms,
        normalAlarms,
        noticeAlarms,
        targetDeviceStatus,
        errmsg,
      ];
}
