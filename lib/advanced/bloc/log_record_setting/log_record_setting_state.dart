part of 'log_record_setting_bloc.dart';

class LogRecordSettingState extends Equatable {
  const LogRecordSettingState({
    this.status = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
    this.isEditing = false,
    this.logRecordSetting = const LogRecordSetting(
      archivedHistoricalRecordQuanitiy: '',
      enableApiLogPreservation: '0',
      apiLogPreservedQuantity: '',
      apiLogPreservedDays: '',
      enableUserSystemLogPreservation: '0',
      userSystemLogPreservedQuantity: '',
      userSystemLogPreservedDays: '',
      enableDeviceSystemLogPreservation: '0',
      deviceSystemLogPreservedQuantity: '',
      deviceSystemLogPreservedDays: '',
    ),
    this.requestErrorMsg = '',
    this.submissionErrorMsg = '',
  });

  final FormStatus status;
  final SubmissionStatus submissionStatus;
  final bool isEditing;
  final LogRecordSetting logRecordSetting;
  // final String archivedHistoricalRecordQuanitiy;
  // final bool enableApiLogPreservation;
  // final String apiLogPreservedQuantity;
  // final String apiLogPreservedDays;
  // final bool enableUserSystemLogPreservation;
  // final String userSystemLogPreservedQuantity;
  // final String userSystemLogPreservedDays;
  // final bool enableDeviceSystemLogPreservation;
  // final String deviceSystemLogPreservedQuantity;
  // final String deviceSystemLogPreservedDays;
  final String requestErrorMsg;
  final String submissionErrorMsg;

  LogRecordSettingState copyWith({
    FormStatus? status,
    SubmissionStatus? submissionStatus,
    bool? isEditing,
    LogRecordSetting? logRecordSetting,
    // String? archivedHistoricalRecordQuanitiy,
    // bool? enableApiLogPreservation,
    // String? apiLogPreservedQuantity,
    // String? apiLogPreservedDays,
    // bool? enableUserSystemLogPreservation,
    // String? userSystemLogPreservedQuantity,
    // String? userSystemLogPreservedDays,
    // bool? enableDeviceSystemLogPreservation,
    // String? deviceSystemLogPreservedQuantity,
    // String? deviceSystemLogPreservedDays,
    String? requestErrorMsg,
    String? submissionErrorMsg,
  }) {
    return LogRecordSettingState(
      status: status ?? this.status,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      isEditing: isEditing ?? this.isEditing,
      logRecordSetting: logRecordSetting ?? this.logRecordSetting,
      // archivedHistoricalRecordQuanitiy: archivedHistoricalRecordQuanitiy ??
      //     this.archivedHistoricalRecordQuanitiy,
      // enableApiLogPreservation:
      //     enableApiLogPreservation ?? this.enableApiLogPreservation,
      // apiLogPreservedQuantity:
      //     apiLogPreservedQuantity ?? this.apiLogPreservedQuantity,
      // apiLogPreservedDays: apiLogPreservedDays ?? this.apiLogPreservedDays,
      // enableUserSystemLogPreservation: enableUserSystemLogPreservation ??
      //     this.enableUserSystemLogPreservation,
      // userSystemLogPreservedQuantity:
      //     userSystemLogPreservedQuantity ?? this.userSystemLogPreservedQuantity,
      // userSystemLogPreservedDays:
      //     userSystemLogPreservedDays ?? this.userSystemLogPreservedDays,
      // enableDeviceSystemLogPreservation: enableDeviceSystemLogPreservation ??
      //     this.enableDeviceSystemLogPreservation,
      // deviceSystemLogPreservedQuantity: deviceSystemLogPreservedQuantity ??
      //     this.deviceSystemLogPreservedQuantity,
      // deviceSystemLogPreservedDays:
      //     deviceSystemLogPreservedDays ?? this.deviceSystemLogPreservedDays,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
      submissionErrorMsg: submissionErrorMsg ?? this.submissionErrorMsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        submissionStatus,
        isEditing,
        logRecordSetting,
        // archivedHistoricalRecordQuanitiy,
        // enableApiLogPreservation,
        // apiLogPreservedQuantity,
        // apiLogPreservedDays,
        // enableUserSystemLogPreservation,
        // userSystemLogPreservedQuantity,
        // userSystemLogPreservedDays,
        // enableDeviceSystemLogPreservation,
        // deviceSystemLogPreservedQuantity,
        // deviceSystemLogPreservedDays,
        requestErrorMsg,
        submissionErrorMsg,
      ];
}
