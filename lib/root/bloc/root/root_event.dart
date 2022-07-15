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

class DeviceDataRequested extends RootEvent {
  const DeviceDataRequested(this.node);

  final Node node;

  @override
  List<Object?> get props => [node];
}

class DeviceNavigateRequested extends RootEvent {
  const DeviceNavigateRequested(this.path);

  final List path;

  @override
  List<Object?> get props => [path];
}

class BookmarksAdded extends RootEvent {
  const BookmarksAdded(this.nodeId); //edfa id or a8k slot id

  final int nodeId;

  @override
  List<Object?> get props => [nodeId];
}

class BookmarksDeleted extends RootEvent {
  const BookmarksDeleted(this.nodeId); //edfa id or a8k slot id

  final int nodeId;

  @override
  List<Object?> get props => [nodeId];
}
