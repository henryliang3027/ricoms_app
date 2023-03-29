part of 'monitoring_chart_bloc.dart';

abstract class MonitoringChartEvent extends Equatable {
  const MonitoringChartEvent();
}

class ParameterRequested extends MonitoringChartEvent {
  const ParameterRequested();

  @override
  List<Object?> get props => [];
}

class StartDateChanged extends MonitoringChartEvent {
  const StartDateChanged(this.startDate);

  final String startDate;

  @override
  List<Object?> get props => [startDate];
}

class EndDateChanged extends MonitoringChartEvent {
  const EndDateChanged(this.endDate);

  final String endDate;

  @override
  List<Object?> get props => [endDate];
}

class FilterSelectingModeEnabled extends MonitoringChartEvent {
  const FilterSelectingModeEnabled();

  @override
  List<Object?> get props => [];
}

class FilterSelectingModeDisabled extends MonitoringChartEvent {
  const FilterSelectingModeDisabled();

  @override
  List<Object?> get props => [];
}

class CheckBoxValueChanged extends MonitoringChartEvent {
  const CheckBoxValueChanged(this.oid, this.value);

  final String oid;
  final bool value;

  @override
  List<Object?> get props => [
        oid,
        value,
      ];
}

class AllCheckBoxValueChanged extends MonitoringChartEvent {
  const AllCheckBoxValueChanged(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

class MultipleYAxisCheckBoxValueChanged extends MonitoringChartEvent {
  const MultipleYAxisCheckBoxValueChanged(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

class SingleAxisChartDataExported extends MonitoringChartEvent {
  const SingleAxisChartDataExported(
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

class MultipleAxisChartDataExported extends MonitoringChartEvent {
  const MultipleAxisChartDataExported(
    this.nodeName,
    this.checkBoxValues,
    this.chartDateValuePairs,
  );

  final String nodeName;
  final Map<String, CheckBoxValue> checkBoxValues;
  final Map<String, List<ChartDateValuePair>> chartDateValuePairs;

  @override
  List<Object?> get props => [
        nodeName,
        checkBoxValues,
        chartDateValuePairs,
      ];
}
