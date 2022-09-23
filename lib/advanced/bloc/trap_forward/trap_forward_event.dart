part of 'trap_forward_bloc.dart';

abstract class TrapForwardEvent extends Equatable {
  const TrapForwardEvent();
}

class ForwardOutlinesRequested extends TrapForwardEvent {
  const ForwardOutlinesRequested();

  @override
  List<Object?> get props => [];
}

class ForwardOutlinesDeletedModeEnabled extends TrapForwardEvent {
  const ForwardOutlinesDeletedModeEnabled();

  @override
  List<Object?> get props => [];
}

class ForwardOutlinesDeletedModeDisabled extends TrapForwardEvent {
  const ForwardOutlinesDeletedModeDisabled();

  @override
  List<Object?> get props => [];
}

class ForwardOutlinesItemToggled extends TrapForwardEvent {
  const ForwardOutlinesItemToggled(this.forwardOutlines);

  final ForwardOutline forwardOutlines;

  @override
  List<Object?> get props => [forwardOutlines];
}

class ForwardOutlineDeleted extends TrapForwardEvent {
  const ForwardOutlineDeleted(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class MultipleForwardOutlinesDeleted extends TrapForwardEvent {
  const MultipleForwardOutlinesDeleted();

  @override
  List<Object?> get props => [];
}
