part of 'threshold_bloc.dart';

abstract class ThresholdEvent extends Equatable {
  const ThresholdEvent();

  @override
  List<Object> get props => [];
}

class ThresholdDataRequested extends ThresholdEvent {
  const ThresholdDataRequested();

  @override
  List<Object> get props => [];
}

class FormStatusChanged extends ThresholdEvent {
  const FormStatusChanged(this.isEditing);

  final bool isEditing;

  @override
  List<Object> get props => [isEditing];
}

// handle current password visibility
class ControllerValueChanged extends ThresholdEvent {
  const ControllerValueChanged(this.controllerValues);

  final Map<String, String> controllerValues;
}
