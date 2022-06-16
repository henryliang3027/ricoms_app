part of 'edit_group_bloc.dart';

abstract class EditGroupEvent extends Equatable {
  const EditGroupEvent();

  @override
  List<Object> get props => [];
}

class DataRequested extends EditGroupEvent {
  const DataRequested();

  @override
  List<Object> get props => [];
}

class NameChanged extends EditGroupEvent {
  const NameChanged(this.name);
  final String name;

  @override
  List<Object> get props => [name];
}

class DescriptionChanged extends EditGroupEvent {
  const DescriptionChanged(this.description);
  final String description;

  @override
  List<Object> get props => [description];
}

class NodeCreationSubmitted extends EditGroupEvent {
  const NodeCreationSubmitted();
}

class NodeUpdateSubmitted extends EditGroupEvent {
  const NodeUpdateSubmitted();
}
