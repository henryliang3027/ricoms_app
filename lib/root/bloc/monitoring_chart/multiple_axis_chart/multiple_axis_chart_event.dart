part of 'multiple_axis_chart_bloc.dart';

abstract class MultipleAxisChartEvent extends Equatable {
  const MultipleAxisChartEvent();
}

class ChartDataRequested extends MultipleAxisChartEvent {
  const ChartDataRequested();

  @override
  List<Object?> get props => [];
}
