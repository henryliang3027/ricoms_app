part of 'device_bloc.dart';

class DeviceState extends Equatable {
  const DeviceState({
    this.formStatus = FormStatus.requestInProgress,
    this.submissionStatus = SubmissionStatus.none,
    this.saveResultMsg = '',
    this.data = const [],
    this.editable = false,
    this.isEditing = false,
    this.controllerValues = const <String, String>{},
  });

  final FormStatus formStatus;
  final SubmissionStatus submissionStatus;
  final String saveResultMsg;
  final List data;
  final bool editable;
  final bool isEditing;
  final Map<String, String> controllerValues;

  DeviceState copyWith({
    FormStatus? formStatus,
    SubmissionStatus? submissionStatus,
    String? saveResultMsg,
    List? data,
    bool? editable,
    bool? isEditing,
    Map<String, String>? controllerValues,
  }) {
    return DeviceState(
      formStatus: formStatus ?? this.formStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      saveResultMsg: saveResultMsg ?? this.saveResultMsg,
      data: data ?? this.data,
      editable: editable ?? this.editable,
      isEditing: isEditing ?? this.isEditing,
      controllerValues: controllerValues ?? this.controllerValues,
    );
  }

  @override
  List<Object?> get props => [
        formStatus,
        submissionStatus,
        saveResultMsg,
        data,
        editable,
        isEditing,
        controllerValues
      ];
}
