import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/server_ip_setting.dart';
import 'package:ricoms_app/repository/server_ip_setting_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/models/device_ip.dart';

part 'server_ip_setting_event.dart';
part 'server_ip_setting_state.dart';

class ServerIPSettingBloc
    extends Bloc<ServerIPSettingEvent, ServerIPSettingState> {
  ServerIPSettingBloc({
    required User user,
    required ServerIPSettingRepository serverIPSettingRepository,
  })  : _user = user,
        _serverIPSettingRepository = serverIPSettingRepository,
        super(const ServerIPSettingState()) {
    on<ServerIPSettingRequested>(_onServerIPSettingRequested);
    on<MasterServerIPChanged>(_onMasterServerIPChanged);
    on<SlaveServerIPChanged>(_onSlaveServerIPChanged);
    on<SynchronizationIntervalChanged>(_onSynchronizationIntervalChanged);
    on<OnlineServerIPChanged>(_onOnlineServerIPChanged);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<ServerIPSettingSaved>(_onServerIPSettingSaved);

    add(const ServerIPSettingRequested());
  }

  final User _user;
  final ServerIPSettingRepository _serverIPSettingRepository;

  void _onServerIPSettingRequested(
    ServerIPSettingRequested event,
    Emitter<ServerIPSettingState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
      submissionStatus: SubmissionStatus.none,
    ));

    List<dynamic> result =
        await _serverIPSettingRepository.getServerIPSetting(user: _user);

    if (result[0]) {
      ServerIPSetting serverIPSetting = result[1];

      DeviceIP masterServerIP = DeviceIP.dirty(serverIPSetting.masterServerIP);
      DeviceIP slaveServerIP = DeviceIP.dirty(serverIPSetting.slaveServerIP);
      String synchronizationInterval = serverIPSetting.synchronizationInterval;
      DeviceIP onlineServerIP = DeviceIP.dirty(serverIPSetting.onlineServerIP);

      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        masterServerIP: masterServerIP,
        slaveServerIP: slaveServerIP,
        synchronizationInterval: synchronizationInterval,
        onlineServerIP: onlineServerIP,
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        errmsg: result[1],
      ));
    }
  }

  void _onMasterServerIPChanged(
    MasterServerIPChanged event,
    Emitter<ServerIPSettingState> emit,
  ) {
    DeviceIP masterServerIP = DeviceIP.dirty(event.masterServerIP);

    emit(state.copyWith(
      status: FormStatus.none,
      submissionStatus: SubmissionStatus.none,
      masterServerIP: masterServerIP,
    ));
  }

  void _onSlaveServerIPChanged(
    SlaveServerIPChanged event,
    Emitter<ServerIPSettingState> emit,
  ) {
    DeviceIP slaveServerIP = DeviceIP.dirty(event.slaveServerIP);

    emit(state.copyWith(
      status: FormStatus.none,
      slaveServerIP: slaveServerIP,
    ));
  }

  void _onSynchronizationIntervalChanged(
    SynchronizationIntervalChanged event,
    Emitter<ServerIPSettingState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      submissionStatus: SubmissionStatus.none,
      synchronizationInterval: event.synchronizationInterval,
    ));
  }

  void _onOnlineServerIPChanged(
    OnlineServerIPChanged event,
    Emitter<ServerIPSettingState> emit,
  ) {
    DeviceIP onlineServerIP = DeviceIP.dirty(event.onlineServerIP);

    emit(state.copyWith(
      status: FormStatus.none,
      submissionStatus: SubmissionStatus.none,
      onlineServerIP: onlineServerIP,
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<ServerIPSettingState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      submissionStatus: SubmissionStatus.none,
      isEditing: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<ServerIPSettingState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      submissionStatus: SubmissionStatus.none,
      isEditing: false,
    ));
  }

  void _onServerIPSettingSaved(
    ServerIPSettingSaved event,
    Emitter<ServerIPSettingState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.none,
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<dynamic> result = await _serverIPSettingRepository.setServerIPSetting(
      user: _user,
      masterServerIP: state.masterServerIP.value,
      slaveServerIP: state.slaveServerIP.value,
      synchronizationInterval: state.synchronizationInterval,
    );

    if (result[0]) {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionSuccess,
        isEditing: false,
      ));
    } else {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionFailure,
        isEditing: false,
        errmsg: result[1],
      ));
    }
  }
}
