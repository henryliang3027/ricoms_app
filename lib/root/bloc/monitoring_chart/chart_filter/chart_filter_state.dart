part of 'chart_filter_bloc.dart';

class ChartFilterState extends Equatable {
  const ChartFilterState({
    this.status = FormStatus.none,
    this.chartDataStatus = FormStatus.none,
    this.startDate = '',
    this.endDate = '',
    this.itemPropertiesCollection = const [],
    this.checkBoxValues = const {},
    this.selectedCheckBoxValues = const {},
    this.chartDateValuePairsMap = const {},
    this.isSelectAll = false,
    this.isShowMultipleYAxis = false,
    this.isSelectMultipleYAxis = false,
    this.filterSelectingMode = true,
    this.requestErrorMsg = '',
  });

  final FormStatus status;
  final FormStatus chartDataStatus;
  final String startDate;
  final String endDate;
  final List<List<ItemProperty>> itemPropertiesCollection;
  final Map<String, CheckBoxValue> checkBoxValues;
  final Map<String, CheckBoxValue> selectedCheckBoxValues;
  final Map<String, List<ChartDateValuePair>> chartDateValuePairsMap;
  final bool isSelectAll;
  final bool isShowMultipleYAxis;
  final bool isSelectMultipleYAxis;
  final bool filterSelectingMode;
  final String requestErrorMsg;

  ChartFilterState copyWith({
    FormStatus? status,
    FormStatus? chartDataStatus,
    String? startDate,
    String? endDate,
    List<List<ItemProperty>>? itemPropertiesCollection,
    Map<String, CheckBoxValue>? checkBoxValues,
    Map<String, CheckBoxValue>? selectedCheckBoxValues,
    Map<String, List<ChartDateValuePair>>? chartDateValuePairsMap,
    bool? isSelectAll,
    bool? isShowMultipleYAxis,
    bool? isSelectMultipleYAxis,
    bool? filterSelectingMode,
    String? requestErrorMsg,
  }) {
    return ChartFilterState(
      status: status ?? this.status,
      chartDataStatus: chartDataStatus ?? this.chartDataStatus,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      itemPropertiesCollection:
          itemPropertiesCollection ?? this.itemPropertiesCollection,
      checkBoxValues: checkBoxValues ?? this.checkBoxValues,
      selectedCheckBoxValues:
          selectedCheckBoxValues ?? this.selectedCheckBoxValues,
      chartDateValuePairsMap:
          chartDateValuePairsMap ?? this.chartDateValuePairsMap,
      isSelectAll: isSelectAll ?? this.isSelectAll,
      isShowMultipleYAxis: isShowMultipleYAxis ?? this.isShowMultipleYAxis,
      isSelectMultipleYAxis:
          isSelectMultipleYAxis ?? this.isSelectMultipleYAxis,
      filterSelectingMode: filterSelectingMode ?? this.filterSelectingMode,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        chartDataStatus,
        startDate,
        endDate,
        itemPropertiesCollection,
        checkBoxValues,
        selectedCheckBoxValues,
        chartDateValuePairsMap,
        isSelectAll,
        isShowMultipleYAxis,
        isSelectMultipleYAxis,
        filterSelectingMode,
        requestErrorMsg,
      ];
}
