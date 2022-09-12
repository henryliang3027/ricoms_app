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

class DeviceTypeNodeUpdated extends RootEvent {
  const DeviceTypeNodeUpdated();

  @override
  List<Object?> get props => [];
}

class NodeDeleted extends RootEvent {
  const NodeDeleted(this.node);

  final Node node;

  @override
  List<Object?> get props => [node];
}

class NodesExported extends RootEvent {
  const NodesExported();

  @override
  List<Object?> get props => [];
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

class BookmarksChanged extends RootEvent {
  const BookmarksChanged(this.node); //edfa id or a8k slot id

  final Node node;

  @override
  List<Object?> get props => [node];
}
