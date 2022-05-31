part of 'description_bloc.dart';

class DescriptionState extends Equatable {
  const DescriptionState({
    this.status = FormzStatus.submissionInProgress,
    this.data = const [],
    this.isEditing = false,
    this.controllerValues = const <String, String>{},
  });

  final FormzStatus status;
  final List data;
  final bool isEditing;
  final Map<String, String> controllerValues;

  DescriptionState copyWith({
    FormzStatus? status,
    List? data,
    bool? isEditing,
    Map<String, String>? controllerValues,
  }) {
    return DescriptionState(
      status: status ?? this.status,
      data: data ?? this.data,
      isEditing: isEditing ?? this.isEditing,
      controllerValues: controllerValues ?? this.controllerValues,
    );
  }

  @override
  List<Object?> get props => [status, data, isEditing, controllerValues];
}
