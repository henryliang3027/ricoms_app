part of 'select_device_bloc.dart';

class SelectDeviceState extends Equatable {
  const SelectDeviceState({
    this.status = FormStatus.none,
    this.keyword = '',
    this.devices = const [],
    this.selectedDeviceIds = const {},
    this.requestErrorMsg = '',
  });

  final FormStatus status;
  final String keyword;
  final List<BatchSettingDevice> devices;
  final Map<int, bool> selectedDeviceIds;
  final String requestErrorMsg;

  SelectDeviceState copyWith({
    FormStatus? status,
    String? keyword,
    List<BatchSettingDevice>? devices,
    Map<int, bool>? selectedDeviceIds,
    String? requestErrorMsg,
  }) {
    return SelectDeviceState(
      status: status ?? this.status,
      keyword: keyword ?? this.keyword,
      devices: devices ?? this.devices,
      selectedDeviceIds: selectedDeviceIds ?? this.selectedDeviceIds,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        keyword,
        devices,
        selectedDeviceIds,
        requestErrorMsg,
      ];
}
