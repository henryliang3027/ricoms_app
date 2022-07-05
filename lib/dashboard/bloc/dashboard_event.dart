part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class AlarmOneDayStatisticRequested extends DashboardEvent {
  const AlarmOneDayStatisticRequested(this.requestMode);
  final RequestMode requestMode;

  @override
  List<Object?> get props => [requestMode];
}

class AlarmThreeDaysStatisticRequested extends DashboardEvent {
  const AlarmThreeDaysStatisticRequested(this.requestMode);
  final RequestMode requestMode;

  @override
  List<Object?> get props => [requestMode];
}

class AlarmOneWeekStatisticRequested extends DashboardEvent {
  const AlarmOneWeekStatisticRequested(this.requestMode);
  final RequestMode requestMode;

  @override
  List<Object?> get props => [requestMode];
}

class AlarmTwoWeeksStatisticRequested extends DashboardEvent {
  const AlarmTwoWeeksStatisticRequested(this.requestMode);
  final RequestMode requestMode;

  @override
  List<Object?> get props => [requestMode];
}

class AlarmOneMonthStatisticRequested extends DashboardEvent {
  const AlarmOneMonthStatisticRequested(this.requestMode);
  final RequestMode requestMode;

  @override
  List<Object?> get props => [
        requestMode,
      ];
}

class AlarmStatisticPeriodicUpdated extends DashboardEvent {
  const AlarmStatisticPeriodicUpdated(this.type);
  final int type;

  @override
  List<Object?> get props => [
        type,
      ];
}

class DeviceStatisticRequested extends DashboardEvent {
  const DeviceStatisticRequested(this.requestMode);
  final RequestMode requestMode;

  @override
  List<Object?> get props => [requestMode];
}
