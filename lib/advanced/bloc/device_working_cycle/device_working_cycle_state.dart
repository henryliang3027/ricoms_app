part of 'device_working_cycle_bloc.dart';

class DeviceWorkingCycleState extends Equatable {
  const DeviceWorkingCycleState({
    this.status = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
    this.deviceWorkingCycleList = const [],
    this.deviceWorkingCycleIndex = '',
    this.requestErrorMsg = '',
  });

  final FormStatus status;
  final SubmissionStatus submissionStatus;
  final List<DeviceWorkingCycle> deviceWorkingCycleList;
  final String deviceWorkingCycleIndex;
  final String requestErrorMsg;

  DeviceWorkingCycleState copyWith({
    FormStatus? status,
    SubmissionStatus? submissionStatus,
    List<DeviceWorkingCycle>? deviceWorkingCycleList,
    String? deviceWorkingCycleIndex,
    String? requestErrorMsg,
  }) {
    return DeviceWorkingCycleState(
      status: status ?? this.status,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      deviceWorkingCycleList:
          deviceWorkingCycleList ?? this.deviceWorkingCycleList,
      deviceWorkingCycleIndex:
          deviceWorkingCycleIndex ?? this.deviceWorkingCycleIndex,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        submissionStatus,
        deviceWorkingCycleList,
        deviceWorkingCycleIndex,
        requestErrorMsg,
      ];
}
