part of 'chart_filter_bloc.dart';

abstract class ChartFilterEvent extends Equatable {
  const ChartFilterEvent();
}

class ThresholdDataRequested extends ChartFilterEvent {
  const ThresholdDataRequested();

  @override
  List<Object?> get props => [];
}

class StartDateChanged extends ChartFilterEvent {
  const StartDateChanged(this.startDate);

  final String startDate;

  @override
  List<Object?> get props => [startDate];
}

class EndDateChanged extends ChartFilterEvent {
  const EndDateChanged(this.endDate);

  final String endDate;

  @override
  List<Object?> get props => [endDate];
}

class FilterSelectingModeChanged extends ChartFilterEvent {
  const FilterSelectingModeChanged();

  @override
  List<Object?> get props => [];
}
