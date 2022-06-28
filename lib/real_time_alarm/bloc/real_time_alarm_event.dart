part of 'real_time_alarm_bloc.dart';

abstract class RealTimeAlarmEvent extends Equatable {
  const RealTimeAlarmEvent();
}

class AllAlarmRequested extends RealTimeAlarmEvent {
  @override
  List<Object?> get props => [];
}

class CriticalAlarmRequested extends RealTimeAlarmEvent {
  @override
  List<Object?> get props => [];
}

class WarningAlarmRequested extends RealTimeAlarmEvent {
  @override
  List<Object?> get props => [];
}

class NormalAlarmRequested extends RealTimeAlarmEvent {
  @override
  List<Object?> get props => [];
}

class NoticeAlarmRequested extends RealTimeAlarmEvent {
  @override
  List<Object?> get props => [];
}
