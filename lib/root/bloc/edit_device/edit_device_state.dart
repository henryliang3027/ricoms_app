part of 'edit_device_bloc.dart';

class EditDeviceState extends Equatable {
  const EditDeviceState({
    this.status = FormzStatus.pure,
    this.name = const Name.pure(),
    this.deviceIP = const DeviceIP.pure(),
    this.errmsg = '',
  });

  final FormzStatus status;
  final Name name;
  final DeviceIP deviceIP;
  final String errmsg;

  EditDeviceState copyWith({
    FormzStatus? status,
    Name? name,
    DeviceIP? deviceIP,
    String? errmsg,
  }) {
    return EditDeviceState(
      status: status ?? this.status,
      name: name ?? this.name,
      deviceIP: deviceIP ?? this.deviceIP,
      errmsg: errmsg ?? this.errmsg,
    );
  }

  @override
  List<Object?> get props => [
        status,
        name,
        deviceIP,
        errmsg,
      ];
}
