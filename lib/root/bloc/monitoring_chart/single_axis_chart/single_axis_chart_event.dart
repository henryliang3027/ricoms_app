part of 'single_axis_chart_bloc.dart';

abstract class SingleAxisChartEvent extends Equatable {
  const SingleAxisChartEvent();
}

class ChartDataRequested extends SingleAxisChartEvent {
  const ChartDataRequested();

  @override
  List<Object?> get props => [];
}
