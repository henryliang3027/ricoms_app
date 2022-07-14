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

class CheckDeviceStatus extends HistoryEvent {
  const CheckDeviceStatus(
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

class HistoryRecordsExport extends HistoryEvent {
  const HistoryRecordsExport();

  @override
  List<Object?> get props => [];
}
