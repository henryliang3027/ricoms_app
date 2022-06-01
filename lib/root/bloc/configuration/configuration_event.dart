part of 'configuration_bloc.dart';

abstract class ConfigurationEvent extends Equatable {
  const ConfigurationEvent();

  @override
  List<Object> get props => [];
}

class ConfigurationDataRequested extends ConfigurationEvent {
  const ConfigurationDataRequested();

  @override
  List<Object> get props => [];
}

class FormStatusChanged extends ConfigurationEvent {
  const FormStatusChanged(this.isEditing);

  final bool isEditing;

  @override
  List<Object> get props => [isEditing];
}

// handle current password visibility
class ControllerValueChanged extends ConfigurationEvent {
  const ControllerValueChanged(this.controllerValues);

  final Map<String, String> controllerValues;
}
