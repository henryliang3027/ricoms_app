part of 'server_ip_setting_bloc.dart';

class ServerIPSettingState extends Equatable {
  const ServerIPSettingState({
    this.status = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
    this.isEditing = false,
    this.masterServerIP = const DeviceIP.pure(),
    this.slaveServerIP = const DeviceIP.pure(),
    this.synchronizationInterval = '',
    this.onlineServerIP = const DeviceIP.pure(),
    this.errmsg = '',
  });

  final FormStatus status;
  final SubmissionStatus submissionStatus;
  final bool isEditing;
  final DeviceIP masterServerIP;
  final DeviceIP slaveServerIP;
  final String synchronizationInterval;
  final DeviceIP onlineServerIP;
  final String errmsg;

  ServerIPSettingState copyWith({
    FormStatus? status,
    SubmissionStatus? submissionStatus,
    bool? isEditing,
    DeviceIP? masterServerIP,
    DeviceIP? slaveServerIP,
    String? synchronizationInterval,
    DeviceIP? onlineServerIP,
    String? errmsg,
  }) {
    return ServerIPSettingState(
      status: status ?? this.status,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      isEditing: isEditing ?? this.isEditing,
      masterServerIP: masterServerIP ?? this.masterServerIP,
      slaveServerIP: slaveServerIP ?? this.slaveServerIP,
      synchronizationInterval:
          synchronizationInterval ?? this.synchronizationInterval,
      onlineServerIP: onlineServerIP ?? this.onlineServerIP,
      errmsg: errmsg ?? this.errmsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        submissionStatus,
        isEditing,
        masterServerIP,
        slaveServerIP,
        synchronizationInterval,
        onlineServerIP,
        errmsg,
      ];
}
