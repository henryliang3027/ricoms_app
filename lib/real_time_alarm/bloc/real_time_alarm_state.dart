part of 'real_time_alarm_bloc.dart';

class RealTimeAlarmState extends Equatable {
  const RealTimeAlarmState({
    this.allAlarms = const [],
    this.criticalAlarms = const [],
    this.warningAlarms = const [],
    this.normalAlarms = const [],
    this.noticeAlarms = const [],
    this.status = FormStatus.none,
  });

  final FormStatus status;
  final List allAlarms;
  final List criticalAlarms;
  final List warningAlarms;
  final List normalAlarms;
  final List noticeAlarms;

  RealTimeAlarmState copyWith({
    FormStatus? status,
    List? allAlarms,
    List? criticalAlarms,
    List? warningAlarms,
    List? normalAlarms,
    List? noticeAlarms,
  }) {
    return RealTimeAlarmState(
      status: status ?? this.status,
      allAlarms: allAlarms ?? this.allAlarms,
      criticalAlarms: criticalAlarms ?? this.criticalAlarms,
      warningAlarms: warningAlarms ?? this.warningAlarms,
      normalAlarms: normalAlarms ?? this.normalAlarms,
      noticeAlarms: noticeAlarms ?? this.noticeAlarms,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allAlarms,
        criticalAlarms,
        warningAlarms,
        normalAlarms,
        noticeAlarms,
      ];
}
