part of 'device_bloc.dart';

class DeviceState extends Equatable {
  const DeviceState({
    this.formStatus = FormStatus.requestInProgress,
    this.submissionStatus = SubmissionStatus.none,
    this.saveResultMsg = '',
    this.editable = false,
    this.isEditing = false,
    this.controllerInitialValues = const <String, String>{},
    this.controllerValues = const <String, String>{},
    this.controllerPropertiesCollection = const [],
  });

  final FormStatus formStatus;
  final SubmissionStatus submissionStatus;
  final String saveResultMsg;
  final bool editable;
  final bool isEditing;
  final Map<String, String> controllerInitialValues;
  final Map<String, String> controllerValues;
  final List<List<ControllerProperty>> controllerPropertiesCollection;

  DeviceState copyWith({
    FormStatus? formStatus,
    SubmissionStatus? submissionStatus,
    String? saveResultMsg,
    bool? editable,
    bool? isEditing,
    Map<String, String>? controllerInitialValues,
    Map<String, String>? controllerValues,
    List<List<ControllerProperty>>? controllerPropertiesCollection,
  }) {
    return DeviceState(
      formStatus: formStatus ?? this.formStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      saveResultMsg: saveResultMsg ?? this.saveResultMsg,
      editable: editable ?? this.editable,
      isEditing: isEditing ?? this.isEditing,
      controllerInitialValues:
          controllerInitialValues ?? this.controllerInitialValues,
      controllerValues: controllerValues ?? this.controllerValues,
      controllerPropertiesCollection:
          controllerPropertiesCollection ?? this.controllerPropertiesCollection,
    );
  }

  @override
  List<Object?> get props => [
        formStatus,
        submissionStatus,
        saveResultMsg,
        editable,
        isEditing,
        controllerPropertiesCollection,
        controllerInitialValues,
        controllerValues,
      ];
}
