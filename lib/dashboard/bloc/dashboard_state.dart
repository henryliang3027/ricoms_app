part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  const DashboardState({
    this.alarmOneDayStatisticsStatus = FormStatus.none,
    this.alarmThreeDaysStatisticsStatus = FormStatus.none,
    this.alarmOneWeekStatisticsStatus = FormStatus.none,
    this.alarmTwoWeeksStatisticsStatus = FormStatus.none,
    this.alarmOneMonthStatisticsStatus = FormStatus.none,
    this.deviceStatisticsStatus = FormStatus.none,
    this.alarmOneDayStatistics = const [],
    this.alarmThreeDaysStatistics = const [],
    this.alarmOneWeekStatistics = const [],
    this.alarmTwoWeeksStatistics = const [],
    this.alarmOneMonthStatistics = const [],
    this.deviceStatistics = const [],
    this.errmsg = '',
  });

  final FormStatus alarmOneDayStatisticsStatus;
  final FormStatus alarmThreeDaysStatisticsStatus;
  final FormStatus alarmOneWeekStatisticsStatus;
  final FormStatus alarmTwoWeeksStatisticsStatus;
  final FormStatus alarmOneMonthStatisticsStatus;
  final FormStatus deviceStatisticsStatus;
  final List alarmOneDayStatistics;
  final List alarmThreeDaysStatistics;
  final List alarmOneWeekStatistics;
  final List alarmTwoWeeksStatistics;
  final List alarmOneMonthStatistics;
  final List deviceStatistics;
  final String errmsg;

  DashboardState copyWith({
    FormStatus? alarmOneDayStatisticsStatus,
    FormStatus? alarmThreeDaysStatisticsStatus,
    FormStatus? alarmOneWeekStatisticsStatus,
    FormStatus? alarmTwoWeeksStatisticsStatus,
    FormStatus? alarmOneMonthStatisticsStatus,
    FormStatus? deviceStatisticsStatus,
    List? alarmOneDayStatistics,
    List? alarmThreeDaysStatistics,
    List? alarmOneWeekStatistics,
    List? alarmTwoWeeksStatistics,
    List? alarmOneMonthStatistics,
    List? deviceStatistics,
    String? errmsg,
  }) {
    return DashboardState(
      alarmOneDayStatisticsStatus:
          alarmOneDayStatisticsStatus ?? this.alarmOneDayStatisticsStatus,
      alarmThreeDaysStatisticsStatus:
          alarmThreeDaysStatisticsStatus ?? this.alarmThreeDaysStatisticsStatus,
      alarmOneWeekStatisticsStatus:
          alarmOneWeekStatisticsStatus ?? this.alarmOneWeekStatisticsStatus,
      alarmTwoWeeksStatisticsStatus:
          alarmTwoWeeksStatisticsStatus ?? this.alarmTwoWeeksStatisticsStatus,
      alarmOneMonthStatisticsStatus:
          alarmOneMonthStatisticsStatus ?? this.alarmOneMonthStatisticsStatus,
      deviceStatisticsStatus:
          deviceStatisticsStatus ?? this.deviceStatisticsStatus,
      alarmOneDayStatistics:
          alarmOneDayStatistics ?? this.alarmOneDayStatistics,
      alarmThreeDaysStatistics:
          alarmThreeDaysStatistics ?? this.alarmThreeDaysStatistics,
      alarmOneWeekStatistics:
          alarmOneWeekStatistics ?? this.alarmOneWeekStatistics,
      alarmTwoWeeksStatistics:
          alarmTwoWeeksStatistics ?? this.alarmTwoWeeksStatistics,
      alarmOneMonthStatistics:
          alarmOneMonthStatistics ?? this.alarmOneMonthStatistics,
      deviceStatistics: deviceStatistics ?? this.deviceStatistics,
      errmsg: errmsg ?? this.errmsg,
    );
  }

  @override
  List<Object?> get props => [
        alarmOneDayStatisticsStatus,
        alarmThreeDaysStatisticsStatus,
        alarmOneWeekStatisticsStatus,
        alarmTwoWeeksStatisticsStatus,
        alarmOneMonthStatisticsStatus,
        deviceStatisticsStatus,
        alarmOneDayStatistics,
        alarmThreeDaysStatistics,
        alarmOneWeekStatistics,
        alarmTwoWeeksStatistics,
        alarmOneMonthStatistics,
        deviceStatistics,
        errmsg,
      ];
}
