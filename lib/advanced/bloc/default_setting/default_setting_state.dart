part of 'default_setting_bloc.dart';

class DefaultSettingState extends Equatable {
  const DefaultSettingState({
    this.status = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
    this.isEditing = false,
    this.defaultSettingItems = const [],
    // this.deviceWorkingCycle = '',
    // this.archivedHistoricalRecordQuanitiy = '',
    // this.enableApiLogPreservation = false,
    // this.apiLogPreservedQuantity = '',
    // this.apiLogPreservedDays = '',
    // this.enableUserSystemLogPreservation = false,
    // this.userSystemLogPreservedQuantity = '',
    // this.userSystemLogPreservedDays = '',
    // this.enableDeviceSystemLogPreservation = false,
    // this.deviceSystemLogPreservedQuantity = '',
    // this.deviceSystemLogPreservedDays = '',
    this.requestErrorMsg = '',
    this.submissionErrorMsg = '',
  });

  final FormStatus status;
  final SubmissionStatus submissionStatus;
  final bool isEditing;
  final List<DefaultSettingItem> defaultSettingItems;
  // final String deviceWorkingCycle;
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

  DefaultSettingState copyWith({
    FormStatus? status,
    SubmissionStatus? submissionStatus,
    bool? isEditing,
    List<DefaultSettingItem>? defaultSettingItems,
    // String? deviceWorkingCycle,
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
    return DefaultSettingState(
      status: status ?? this.status,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      isEditing: isEditing ?? this.isEditing,
      defaultSettingItems: defaultSettingItems ?? this.defaultSettingItems,
      // deviceWorkingCycle: deviceWorkingCycle ?? this.deviceWorkingCycle,
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
        defaultSettingItems,
        // deviceWorkingCycle,
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
