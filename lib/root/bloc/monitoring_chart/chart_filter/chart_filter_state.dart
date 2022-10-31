part of 'chart_filter_bloc.dart';

class ChartFilterState extends Equatable {
  const ChartFilterState({
    this.status = FormStatus.none,
    this.chartDataStatus = FormStatus.none,
    this.chartDataExportStatus = FormStatus.none,
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
    this.chartDataExportMsg = '',
    this.chartDataExportFilePath = '',
  });

  final FormStatus status;
  final FormStatus chartDataStatus;
  final FormStatus chartDataExportStatus;
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
  final String chartDataExportMsg;
  final String chartDataExportFilePath;

  ChartFilterState copyWith({
    FormStatus? status,
    FormStatus? chartDataStatus,
    FormStatus? chartDataExportStatus,
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
    String? chartDataExportMsg,
    String? chartDataExportFilePath,
  }) {
    return ChartFilterState(
      status: status ?? this.status,
      chartDataStatus: chartDataStatus ?? this.chartDataStatus,
      chartDataExportStatus:
          chartDataExportStatus ?? this.chartDataExportStatus,
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
      chartDataExportMsg: chartDataExportMsg ?? this.chartDataExportMsg,
      chartDataExportFilePath:
          chartDataExportFilePath ?? this.chartDataExportFilePath,
    );
  }

  @override
  List<Object> get props => [
        status,
        chartDataStatus,
        chartDataExportStatus,
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
        chartDataExportMsg,
        chartDataExportFilePath,
      ];
}
