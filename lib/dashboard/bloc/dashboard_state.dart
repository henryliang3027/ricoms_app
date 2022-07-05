part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  const DashboardState({
    this.alarmStatisticsStatus = FormStatus.none,
    this.deviceStatisticsStatus = FormStatus.none,
    this.alarmStatistics = const AlarmStatistics(),
    this.deviceStatistics = const [],
    this.errmsg = '',
  });

  final FormStatus alarmStatisticsStatus;
  final FormStatus deviceStatisticsStatus;
  final AlarmStatistics alarmStatistics;
  final List deviceStatistics;
  final String errmsg;

  DashboardState copyWith({
    FormStatus? alarmStatisticsStatus,
    FormStatus? deviceStatisticsStatus,
    AlarmStatistics? alarmStatistics,
    List? deviceStatistics,
    String? errmsg,
  }) {
    return DashboardState(
      alarmStatisticsStatus:
          alarmStatisticsStatus ?? this.alarmStatisticsStatus,
      deviceStatisticsStatus:
          deviceStatisticsStatus ?? this.deviceStatisticsStatus,
      alarmStatistics: alarmStatistics ?? this.alarmStatistics,
      deviceStatistics: deviceStatistics ?? this.deviceStatistics,
      errmsg: errmsg ?? this.errmsg,
    );
  }

  @override
  List<Object?> get props => [
        alarmStatisticsStatus,
        deviceStatisticsStatus,
        alarmStatistics,
        deviceStatistics,
        errmsg,
      ];
}
