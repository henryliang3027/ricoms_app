part of 'real_time_alarm_bloc.dart';

abstract class RealTimeAlarmEvent extends Equatable {
  const RealTimeAlarmEvent();
}

class AllAlarmRequested extends RealTimeAlarmEvent {
  const AllAlarmRequested(this.requestMode);
  final RequestMode requestMode;

  @override
  List<Object?> get props => [requestMode];
}

class CriticalAlarmRequested extends RealTimeAlarmEvent {
  const CriticalAlarmRequested(this.requestMode);
  final RequestMode requestMode;

  @override
  List<Object?> get props => [requestMode];
}

class WarningAlarmRequested extends RealTimeAlarmEvent {
  const WarningAlarmRequested(this.requestMode);
  final RequestMode requestMode;

  @override
  List<Object?> get props => [requestMode];
}

class NormalAlarmRequested extends RealTimeAlarmEvent {
  const NormalAlarmRequested(this.requestMode);
  final RequestMode requestMode;

  @override
  List<Object?> get props => [requestMode];
}

class NoticeAlarmRequested extends RealTimeAlarmEvent {
  const NoticeAlarmRequested(this.requestMode);
  final RequestMode requestMode;

  @override
  List<Object?> get props => [requestMode];
}

class AlarmPeriodicUpdated extends RealTimeAlarmEvent {
  const AlarmPeriodicUpdated(this.alarmType);

  final AlarmType alarmType;

  @override
  List<Object?> get props => [alarmType];
}

class AlarmItemTapped extends RealTimeAlarmEvent {
  const AlarmItemTapped(this.path);

  final List path;

  @override
  List<Object?> get props => [path];
}

class CheckDeviceStatus extends RealTimeAlarmEvent {
  const CheckDeviceStatus(
    this.nodeId,
    this.pageController,
  );

  final int nodeId;
  final PageController pageController;

  @override
  List<Object?> get props => [
        nodeId,
        pageController,
      ];
}
