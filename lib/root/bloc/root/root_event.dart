part of 'root_bloc.dart';

abstract class RootEvent extends Equatable {
  const RootEvent();
}

class ChildDataRequested extends RootEvent {
  const ChildDataRequested(this.parent, this.requestMode);

  final Node parent;
  final RequestMode requestMode;

  @override
  List<Object?> get props => [parent, requestMode];
}

class ChildDataUpdated extends RootEvent {
  const ChildDataUpdated();

  @override
  List<Object?> get props => [];
}

class DeviceDeletionCheckRequested extends RootEvent {
  const DeviceDeletionCheckRequested();

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

class DataSheetOpened extends RootEvent {
  const DataSheetOpened(this.node); //edfa id or a8k slot id

  final Node node;

  @override
  List<Object?> get props => [node];
}
