part of 'edit_device_bloc.dart';

class EditDeviceState extends Equatable {
  const EditDeviceState({
    this.status = FormzStatus.pure,
    this.isInitController = false,
    this.currentNode,
    this.isEditing = false,
    this.parentName = '',
    this.name = const Name.pure(),
    this.deviceIP = const DeviceIP.pure(),
    this.read = 'public',
    this.write = 'private',
    this.description = '',
    this.location = '',
    this.msg = '',
  });

  final FormzStatus status;
  final bool isInitController;
  final Node? currentNode;
  final bool isEditing;
  final String parentName;
  final Name name;
  final DeviceIP deviceIP;
  final String read;
  final String write;
  final String description;
  final String location;
  final String msg;

  EditDeviceState copyWith({
    FormzStatus? status,
    bool? isInitController,
    Node? currentNode,
    bool? isEditing,
    String? parentName,
    Name? name,
    DeviceIP? deviceIP,
    String? read,
    String? write,
    String? description,
    String? location,
    String? msg,
  }) {
    return EditDeviceState(
      status: status ?? this.status,
      isInitController: isInitController ?? this.isInitController,
      currentNode: currentNode ?? this.currentNode,
      isEditing: isEditing ?? this.isEditing,
      parentName: parentName ?? this.parentName,
      name: name ?? this.name,
      deviceIP: deviceIP ?? this.deviceIP,
      read: read ?? this.read,
      write: write ?? this.write,
      description: description ?? this.description,
      location: location ?? this.location,
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
        deviceIP,
        read,
        write,
        description,
        location,
        msg,
      ];
}
