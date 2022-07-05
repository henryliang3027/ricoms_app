part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class AlarmStatisticRequested extends DashboardEvent {
  const AlarmStatisticRequested(this.type, this.requestMode);
  final int type;
  final RequestMode requestMode;

  @override
  List<Object?> get props => [
        type,
        requestMode,
      ];
}

class DeviceStatisticRequested extends DashboardEvent {
  const DeviceStatisticRequested(this.requestMode);
  final RequestMode requestMode;

  @override
  List<Object?> get props => [requestMode];
}
