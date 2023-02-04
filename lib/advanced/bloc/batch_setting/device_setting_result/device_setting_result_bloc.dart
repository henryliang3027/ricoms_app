import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/batch_setting_repository.dart';
import 'package:ricoms_app/repository/user.dart';

part 'device_setting_result_event.dart';
part 'device_setting_result_state.dart';

class DeviceSettingResultBloc
    extends Bloc<DeviceSettingResultEvent, DeviceSettingResultState> {
  DeviceSettingResultBloc({
    required User user,
    required BatchSettingRepository batchSettingRepository,
  })  : _user = user,
        _batchSettingRepository = batchSettingRepository,
        super(DeviceSettingResultInitial()) {
    on<DeviceSettingResultEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  final User _user;
  final BatchSettingRepository _batchSettingRepository;
}
