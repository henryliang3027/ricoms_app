part of 'system_log_bloc.dart';

abstract class SystemLogEvent extends Equatable {
  const SystemLogEvent();
}

class LogRequested extends SystemLogEvent {
  const LogRequested(this.filterCriteria);

  final FilterCriteria filterCriteria;

  @override
  List<Object?> get props => [filterCriteria];
}

class MoreLogsRequested extends SystemLogEvent {
  const MoreLogsRequested(this.startId);

  final int startId;

  @override
  List<Object?> get props => [startId];
}

class DeviceStatusChecked extends SystemLogEvent {
  const DeviceStatusChecked(
    this.initialPath,
    this.path,
    this.pageController,
  );

  final List initialPath;
  final List<int> path;
  final PageController pageController;

  @override
  List<Object?> get props => [
        initialPath,
        path,
        pageController,
      ];
}

class FloatingActionButtonHided extends SystemLogEvent {
  const FloatingActionButtonHided();

  @override
  List<Object?> get props => [];
}

class FloatingActionButtonShowed extends SystemLogEvent {
  const FloatingActionButtonShowed();

  @override
  List<Object?> get props => [];
}

class LogsExported extends SystemLogEvent {
  const LogsExported();

  @override
  List<Object?> get props => [];
}
