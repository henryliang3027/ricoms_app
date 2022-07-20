part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
}

class HistoryRequested extends HistoryEvent {
  const HistoryRequested(this.searchCriteria);

  final SearchCriteria searchCriteria;

  @override
  List<Object?> get props => [searchCriteria];
}

class MoreRecordsRequested extends HistoryEvent {
  const MoreRecordsRequested(this.startTrapId);

  final int startTrapId;

  @override
  List<Object?> get props => [startTrapId];
}

class DeviceStatusChecked extends HistoryEvent {
  const DeviceStatusChecked(
    this.path,
    this.pageController,
  );

  final List<int> path;
  final PageController pageController;

  @override
  List<Object?> get props => [
        path,
        pageController,
      ];
}

class FloatingActionButtonHided extends HistoryEvent {
  const FloatingActionButtonHided();

  @override
  List<Object?> get props => [];
}

class FloatingActionButtonShowed extends HistoryEvent {
  const FloatingActionButtonShowed();

  @override
  List<Object?> get props => [];
}

class HistoryRecordsExported extends HistoryEvent {
  const HistoryRecordsExported();

  @override
  List<Object?> get props => [];
}
