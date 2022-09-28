part of 'chart_filter_bloc.dart';

class ChartFilterState extends Equatable {
  const ChartFilterState({
    this.status = FormStatus.none,
    this.startDate = '',
    this.endDate = '',
    this.data = const [],
    this.filterSelectingMode = true,
    this.requestErrorMsg = '',
  });

  final FormStatus status;
  final String startDate;
  final String endDate;
  final List data;
  final bool filterSelectingMode;
  final String requestErrorMsg;

  ChartFilterState copyWith({
    FormStatus? status,
    String? startDate,
    String? endDate,
    List? data,
    bool? filterSelectingMode,
    String? requestErrorMsg,
  }) {
    return ChartFilterState(
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      data: data ?? this.data,
      filterSelectingMode: filterSelectingMode ?? this.filterSelectingMode,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        startDate,
        endDate,
        data,
        filterSelectingMode,
        requestErrorMsg,
      ];
}
