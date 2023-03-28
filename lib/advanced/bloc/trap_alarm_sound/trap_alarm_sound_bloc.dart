import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_alarm_sound_repository/trap_alarm_sound_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/alarm_sound_config.dart';

part 'trap_alarm_sound_event.dart';
part 'trap_alarm_sound_state.dart';

class TrapAlarmSoundBloc
    extends Bloc<TrapAlarmSoundEvent, TrapAlarmSoundState> {
  TrapAlarmSoundBloc({
    required User user,
    required TrapAlarmSoundRepository trapAlarmSoundRepository,
  })  : _user = user,
        _trapAlarmSoundRepository = trapAlarmSoundRepository,
        super(TrapAlarmSoundState(
          enableTrapAlarmSound: AlarmSoundConfig.activateAlarm,
          enableCriticalAlarmSound: AlarmSoundConfig.enableTrapAlarmSound[3],
          enableWarningAlarmSound: AlarmSoundConfig.enableTrapAlarmSound[2],
          enableNormalAlarmSound: AlarmSoundConfig.enableTrapAlarmSound[1],
          enableNoticeAlarmSound: AlarmSoundConfig.enableTrapAlarmSound[0],
        )) {
    on<TrapAlarmSoundEnabled>(_onTrapAlarmSoundEnabled);
    on<CriticalAlarmSoundEnabled>(_onCriticalAlarmSoundEnabled);
    on<WarningAlarmSoundEnabled>(_onWarningAlarmSoundEnabled);
    on<NormalAlarmSoundEnabled>(_onNormalAlarmSoundEnabled);
    on<NoticeAlarmSoundEnabled>(_onNoticeAlarmSoundEnabled);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<TrapAlarmSoundEnableSaved>(_onTrapAlarmSoundEnableSaved);
  }

  final User _user;
  final TrapAlarmSoundRepository _trapAlarmSoundRepository;

  /// 是否開啟警告聲設定
  void _onTrapAlarmSoundEnabled(
    TrapAlarmSoundEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      enableTrapAlarmSound: event.enableTrapAlarmSound,
    ));
  }

  /// 是否開啟 Critical 警告聲
  void _onCriticalAlarmSoundEnabled(
    CriticalAlarmSoundEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      enableCriticalAlarmSound: event.enableCriticalAlarmSound,
    ));
  }

  /// 是否開啟 Warning 警告聲
  void _onWarningAlarmSoundEnabled(
    WarningAlarmSoundEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      enableWarningAlarmSound: event.enableWarningAlarmSound,
    ));
  }

  /// 是否開啟 Normal 警告聲
  void _onNormalAlarmSoundEnabled(
    NormalAlarmSoundEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      enableNormalAlarmSound: event.enableNormalAlarmSound,
    ));
  }

  /// 是否開啟 Notice 警告聲
  void _onNoticeAlarmSoundEnabled(
    NoticeAlarmSoundEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      enableNoticeAlarmSound: event.enableNoticeAlarmSound,
    ));
  }

  /// 處理編輯模式的開啟
  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      isEditing: true,
    ));
  }

  /// 處理編輯模式的關閉, 並恢復目前設定值
  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      isEditing: false,
      enableTrapAlarmSound: AlarmSoundConfig.activateAlarm,
      enableCriticalAlarmSound: AlarmSoundConfig.enableTrapAlarmSound[3],
      enableWarningAlarmSound: AlarmSoundConfig.enableTrapAlarmSound[2],
      enableNormalAlarmSound: AlarmSoundConfig.enableTrapAlarmSound[1],
      enableNoticeAlarmSound: AlarmSoundConfig.enableTrapAlarmSound[0],
    ));
  }

  /// 處理警告聲的狀態(開啟/關閉)儲存, 儲存於手機端
  void _onTrapAlarmSoundEnableSaved(
    TrapAlarmSoundEnableSaved event,
    Emitter<TrapAlarmSoundState> emit,
  ) async {
    emit(state.copyWith(status: FormStatus.requestInProgress));

    AlarmSoundConfig.setAlarmSoundEnableValues([
      state.enableTrapAlarmSound,
      state.enableNoticeAlarmSound,
      state.enableNormalAlarmSound,
      state.enableWarningAlarmSound,
      state.enableCriticalAlarmSound,
    ]);

    List<dynamic> result = await _trapAlarmSoundRepository
        .setAlarmSoundEnableValues(user: _user, alarmSoundEnableValues: [
      state.enableTrapAlarmSound,
      state.enableNoticeAlarmSound,
      state.enableNormalAlarmSound,
      state.enableWarningAlarmSound,
      state.enableCriticalAlarmSound,
    ]);

    if (result[0]) {
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        isEditing: false,
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        isEditing: false,
        errmsg: result[1],
      ));
    }
  }
}
