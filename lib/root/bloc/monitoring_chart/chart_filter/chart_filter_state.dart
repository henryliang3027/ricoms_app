part of 'chart_filter_bloc.dart';

class ChartFilterState extends Equatable {
  const ChartFilterState({
    this.status = FormStatus.none,
    this.startDate = '',
    this.endDate = '',
    this.itemPropertiesCollection = const [],
    this.checkBoxValues = const {},
    this.filterSelectingMode = true,
    this.requestErrorMsg = '',
  });

  final FormStatus status;
  final String startDate;
  final String endDate;
  final List<List<ItemProperty>> itemPropertiesCollection;
  final Map<String, bool> checkBoxValues;
  final bool filterSelectingMode;
  final String requestErrorMsg;

  ChartFilterState copyWith({
    FormStatus? status,
    String? startDate,
    String? endDate,
    List<List<ItemProperty>>? itemPropertiesCollection,
    Map<String, bool>? checkBoxValues,
    bool? filterSelectingMode,
    String? requestErrorMsg,
  }) {
    return ChartFilterState(
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      itemPropertiesCollection:
          itemPropertiesCollection ?? this.itemPropertiesCollection,
      checkBoxValues: checkBoxValues ?? this.checkBoxValues,
      filterSelectingMode: filterSelectingMode ?? this.filterSelectingMode,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        startDate,
        endDate,
        itemPropertiesCollection,
        checkBoxValues,
        filterSelectingMode,
        requestErrorMsg,
      ];
}
