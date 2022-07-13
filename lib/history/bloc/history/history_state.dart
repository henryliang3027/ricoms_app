part of 'history_bloc.dart';

class HistoryState extends Equatable {
  const HistoryState({
    this.records = const [],
    this.status = FormStatus.none,
    this.targetDeviceStatus = FormStatus.none,
    this.currentCriteria = const SearchCriteria(),
    this.errmsg = '',
  });

  final List records;
  final FormStatus status;
  final FormStatus targetDeviceStatus;
  final SearchCriteria currentCriteria;
  final String errmsg;

  HistoryState copyWith({
    List? records,
    FormStatus? status,
    FormStatus? targetDeviceStatus,
    SearchCriteria? currentCriteria,
    String? errmsg,
  }) {
    return HistoryState(
      records: records ?? this.records,
      status: status ?? this.status,
      targetDeviceStatus: targetDeviceStatus ?? this.targetDeviceStatus,
      currentCriteria: currentCriteria ?? this.currentCriteria,
      errmsg: errmsg ?? this.errmsg,
    );
  }

  @override
  List<Object> get props => [
        records,
        status,
        targetDeviceStatus,
        currentCriteria,
        errmsg,
      ];
}
