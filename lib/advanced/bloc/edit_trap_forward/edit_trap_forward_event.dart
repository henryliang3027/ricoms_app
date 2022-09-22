part of 'edit_trap_forward_bloc.dart';

abstract class EditTrapForwardEvent extends Equatable {
  const EditTrapForwardEvent();
}

class ForwardDetailRequested extends EditTrapForwardEvent {
  const ForwardDetailRequested(this.id);

  final int id;

  @override
  List<Object> get props => [id];
}

class ForwardEnabledChanged extends EditTrapForwardEvent {
  const ForwardEnabledChanged(this.enable);

  final bool enable;

  @override
  List<Object> get props => [enable];
}

class NameChanged extends EditTrapForwardEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class IPChanged extends EditTrapForwardEvent {
  const IPChanged(this.ip);

  final String ip;

  @override
  List<Object> get props => [ip];
}

class ParametersChanged extends EditTrapForwardEvent {
  const ParametersChanged(
    this.indexOfParameter,
    this.value,
  );

  final int indexOfParameter;
  final bool value;

  @override
  List<Object> get props => [
        indexOfParameter,
        value,
      ];
}

class ForwardDetailUpdateSubmitted extends EditTrapForwardEvent {
  const ForwardDetailUpdateSubmitted();

  @override
  List<Object> get props => [];
}

class ForwardDetailCreateSubmitted extends EditTrapForwardEvent {
  const ForwardDetailCreateSubmitted();

  @override
  List<Object> get props => [];
}
