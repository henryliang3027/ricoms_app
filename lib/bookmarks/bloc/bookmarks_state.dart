part of 'bookmarks_bloc.dart';

class BookmarksState extends Equatable {
  const BookmarksState({
    this.formStatus = FormStatus.none,
    this.loadMoreDeviceStatus = FormStatus.none,
    this.targetDeviceStatus = FormStatus.none,
    this.deviceDeleteStatus = FormStatus.none,
    this.devices = const [],
    this.selectedDevices = const [],
    this.isDeleteMode = false,
    this.hasReachedMax = false,
    this.targetDeviceMsg = '',
    this.requestErrorMsg = '',
    this.deleteResultMsg = '',
  });

  final FormStatus formStatus;
  final FormStatus loadMoreDeviceStatus;
  final FormStatus targetDeviceStatus;
  final FormStatus deviceDeleteStatus;
  final List<Device> devices;
  final List<Device> selectedDevices;
  final bool isDeleteMode;
  final bool hasReachedMax;
  final String targetDeviceMsg;
  final String requestErrorMsg;
  final String deleteResultMsg;

  BookmarksState copyWith({
    FormStatus? formStatus,
    FormStatus? loadMoreDeviceStatus,
    FormStatus? targetDeviceStatus,
    FormStatus? deviceDeleteStatus,
    List<Device>? devices,
    List<Device>? selectedDevices,
    bool? hasReachedMax,
    bool? isDeleteMode,
    String? targetDeviceMsg,
    String? requestErrorMsg,
    String? deleteResultMsg,
  }) {
    return BookmarksState(
      formStatus: formStatus ?? this.formStatus,
      loadMoreDeviceStatus: loadMoreDeviceStatus ?? this.loadMoreDeviceStatus,
      targetDeviceStatus: targetDeviceStatus ?? this.targetDeviceStatus,
      deviceDeleteStatus: deviceDeleteStatus ?? this.deviceDeleteStatus,
      devices: devices ?? this.devices,
      selectedDevices: selectedDevices ?? this.selectedDevices,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isDeleteMode: isDeleteMode ?? this.isDeleteMode,
      targetDeviceMsg: targetDeviceMsg ?? this.targetDeviceMsg,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
      deleteResultMsg: deleteResultMsg ?? this.deleteResultMsg,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        loadMoreDeviceStatus,
        targetDeviceStatus,
        deviceDeleteStatus,
        devices,
        selectedDevices,
        hasReachedMax,
        isDeleteMode,
        targetDeviceMsg,
        requestErrorMsg,
        deleteResultMsg,
      ];
}
