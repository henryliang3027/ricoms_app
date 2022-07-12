part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
}

class HistoryRequested extends HistoryEvent {
  const HistoryRequested();

  @override
  List<Object?> get props => [];
}

class CheckDeviceStatus extends HistoryEvent {
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
