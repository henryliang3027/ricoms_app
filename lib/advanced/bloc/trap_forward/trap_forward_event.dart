part of 'trap_forward_bloc.dart';

abstract class TrapForwardEvent extends Equatable {
  const TrapForwardEvent();
}

class ForwardMetasRequested extends TrapForwardEvent {
  const ForwardMetasRequested();

  @override
  List<Object?> get props => [];
}

class ForwardMetasDeletedModeEnabled extends TrapForwardEvent {
  const ForwardMetasDeletedModeEnabled();

  @override
  List<Object?> get props => [];
}

class ForwardMetasDeletedModeDisabled extends TrapForwardEvent {
  const ForwardMetasDeletedModeDisabled();

  @override
  List<Object?> get props => [];
}

class ForwardMetasItemToggled extends TrapForwardEvent {
  const ForwardMetasItemToggled(this.forwardMeta);

  final ForwardMeta forwardMeta;

  @override
  List<Object?> get props => [forwardMeta];
}

class ForwardMetasDeleted extends TrapForwardEvent {
  const ForwardMetasDeleted();

  @override
  List<Object?> get props => [];
}
