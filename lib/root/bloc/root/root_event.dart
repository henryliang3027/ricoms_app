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

class ParentDataRequested extends RootEvent {
  const ParentDataRequested(this.child);

  final Node child;

  @override
  List<Object?> get props => [child];
}
