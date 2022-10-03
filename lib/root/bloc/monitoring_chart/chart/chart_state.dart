part of 'chart_bloc.dart';

class ChartState extends Equatable {
  const ChartState({
    this.status = FormStatus.none,
    this.chartDateValuePairs = const [],
    this.errMsg = '',
  });

  final FormStatus status;
  final List<ChartDateValuePair> chartDateValuePairs;
  final String errMsg;

  ChartState copyWith({
    FormStatus? status,
    List<ChartDateValuePair>? chartDateValuePairs,
    String? errMsg,
  }) {
    return ChartState(
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
