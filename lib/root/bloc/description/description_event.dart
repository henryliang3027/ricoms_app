part of 'description_bloc.dart';

abstract class DescriptionEvent extends Equatable {
  const DescriptionEvent();

  @override
  List<Object> get props => [];
}

class DescriptionDataRequested extends DescriptionEvent {
  const DescriptionDataRequested();

  @override
  List<Object> get props => [];
}

class FormStatusChanged extends DescriptionEvent {
  const FormStatusChanged(this.isEditing);

  final bool isEditing;

  @override
  List<Object> get props => [isEditing];
}

// handle current password visibility
class ControllerValueChanged extends DescriptionEvent {
  const ControllerValueChanged(this.controllerValues);

  final Map<String, String> controllerValues;
}
