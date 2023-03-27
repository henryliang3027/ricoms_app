import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/server_ip_setting.dart';
import 'package:ricoms_app/repository/server_ip_setting_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/models/custom_input.dart';

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

  /// 處理設定資料的獲取
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

      IPv4 masterServerIP = IPv4.dirty(serverIPSetting.masterServerIP);
      IPv4 slaveServerIP = IPv4.dirty(serverIPSetting.slaveServerIP);
      String synchronizationInterval = serverIPSetting.synchronizationInterval;
      IPv4 onlineServerIP = IPv4.dirty(serverIPSetting.onlineServerIP);

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

  /// 處理主伺服器的 ip 數值更改
  void _onMasterServerIPChanged(
    MasterServerIPChanged event,
    Emitter<ServerIPSettingState> emit,
  ) {
    IPv4 masterServerIP = IPv4.dirty(event.masterServerIP);

    emit(state.copyWith(
      status: FormStatus.none,
      submissionStatus: SubmissionStatus.none,
      masterServerIP: masterServerIP,
    ));
  }

  /// 處理副伺服器的 ip 數值更改
  void _onSlaveServerIPChanged(
    SlaveServerIPChanged event,
    Emitter<ServerIPSettingState> emit,
  ) {
    IPv4 slaveServerIP = IPv4.dirty(event.slaveServerIP);

    emit(state.copyWith(
      status: FormStatus.none,
      slaveServerIP: slaveServerIP,
    ));
  }

  /// 處理同步緩衝時間的數值更改, 此數值不可手動更改, 只讀取api相對應欄位,
  /// _SynchronizationIntervalInput 元件的 enable 為 false 等效於一個不可手動輸入的輸入框
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

  /// 處理當前執行伺服器的 ip 數值更改, 此 ip 不可手動更改, 只讀取api相對應欄位
  /// _OnlineServerIPInput 元件的 enable 為 false 等效於一個不可手動輸入的輸入框
  void _onOnlineServerIPChanged(
    OnlineServerIPChanged event,
    Emitter<ServerIPSettingState> emit,
  ) {
    IPv4 onlineServerIP = IPv4.dirty(event.onlineServerIP);

    emit(state.copyWith(
      status: FormStatus.none,
      submissionStatus: SubmissionStatus.none,
      onlineServerIP: onlineServerIP,
    ));
  }

  /// 處理編輯模式的開啟
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

  /// 處理編輯模式的關閉
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

  /// 處理設定資料的儲存, 向後端更新資料
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
