import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/models/device_ip.dart';
import 'package:ricoms_app/root/models/name.dart';

part 'edit_device_event.dart';
part 'edit_device_state.dart';

class EditDeviceBloc extends Bloc<EditDeviceEvent, EditDeviceState> {
  EditDeviceBloc({required RootRepository rootRepository})
      : _rootRepository = rootRepository,
        super(const EditDeviceState()) {
    on<NameChanged>(_onNameChanged);
  }

  final RootRepository _rootRepository;

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
}
