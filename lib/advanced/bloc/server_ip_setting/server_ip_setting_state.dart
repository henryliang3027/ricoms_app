part of 'server_ip_setting_bloc.dart';

class ServerIPSettingState extends Equatable {
  const ServerIPSettingState({
    this.status = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
    this.isEditing = false,
    this.masterServerIP = const IPv4.pure(),
    this.slaveServerIP = const IPv4.pure(),
    this.synchronizationInterval = '',
    this.onlineServerIP = const IPv4.pure(),
    this.errmsg = '',
  });

  final FormStatus status;
  final SubmissionStatus submissionStatus;
  final bool isEditing;
  final IPv4 masterServerIP;
  final IPv4 slaveServerIP;
  final String synchronizationInterval;
  final IPv4 onlineServerIP;
  final String errmsg;

  ServerIPSettingState copyWith({
    FormStatus? status,
    SubmissionStatus? submissionStatus,
    bool? isEditing,
    IPv4? masterServerIP,
    IPv4? slaveServerIP,
    String? synchronizationInterval,
    IPv4? onlineServerIP,
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
