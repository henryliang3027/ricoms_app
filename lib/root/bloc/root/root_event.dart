part of 'root_bloc.dart';

abstract class RootEvent extends Equatable {
  const RootEvent();
}

class ChildDataRequested extends RootEvent {
  const ChildDataRequested(this.parent);

  final Node parent;

  @override
  List<Object?> get props => [parent];
}

class ChildDataUpdated extends RootEvent {
  const ChildDataUpdated();

  @override
  List<Object?> get props => [];
}

class NodeDeleted extends RootEvent {
  const NodeDeleted(this.node);

  final Node node;

  @override
  List<Object?> get props => [node];
}
