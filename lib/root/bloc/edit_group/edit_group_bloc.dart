import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/models/name.dart';

part 'edit_group_event.dart';
part 'edit_group_state.dart';

class EditGroupBloc extends Bloc<EditGroupEvent, EditGroupState> {
  EditGroupBloc(
      {required User user,
      required RootRepository rootRepository,
      required Node parentNode,
      required bool isEditing,
      Node? currentNode})
      : _user = user,
        _rootRepository = rootRepository,
        _parentNode = parentNode,
        _currentNode = currentNode,
        super(EditGroupState(
          parentName: parentNode.name,
          isEditing: isEditing,
          currentNode: currentNode,
        )) {
    on<DataRequested>(_onDataRequested);
    on<NameChanged>(_onNameChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<NodeCreationSubmitted>(_onNodeCreationSubmitted);
    on<NodeUpdateSubmitted>(_onNodeUpdateSubmitted);
    add(const DataRequested());
  }

  final User _user;
  final RootRepository _rootRepository;
  final Node _parentNode;
  final Node? _currentNode;
  final _type = 1;

  Future<void> _onDataRequested(
    DataRequested event,
    Emitter<EditGroupState> emit,
  ) async {
    if (state.isEditing && _currentNode != null) {
      List<dynamic> resultOfNodeInfo = await _rootRepository.getNodeInfo(
        user: _user,
        nodeId: _currentNode!.id,
      );

      if (resultOfNodeInfo[0]) {
        Node newCurrentNode = Node(
          id: _currentNode!.id,
          name: _currentNode!.name,
          type: _currentNode!.type,
          teg: _currentNode!.teg,
          path: _currentNode!.path,
          shelf: _currentNode!.shelf,
          slot: _currentNode!.slot,
          status: _currentNode!.status,
          sort: _currentNode!.sort,
          info: resultOfNodeInfo[1],
        );

        final name = Name.dirty(newCurrentNode.name);
        final String description = newCurrentNode.info!.description;

        emit(
          state.copyWith(
            isInitController: true,
            name: name,
            description: description,
            status: Formz.validate([name]),
          ),
        );
      }
    }
  }

  void _onNameChanged(
    NameChanged event,
    Emitter<EditGroupState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(
      state.copyWith(
        isInitController: false,
        name: name,
        status: Formz.validate([name]),
      ),
    );
  }

  void _onDescriptionChanged(
    DescriptionChanged event,
    Emitter<EditGroupState> emit,
  ) {
    emit(
      state.copyWith(
        isInitController: false,
        description: event.description,
      ),
    );
  }

  Future<void> _onNodeCreationSubmitted(
    NodeCreationSubmitted event,
    Emitter<EditGroupState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      // new password is the same as confirm password

      List<dynamic> msg = await _rootRepository.createNode(
        user: _user,
        parentId: _parentNode.id,
        type: _type,
        name: state.name.value,
        description: state.description,
      );

      if (msg[0]) {
        emit(state.copyWith(
          isInitController: false,
          msg: msg[1],
          status: FormzStatus.submissionSuccess,
        ));
      } else {
        emit(state.copyWith(
          isInitController: false,
          msg: msg[1],
          status: FormzStatus.submissionFailure,
        ));
      }
    }
  }

  Future<void> _onNodeUpdateSubmitted(
    NodeUpdateSubmitted event,
    Emitter<EditGroupState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      // new password is the same as confirm password
      List<dynamic> msg = await _rootRepository.updateNode(
        user: _user,
        currentNode: state.currentNode!,
        name: state.name.value,
        description: state.description,
      );

      if (msg[0]) {
        emit(state.copyWith(
          isInitController: false,
          msg: msg[1],
          status: FormzStatus.submissionSuccess,
        ));
      } else {
        emit(state.copyWith(
          isInitController: false,
          msg: msg[1],
          status: FormzStatus.submissionFailure,
        ));
      }
    }
  }
}
