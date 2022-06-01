part of 'threshold_bloc.dart';

class ThresholdState extends Equatable {
  const ThresholdState({
    this.status = FormzStatus.submissionInProgress,
    this.data = const [],
    this.editable = false,
    this.isEditing = false,
    this.controllerValues = const <String, String>{},
  });

  final FormzStatus status;
  final List data;
  final bool editable;
  final bool isEditing;
  final Map<String, String> controllerValues;

  ThresholdState copyWith({
    FormzStatus? status,
    List? data,
    bool? editable,
    bool? isEditing,
    Map<String, String>? controllerValues,
  }) {
    return ThresholdState(
      status: status ?? this.status,
      data: data ?? this.data,
      editable: editable ?? this.editable,
      isEditing: isEditing ?? this.isEditing,
      controllerValues: controllerValues ?? this.controllerValues,
    );
  }

  @override
  List<Object?> get props =>
      [status, data, editable, isEditing, controllerValues];
}
