part of 'history_bloc.dart';

class HistoryState extends Equatable {
  const HistoryState({
    this.records = const [],
    this.status = FormStatus.none,
    this.targetDeviceStatus = FormStatus.none,
    this.historyExportStatus = FormStatus.none,
    this.moreRecordsStatus = FormStatus.none,
    this.currentCriteria = const SearchCriteria(),
    this.tapLoadNewerRecordsCount = 0,
    this.errmsg = '',
    this.historyExportMsg = '',
    this.historyExportFilePath = '',
    this.moreRecordsMessage = '',
    this.isShowFloatingActionButton = false,
  });

  final List<Record> records;
  final FormStatus status;
  final FormStatus targetDeviceStatus;
  final FormStatus historyExportStatus;
  final FormStatus moreRecordsStatus;
  final SearchCriteria currentCriteria;
  final int tapLoadNewerRecordsCount;
  final String errmsg;
  final String historyExportMsg;
  final String historyExportFilePath;
  final String moreRecordsMessage;
  final bool isShowFloatingActionButton;

  HistoryState copyWith({
    List<Record>? records,
    FormStatus? status,
    FormStatus? targetDeviceStatus,
    FormStatus? historyExportStatus,
    FormStatus? moreRecordsStatus,
    SearchCriteria? currentCriteria,
    int? tapLoadNewerRecordsCount,
    int? tapLoadOlderRecordsCount,
    String? errmsg,
    String? historyExportMsg,
    String? historyExportFilePath,
    String? moreRecordsMessage,
    bool? isShowFloatingActionButton,
  }) {
    return HistoryState(
      records: records ?? this.records,
      status: status ?? this.status,
      targetDeviceStatus: targetDeviceStatus ?? this.targetDeviceStatus,
      historyExportStatus: historyExportStatus ?? this.historyExportStatus,
      moreRecordsStatus: moreRecordsStatus ?? this.moreRecordsStatus,
      currentCriteria: currentCriteria ?? this.currentCriteria,
      tapLoadNewerRecordsCount:
          tapLoadNewerRecordsCount ?? this.tapLoadNewerRecordsCount,
      errmsg: errmsg ?? this.errmsg,
      historyExportMsg: historyExportMsg ?? this.historyExportMsg,
      historyExportFilePath:
          historyExportFilePath ?? this.historyExportFilePath,
      moreRecordsMessage: moreRecordsMessage ?? this.moreRecordsMessage,
      isShowFloatingActionButton:
          isShowFloatingActionButton ?? this.isShowFloatingActionButton,
    );
  }

  @override
  List<Object> get props => [
        records,
        status,
        targetDeviceStatus,
        historyExportStatus,
        moreRecordsStatus,
        currentCriteria,
        tapLoadNewerRecordsCount,
        errmsg,
        historyExportMsg,
        historyExportFilePath,
        moreRecordsMessage,
        isShowFloatingActionButton,
      ];
}
