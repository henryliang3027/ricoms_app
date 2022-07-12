part of 'history_bloc.dart';

class HistoryState extends Equatable {
  const HistoryState({
    this.records = const [],
    this.status = FormStatus.none,
    this.targetDeviceStatus = FormStatus.none,
    this.errmsg = '',
  });

  final FormStatus status;
  final FormStatus targetDeviceStatus;
  final List records;
  final String errmsg;

  HistoryState copyWith({
    FormStatus? status,
    FormStatus? targetDeviceStatus,
    List? records,
    String? errmsg,
  }) {
    return HistoryState(
      status: status ?? this.status,
      targetDeviceStatus: targetDeviceStatus ?? this.targetDeviceStatus,
      records: records ?? this.records,
      errmsg: errmsg ?? this.errmsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        targetDeviceStatus,
        records,
        errmsg,
      ];
}
