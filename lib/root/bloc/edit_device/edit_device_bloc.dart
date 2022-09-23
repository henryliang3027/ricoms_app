import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/models/device_ip.dart';
import 'package:ricoms_app/root/models/name.dart';

part 'edit_device_event.dart';
part 'edit_device_state.dart';

class EditDeviceBloc extends Bloc<EditDeviceEvent, EditDeviceState> {
  EditDeviceBloc(
      {required User user,
      required RootRepository rootRepository,
      required Node parentNode,
      required bool isEditing,
      Node? currentNode})
      : _user = user,
        _rootRepository = rootRepository,
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
    on<NodeCreationSubmitted>(_onNodeCreationSubmitted);
    on<NodeUpdateSubmitted>(_onNodeUpdateSubmitted);
    on<DeviceConnectRequested>(_onDeviceConnectRequested);

    add(const DataRequested());
  }

  final User _user;
  final RootRepository _rootRepository;
  final Node _parentNode;
  final Node? _currentNode;
  final _type = 2;

  Future<void> _onDataRequested(
    DataRequested event,
    Emitter<EditDeviceState> emit,
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
        final deviceIP = DeviceIP.dirty(newCurrentNode.info!.ip);

        emit(
          state.copyWith(
            isInitController: true,
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
    } else {
      emit(state.copyWith(
        isInitController: true,
        read: state.read,
        write: state.write,
      ));
    }
  }

  void _onNameChanged(
    NameChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(
      state.copyWith(
        isInitController: false,
        isTestConnection: false,
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
        isInitController: false,
        isTestConnection: false,
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
      state.copyWith(
        isInitController: false,
        isTestConnection: false,
        read: event.read,
        status: Formz.validate([state.name, state.deviceIP]),
      ),
    );
  }

  void _onWriteChanged(
    WriteChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    emit(
      state.copyWith(
        isInitController: false,
        isTestConnection: false,
        write: event.write,
        status: Formz.validate([state.name, state.deviceIP]),
      ),
    );
  }

  void _onDescriptionChanged(
    DescriptionChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    emit(
      state.copyWith(
        isInitController: false,
        isTestConnection: false,
        description: event.description,
        status: Formz.validate([state.name, state.deviceIP]),
      ),
    );
  }

  void _onLocationChanged(
    LocationChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    emit(
      state.copyWith(
        isInitController: false,
        isTestConnection: false,
        location: event.location,
        status: Formz.validate([state.name, state.deviceIP]),
      ),
    );
  }

  Future<void> _onNodeCreationSubmitted(
    NodeCreationSubmitted event,
    Emitter<EditDeviceState> emit,
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
        deviceIP: state.deviceIP.value,
        read: state.read,
        write: state.write,
        location: state.location,
      );

      if (msg[0]) {
        emit(state.copyWith(
          isInitController: false,
          isTestConnection: false,
          msg: msg[1],
          status: FormzStatus.submissionSuccess,
        ));
      } else {
        emit(state.copyWith(
          isInitController: false,
          isTestConnection: false,
          msg: msg[1],
          status: FormzStatus.submissionFailure,
        ));
      }
    }
  }

  Future<void> _onNodeUpdateSubmitted(
    NodeUpdateSubmitted event,
    Emitter<EditDeviceState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      // new password is the same as confirm password
      List<dynamic> msg = await _rootRepository.updateNode(
        user: _user,
        currentNode: state.currentNode!,
        name: state.name.value,
        description: state.description,
        deviceIP: state.deviceIP.value,
        read: state.read,
        write: state.write,
        location: state.location,
      );

      if (msg[0]) {
        emit(state.copyWith(
          isInitController: false,
          isTestConnection: false,
          msg: msg[1],
          status: FormzStatus.submissionSuccess,
        ));
      } else {
        emit(state.copyWith(
          isInitController: false,
          isTestConnection: false,
          msg: msg[1],
          status: FormzStatus.submissionFailure,
        ));
      }
    }
  }

  Future<void> _onDeviceConnectRequested(
    DeviceConnectRequested event,
    Emitter<EditDeviceState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(
        status: FormzStatus.submissionInProgress,
        isTestConnection: true,
      ));

      // new password is the same as confirm password
      List<dynamic> msg = await _rootRepository.connectDevice(
          user: _user,
          currentNodeID: state.currentNode!.id,
          ip: state.deviceIP.value,
          read: state.read);

      if (msg[0]) {
        emit(state.copyWith(
          isInitController: false,
          isTestConnection: false,
          msg: msg[1],
          status: FormzStatus.submissionSuccess,
        ));
      } else {
        emit(state.copyWith(
          isInitController: false,
          isTestConnection: false,
          msg: msg[1],
          status: FormzStatus.submissionFailure,
        ));
      }
    }
  }
}
