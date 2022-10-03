part of 'chart_bloc.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();
}

class ChartDataRequested extends ChartEvent {
  const ChartDataRequested();

  @override
  List<Object?> get props => [];
}
