part of 'real_time_alarm_bloc.dart';

abstract class RealTimeAlarmEvent extends Equatable {
  const RealTimeAlarmEvent();
}

class AllAlarmRequested extends RealTimeAlarmEvent {
  const AllAlarmRequested();

  @override
  List<Object?> get props => [];
}

class CriticalAlarmRequested extends RealTimeAlarmEvent {
  const CriticalAlarmRequested();

  @override
  List<Object?> get props => [];
}

class WarningAlarmRequested extends RealTimeAlarmEvent {
  const WarningAlarmRequested();

  @override
  List<Object?> get props => [];
}

class NormalAlarmRequested extends RealTimeAlarmEvent {
  const NormalAlarmRequested();

  @override
  List<Object?> get props => [];
}

class NoticeAlarmRequested extends RealTimeAlarmEvent {
  const NoticeAlarmRequested();

  @override
  List<Object?> get props => [];
}

class AlarmItemTapped extends RealTimeAlarmEvent {
  const AlarmItemTapped(this.path);

  final List path;

  @override
  List<Object?> get props => [];
}
