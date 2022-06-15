import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/models/device_ip.dart';
import 'package:ricoms_app/root/models/name.dart';

part 'edit_device_event.dart';
part 'edit_device_state.dart';

class EditDeviceBloc extends Bloc<EditDeviceEvent, EditDeviceState> {
  EditDeviceBloc(
      {required RootRepository rootRepository,
      required Node parentNode,
      required bool isEditing,
      Node? currentNode})
      : _rootRepository = rootRepository,
        _parentNode = parentNode,
        _currentNode = currentNode,
        super(EditDeviceState(
          parentName: parentNode.name,
          isEditing: isEditing,
          currentNode: currentNode,
        )) {
    on<DataRequested>(_onDataRequested);
    on<NameChanged>(_onNameChanged);
    on<DeviceIPChanged>(_onDeviceIPChanged);
    on<ReadChanged>(_onReadChanged);
    on<WriteChanged>(_onWriteChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<LocationChanged>(_onLocationChanged);
    on<FormSubmitted>(_onFormSubmmited);

    add(const DataRequested());
  }

  final RootRepository _rootRepository;
  final Node _parentNode;
  final Node? _currentNode;
  final _type = 2;

  Future<void> _onDataRequested(
    DataRequested event,
    Emitter<EditDeviceState> emit,
  ) async {
    if (state.isEditing && _currentNode != null) {
      var info = await _rootRepository.getNodeInfo(_currentNode!.id);

      if (info.runtimeType == Info) {
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
          info: info,
        );

        final name = Name.dirty(newCurrentNode.name);
        final deviceIP = DeviceIP.dirty(newCurrentNode.info!.ip);

        emit(
          state.copyWith(
            currentNode: newCurrentNode,
            name: name,
            deviceIP: deviceIP,
            read: newCurrentNode.info!.read,
            write: newCurrentNode.info!.write,
            description: newCurrentNode.info!.description,
            location: newCurrentNode.info!.location,
            status: Formz.validate([name, deviceIP]),
          ),
        );
      }
    }
  }

  void _onNameChanged(
    NameChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
        status: Formz.validate([name, state.deviceIP]),
      ),
    );
  }

  void _onDeviceIPChanged(
    DeviceIPChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    final deviceIP = DeviceIP.dirty(event.deviceIP);
    emit(
      state.copyWith(
        deviceIP: deviceIP,
        status: Formz.validate([state.name, deviceIP]),
      ),
    );
  }

  void _onReadChanged(
    ReadChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    emit(
      state.copyWith(read: event.read),
    );
  }

  void _onWriteChanged(
    WriteChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    emit(
      state.copyWith(write: event.write),
    );
  }

  void _onDescriptionChanged(
    DescriptionChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    emit(
      state.copyWith(description: event.description),
    );
  }

  void _onLocationChanged(
    LocationChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    emit(
      state.copyWith(location: event.location),
    );
  }

  Future<void> _onFormSubmmited(
    FormSubmitted event,
    Emitter<EditDeviceState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      // new password is the same as confirm password

      List<dynamic> msg = await _rootRepository.createNode(
        parentId: _parentNode.id,
        type: _type,
        name: state.name.value,
        description: state.description,
        deviceIP: state.deviceIP.value,
        read: state.read,
        write: state.write,
        location: state.location,
      );

      if (msg[0]) {
        emit(state.copyWith(
          msg: msg[1],
          status: FormzStatus.submissionSuccess,
        ));
      } else {
        emit(state.copyWith(
          msg: msg[1],
          status: FormzStatus.submissionFailure,
        ));
      }
    }
  }
}
