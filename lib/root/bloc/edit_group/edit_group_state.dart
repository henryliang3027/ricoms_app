part of 'edit_group_bloc.dart';

class EditGroupState extends Equatable {
  const EditGroupState({
    this.status = FormzStatus.pure,
    this.isInitController = false,
    this.currentNode,
    this.isEditing = false,
    this.parentName = '',
    this.name = const Name.pure(),
    this.description = '',
    this.msg = '',
  });

  final FormzStatus status;
  final bool isInitController;
  final Node? currentNode;
  final bool isEditing;
  final String parentName;
  final Name name;
  final String description;
  final String msg;

  EditGroupState copyWith({
    FormzStatus? status,
    bool? isInitController,
    Node? currentNode,
    bool? isEditing,
    String? parentName,
    Name? name,
    String? description,
    String? msg,
  }) {
    return EditGroupState(
      status: status ?? this.status,
      isInitController: isInitController ?? this.isInitController,
      currentNode: currentNode ?? this.currentNode,
      isEditing: isEditing ?? this.isEditing,
      parentName: parentName ?? this.parentName,
      name: name ?? this.name,
      description: description ?? this.description,
      msg: msg ?? this.msg,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isInitController,
        currentNode,
        isEditing,
        parentName,
        name,
        description,
        msg,
      ];
}
