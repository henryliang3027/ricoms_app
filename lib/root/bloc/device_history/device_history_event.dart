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

class MoreNewerRecordsRequested extends DeviceHistoryEvent {
  const MoreNewerRecordsRequested();

  @override
  List<Object?> get props => [];
}

class MoreOlderRecordsRequested extends DeviceHistoryEvent {
  const MoreOlderRecordsRequested();

  @override
  List<Object?> get props => [];
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
