part of 'multiple_axis_chart_bloc.dart';

class MultipleAxisChartState extends Equatable {
  const MultipleAxisChartState({
    this.status = FormStatus.none,
    this.chartDateValues = const {},
    this.errMsg = '',
  });

  final FormStatus status;
  final Map<String, List<ChartDateValuePair>> chartDateValues;
  final String errMsg;

  MultipleAxisChartState copyWith({
    FormStatus? status,
    Map<String, List<ChartDateValuePair>>? chartDateValues,
    String? errMsg,
  }) {
    return MultipleAxisChartState(
      status: status ?? this.status,
      chartDateValues: chartDateValues ?? this.chartDateValues,
      errMsg: errMsg ?? this.errMsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        chartDateValues,
        errMsg,
      ];
}
