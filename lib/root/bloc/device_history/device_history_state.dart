part of 'device_history_bloc.dart';

class DeviceHistoryState extends Equatable {
  const DeviceHistoryState({
    this.status = FormStatus.none,
    this.moreRecordsStatus = FormStatus.none,
    this.deviceHistoryRecords = const [],
    this.tapLoadNewerRecordsCount = 0,
    this.errmsg = '',
    this.moreRecordsMessage = '',
    this.isShowFloatingActionButton = false,
  });

  final FormStatus status;
  final FormStatus moreRecordsStatus;
  final List<DeviceHistoryData> deviceHistoryRecords;
  final int tapLoadNewerRecordsCount;
  final String errmsg;
  final String moreRecordsMessage;
  final bool isShowFloatingActionButton;

  DeviceHistoryState copyWith({
    FormStatus? status,
    FormStatus? moreRecordsStatus,
    List<DeviceHistoryData>? deviceHistoryRecords,
    int? tapLoadNewerRecordsCount,
    String? errmsg,
    String? moreRecordsMessage,
    bool? isShowFloatingActionButton,
  }) {
    return DeviceHistoryState(
      status: status ?? this.status,
      moreRecordsStatus: moreRecordsStatus ?? this.moreRecordsStatus,
      deviceHistoryRecords: deviceHistoryRecords ?? this.deviceHistoryRecords,
      tapLoadNewerRecordsCount:
          tapLoadNewerRecordsCount ?? this.tapLoadNewerRecordsCount,
      errmsg: errmsg ?? this.errmsg,
      moreRecordsMessage: moreRecordsMessage ?? this.moreRecordsMessage,
      isShowFloatingActionButton:
          isShowFloatingActionButton ?? this.isShowFloatingActionButton,
    );
  }

  @override
  List<Object> get props => [
        status,
        moreRecordsStatus,
        deviceHistoryRecords,
        tapLoadNewerRecordsCount,
        errmsg,
        isShowFloatingActionButton,
      ];
}
