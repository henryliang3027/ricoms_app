part of 'log_record_setting_bloc.dart';

class LogRecordSettingState extends Equatable {
  const LogRecordSettingState({
    this.status = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
    this.isEditing = false,
    this.archivedHistoricalRecordQuanitiy = '',
    this.enableApiLogPreservation = '',
    this.apiLogPreservedQuantity = '',
    this.apiLogPreservedDays = '',
    this.enableUserSystemLogPreservation = '',
    this.userSystemLogPreservedQuantity = '',
    this.userSystemLogPreservedDays = '',
    this.enableDeviceSystemLogPreservation = '',
    this.deviceSystemLogPreservedQuantity = '',
    this.deviceSystemLogPreservedDays = '',
    this.requestErrorMsg = '',
    this.submissionErrorMsg = '',
  });

  final FormStatus status;
  final SubmissionStatus submissionStatus;
  final bool isEditing;
  final String archivedHistoricalRecordQuanitiy;
  final String enableApiLogPreservation;
  final String apiLogPreservedQuantity;
  final String apiLogPreservedDays;
  final String enableUserSystemLogPreservation;
  final String userSystemLogPreservedQuantity;
  final String userSystemLogPreservedDays;
  final String enableDeviceSystemLogPreservation;
  final String deviceSystemLogPreservedQuantity;
  final String deviceSystemLogPreservedDays;
  final String requestErrorMsg;
  final String submissionErrorMsg;

  LogRecordSettingState copyWith({
    FormStatus? status,
    SubmissionStatus? submissionStatus,
    bool? isEditing,
    String? archivedHistoricalRecordQuanitiy,
    String? enableApiLogPreservation,
    String? apiLogPreservedQuantity,
    String? apiLogPreservedDays,
    String? enableUserSystemLogPreservation,
    String? userSystemLogPreservedQuantity,
    String? userSystemLogPreservedDays,
    String? enableDeviceSystemLogPreservation,
    String? deviceSystemLogPreservedQuantity,
    String? deviceSystemLogPreservedDays,
    String? requestErrorMsg,
    String? submissionErrorMsg,
  }) {
    return LogRecordSettingState(
      status: status ?? this.status,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      isEditing: isEditing ?? this.isEditing,
      archivedHistoricalRecordQuanitiy: archivedHistoricalRecordQuanitiy ??
          this.archivedHistoricalRecordQuanitiy,
      enableApiLogPreservation:
          apiLogPreservedQuantity ?? this.apiLogPreservedQuantity,
      apiLogPreservedQuantity:
          enableApiLogPreservation ?? this.enableApiLogPreservation,
      apiLogPreservedDays: apiLogPreservedDays ?? this.apiLogPreservedDays,
      enableUserSystemLogPreservation: enableUserSystemLogPreservation ??
          this.enableUserSystemLogPreservation,
      userSystemLogPreservedQuantity:
          userSystemLogPreservedQuantity ?? this.userSystemLogPreservedQuantity,
      userSystemLogPreservedDays:
          userSystemLogPreservedDays ?? this.userSystemLogPreservedDays,
      enableDeviceSystemLogPreservation: enableDeviceSystemLogPreservation ??
          this.enableDeviceSystemLogPreservation,
      deviceSystemLogPreservedQuantity: deviceSystemLogPreservedQuantity ??
          this.deviceSystemLogPreservedQuantity,
      deviceSystemLogPreservedDays:
          deviceSystemLogPreservedDays ?? this.deviceSystemLogPreservedDays,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
      submissionErrorMsg: submissionErrorMsg ?? this.submissionErrorMsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        submissionStatus,
        isEditing,
        archivedHistoricalRecordQuanitiy,
        enableApiLogPreservation,
        apiLogPreservedQuantity,
        apiLogPreservedDays,
        enableUserSystemLogPreservation,
        userSystemLogPreservedQuantity,
        userSystemLogPreservedDays,
        enableDeviceSystemLogPreservation,
        deviceSystemLogPreservedQuantity,
        deviceSystemLogPreservedDays,
        requestErrorMsg,
        submissionErrorMsg,
      ];
}
