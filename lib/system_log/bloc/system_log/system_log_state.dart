part of 'system_log_bloc.dart';

class SystemLogState extends Equatable {
  const SystemLogState({
    this.logs = const [],
    this.status = FormStatus.none,
    this.targetDeviceStatus = FormStatus.none,
    this.logExportStatus = FormStatus.none,
    this.moreLogsStatus = FormStatus.none,
    this.filterCriteria = const FilterCriteria(),
    this.tapLoadNewerRecordsCount = 0,
    this.errmsg = '',
    this.logExportMsg = '',
    this.logExportFilePath = '',
    this.moreLogsMessage = '',
    this.isShowFloatingActionButton = false,
  });

  final List<Log> logs;
  final FormStatus status;
  final FormStatus targetDeviceStatus;
  final FormStatus logExportStatus;
  final FormStatus moreLogsStatus;
  final FilterCriteria filterCriteria;
  final int tapLoadNewerRecordsCount;
  final String errmsg;
  final String logExportMsg;
  final String logExportFilePath;
  final String moreLogsMessage;
  final bool isShowFloatingActionButton;

  SystemLogState copyWith({
    List<Log>? logs,
    FormStatus? status,
    FormStatus? targetDeviceStatus,
    FormStatus? logExportStatus,
    FormStatus? moreLogsStatus,
    FilterCriteria? filterCriteria,
    int? tapLoadNewerRecordsCount,
    String? errmsg,
    String? logExportMsg,
    String? logExportFilePath,
    String? moreLogsMessage,
    bool? isShowFloatingActionButton,
  }) {
    return SystemLogState(
      logs: logs ?? this.logs,
      status: status ?? this.status,
      targetDeviceStatus: targetDeviceStatus ?? this.targetDeviceStatus,
      logExportStatus: logExportStatus ?? this.logExportStatus,
      moreLogsStatus: moreLogsStatus ?? this.moreLogsStatus,
      filterCriteria: filterCriteria ?? this.filterCriteria,
      tapLoadNewerRecordsCount:
          tapLoadNewerRecordsCount ?? this.tapLoadNewerRecordsCount,
      errmsg: errmsg ?? this.errmsg,
      logExportMsg: logExportMsg ?? this.logExportMsg,
      logExportFilePath: logExportFilePath ?? this.logExportFilePath,
      moreLogsMessage: moreLogsMessage ?? this.moreLogsMessage,
      isShowFloatingActionButton:
          isShowFloatingActionButton ?? this.isShowFloatingActionButton,
    );
  }

  @override
  List<Object> get props => [
        logs,
        status,
        targetDeviceStatus,
        logExportStatus,
        moreLogsStatus,
        filterCriteria,
        tapLoadNewerRecordsCount,
        errmsg,
        logExportMsg,
        logExportFilePath,
        moreLogsMessage,
        isShowFloatingActionButton,
      ];
}
