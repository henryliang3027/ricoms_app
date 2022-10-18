part of 'single_axis_chart_bloc.dart';

class SingleAxisChartState extends Equatable {
  const SingleAxisChartState({
    this.status = FormStatus.none,
    this.chartDateValuePairs = const [],
    this.errMsg = '',
  });

  final FormStatus status;
  final List<ChartDateValuePair> chartDateValuePairs;
  final String errMsg;

  SingleAxisChartState copyWith({
    FormStatus? status,
    List<ChartDateValuePair>? chartDateValuePairs,
    String? errMsg,
  }) {
    return SingleAxisChartState(
      status: status ?? this.status,
      chartDateValuePairs: chartDateValuePairs ?? this.chartDateValuePairs,
      errMsg: errMsg ?? this.errMsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        chartDateValuePairs,
        errMsg,
      ];
}
