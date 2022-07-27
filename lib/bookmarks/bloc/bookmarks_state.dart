part of 'bookmarks_bloc.dart';

class BookmarksState extends Equatable {
  const BookmarksState({
    this.formStatus = FormStatus.none,
    this.targetDeviceStatus = FormStatus.none,
    this.devices = const [],
    this.isDeleteMode = false,
    this.targetDeviceMsg = '',
    this.requestErrorMsg = '',
  });

  final FormStatus formStatus;
  final FormStatus targetDeviceStatus;
  final List<Device> devices;
  final bool isDeleteMode;
  final String targetDeviceMsg;
  final String requestErrorMsg;

  BookmarksState copyWith({
    FormStatus? formStatus,
    FormStatus? targetDeviceStatus,
    List<Device>? devices,
    bool? isDeleteMode,
    String? targetDeviceMsg,
    String? requestErrorMsg,
  }) {
    return BookmarksState(
      formStatus: formStatus ?? this.formStatus,
      targetDeviceStatus: targetDeviceStatus ?? this.targetDeviceStatus,
      devices: devices ?? this.devices,
      isDeleteMode: isDeleteMode ?? this.isDeleteMode,
      targetDeviceMsg: targetDeviceMsg ?? this.targetDeviceMsg,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        targetDeviceStatus,
        devices,
        isDeleteMode,
        targetDeviceMsg,
        requestErrorMsg,
      ];
}
