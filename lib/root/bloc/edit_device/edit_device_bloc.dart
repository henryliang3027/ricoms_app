import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/repository/root_repository/root_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/models/custom_input.dart';
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

  /// 處理 device 的新增或編輯時需要取得的資料
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
        final deviceIP = IPv4.dirty(newCurrentNode.info!.ip);

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

  /// 處理 name 的更改
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

  /// 處理 device ip 的更改
  void _onDeviceIPChanged(
    DeviceIPChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    final deviceIP = IPv4.dirty(event.deviceIP);
    emit(
      state.copyWith(
        isInitController: false,
        isTestConnection: false,
        deviceIP: deviceIP,
        status: Formz.validate([state.name, deviceIP]),
      ),
    );
  }

  /// 處理 read 的更改
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

  /// 處理 write 的更改
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

  /// 處理 description 的更改
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

  /// 處理 location 的更改
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

  /// 處理 device 的新增並傳給後端
  Future<void> _onNodeCreationSubmitted(
    NodeCreationSubmitted event,
    Emitter<EditDeviceState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

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

  /// 處理 device 的編輯資料更新並傳給後端
  Future<void> _onNodeUpdateSubmitted(
    NodeUpdateSubmitted event,
    Emitter<EditDeviceState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

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

  /// 處理 device 連線測試
  Future<void> _onDeviceConnectRequested(
    DeviceConnectRequested event,
    Emitter<EditDeviceState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(
        status: FormzStatus.submissionInProgress,
      ));

      List<dynamic> msg = await _rootRepository.connectDevice(
          user: _user,
          currentNodeID: state.currentNode!.id,
          ip: state.deviceIP.value,
          read: state.read);

      if (msg[0]) {
        emit(state.copyWith(
          isInitController: false,
          isTestConnection: true,
          msg: msg[1],
          status: FormzStatus.submissionSuccess,
        ));
      } else {
        emit(state.copyWith(
          isInitController: false,
          isTestConnection: true,
          msg: msg[1],
          status: FormzStatus.submissionFailure,
        ));
      }
    }
  }
}
