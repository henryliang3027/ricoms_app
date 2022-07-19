part of 'history_bloc.dart';

class HistoryState extends Equatable {
  const HistoryState({
    this.records = const [],
    this.status = FormStatus.none,
    this.targetDeviceStatus = FormStatus.none,
    this.historyExportStatus = FormStatus.none,
    this.currentCriteria = const SearchCriteria(),
    this.errmsg = '',
    this.historyExportMsg = '',
    this.historyExportFilePath = '',
  });

  final List records;
  final FormStatus status;
  final FormStatus targetDeviceStatus;
  final FormStatus historyExportStatus;
  final SearchCriteria currentCriteria;
  final String errmsg;
  final String historyExportMsg;
  final String historyExportFilePath;

  HistoryState copyWith({
    List? records,
    FormStatus? status,
    FormStatus? targetDeviceStatus,
    FormStatus? historyExportStatus,
    SearchCriteria? currentCriteria,
    String? errmsg,
    String? historyExportMsg,
    String? historyExportFilePath,
  }) {
    return HistoryState(
      records: records ?? this.records,
      status: status ?? this.status,
      targetDeviceStatus: targetDeviceStatus ?? this.targetDeviceStatus,
      historyExportStatus: historyExportStatus ?? this.historyExportStatus,
      currentCriteria: currentCriteria ?? this.currentCriteria,
      errmsg: errmsg ?? this.errmsg,
      historyExportMsg: historyExportMsg ?? this.historyExportMsg,
      historyExportFilePath:
          historyExportFilePath ?? this.historyExportFilePath,
    );
  }

  @override
  List<Object> get props => [
        records,
        status,
        targetDeviceStatus,
        historyExportStatus,
        currentCriteria,
        errmsg,
        historyExportMsg,
        historyExportFilePath,
      ];
}
