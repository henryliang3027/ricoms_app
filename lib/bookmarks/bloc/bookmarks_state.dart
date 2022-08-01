part of 'bookmarks_bloc.dart';

class BookmarksState extends Equatable {
  const BookmarksState({
    this.formStatus = FormStatus.none,
    this.targetDeviceStatus = FormStatus.none,
    this.deviceDeleteStatus = FormStatus.none,
    this.devices = const [],
    this.selectedDevices = const [],
    this.isDeleteMode = false,
    this.targetDeviceMsg = '',
    this.requestErrorMsg = '',
    this.deleteResultMsg = '',
  });

  final FormStatus formStatus;
  final FormStatus targetDeviceStatus;
  final FormStatus deviceDeleteStatus;
  final List<Device> devices;
  final List<Device> selectedDevices;
  final bool isDeleteMode;
  final String targetDeviceMsg;
  final String requestErrorMsg;
  final String deleteResultMsg;

  BookmarksState copyWith({
    FormStatus? formStatus,
    FormStatus? targetDeviceStatus,
    FormStatus? deviceDeleteStatus,
    List<Device>? devices,
    List<Device>? selectedDevices,
    bool? isDeleteMode,
    String? targetDeviceMsg,
    String? requestErrorMsg,
    String? deleteResultMsg,
  }) {
    return BookmarksState(
      formStatus: formStatus ?? this.formStatus,
      targetDeviceStatus: targetDeviceStatus ?? this.targetDeviceStatus,
      deviceDeleteStatus: deviceDeleteStatus ?? this.deviceDeleteStatus,
      devices: devices ?? this.devices,
      selectedDevices: selectedDevices ?? this.selectedDevices,
      isDeleteMode: isDeleteMode ?? this.isDeleteMode,
      targetDeviceMsg: targetDeviceMsg ?? this.targetDeviceMsg,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
      deleteResultMsg: deleteResultMsg ?? this.deleteResultMsg,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        targetDeviceStatus,
        deviceDeleteStatus,
        devices,
        selectedDevices,
        isDeleteMode,
        targetDeviceMsg,
        requestErrorMsg,
        deleteResultMsg,
      ];
}
