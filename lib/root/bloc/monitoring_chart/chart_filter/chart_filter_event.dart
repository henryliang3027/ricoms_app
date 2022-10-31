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

class FilterSelectingModeEnabled extends ChartFilterEvent {
  const FilterSelectingModeEnabled();

  @override
  List<Object?> get props => [];
}

class FilterSelectingModeDisabled extends ChartFilterEvent {
  const FilterSelectingModeDisabled();

  @override
  List<Object?> get props => [];
}

class CheckBoxValueChanged extends ChartFilterEvent {
  const CheckBoxValueChanged(this.oid, this.value);

  final String oid;
  final bool value;

  @override
  List<Object?> get props => [
        oid,
        value,
      ];
}

class AllCheckBoxValueChanged extends ChartFilterEvent {
  const AllCheckBoxValueChanged(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

class MultipleYAxisCheckBoxValueChanged extends ChartFilterEvent {
  const MultipleYAxisCheckBoxValueChanged(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

class ChartDateExported extends ChartFilterEvent {
  const ChartDateExported(
    this.nodeName,
    this.parameterName,
    this.chartDateValuePairs,
  );

  final String nodeName;
  final String parameterName;
  final List<ChartDateValuePair> chartDateValuePairs;

  @override
  List<Object?> get props => [
        nodeName,
        parameterName,
        chartDateValuePairs,
      ];
}
