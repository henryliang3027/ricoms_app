part of 'device_history_bloc.dart';

abstract class DeviceHistoryEvent extends Equatable {
  const DeviceHistoryEvent();
}

class HistoryRequested extends DeviceHistoryEvent {
  const HistoryRequested(this.nodeId);

  final int nodeId;

  @override
  List<Object?> get props => [nodeId];
}

class MoreRecordsRequested extends DeviceHistoryEvent {
  const MoreRecordsRequested(this.startTrapId);

  final int startTrapId;

  @override
  List<Object?> get props => [startTrapId];
}

class FloatingActionButtonHided extends DeviceHistoryEvent {
  const FloatingActionButtonHided();

  @override
  List<Object?> get props => [];
}

class FloatingActionButtonShowed extends DeviceHistoryEvent {
  const FloatingActionButtonShowed();

  @override
  List<Object?> get props => [];
}
