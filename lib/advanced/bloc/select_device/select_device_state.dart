part of 'select_device_bloc.dart';

class SelectDeviceState extends Equatable {
  const SelectDeviceState({
    this.status = FormStatus.none,
    this.keyword = '',
    this.devices = const [],
    this.selectedDevices = const {},
    this.requestErrorMsg = '',
  });

  final FormStatus status;
  final String keyword;
  final List<BatchSettingDevice> devices;
  final Map<BatchSettingDevice, bool> selectedDevices;
  final String requestErrorMsg;

  SelectDeviceState copyWith({
    FormStatus? status,
    String? keyword,
    List<BatchSettingDevice>? devices,
    Map<BatchSettingDevice, bool>? selectedDevices,
    String? requestErrorMsg,
  }) {
    return SelectDeviceState(
      status: status ?? this.status,
      keyword: keyword ?? this.keyword,
      devices: devices ?? this.devices,
      selectedDevices: selectedDevices ?? this.selectedDevices,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        keyword,
        devices,
        selectedDevices,
        requestErrorMsg,
      ];
}
