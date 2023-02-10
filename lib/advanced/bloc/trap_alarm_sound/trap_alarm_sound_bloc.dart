import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/trap_alarm_sound_repository.dart';
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

  void _onTrapAlarmSoundEnabled(
    TrapAlarmSoundEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      enableTrapAlarmSound: event.enableTrapAlarmSound,
    ));
  }

  void _onCriticalAlarmSoundEnabled(
    CriticalAlarmSoundEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      enableCriticalAlarmSound: event.enableCriticalAlarmSound,
    ));
  }

  void _onWarningAlarmSoundEnabled(
    WarningAlarmSoundEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      enableWarningAlarmSound: event.enableWarningAlarmSound,
    ));
  }

  void _onNormalAlarmSoundEnabled(
    NormalAlarmSoundEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      enableNormalAlarmSound: event.enableNormalAlarmSound,
    ));
  }

  void _onNoticeAlarmSoundEnabled(
    NoticeAlarmSoundEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      enableNoticeAlarmSound: event.enableNoticeAlarmSound,
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      isEditing: true,
    ));
  }

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
