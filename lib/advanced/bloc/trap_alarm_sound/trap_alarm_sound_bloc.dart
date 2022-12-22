import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/trap_alarm_sound_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'trap_alarm_sound_event.dart';
part 'trap_alarm_sound_state.dart';

class TrapAlarmSoundBloc
    extends Bloc<TrapAlarmSoundEvent, TrapAlarmSoundState> {
  TrapAlarmSoundBloc({
    required User user,
    required TrapAlarmSoundRepository trapAlarmSoundRepository,
  })  : _user = user,
        _trapAlarmSoundRepository = trapAlarmSoundRepository,
        super(const TrapAlarmSoundState()) {
    on<TrapAlarmSoundEnabled>(_onTrapAlarmSoundEnabled);
    on<CriticalAlarmSoundEnabled>(_onCriticalAlarmSoundEnabled);
    on<WarningAlarmSoundEnabled>(_onWarningAlarmSoundEnabled);
    on<NormalAlarmSoundEnabled>(_onNormalAlarmSoundEnabled);
    on<NoticeAlarmSoundEnabled>(_onNoticeAlarmSoundEnabled);
    on<TrapAlarmSoundEnableSaved>(_onTrapAlarmSoundEnableSaved);
  }

  final User _user;
  final TrapAlarmSoundRepository _trapAlarmSoundRepository;

  void _onTrapAlarmSoundEnabled(
    TrapAlarmSoundEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      enableTrapAlarmSound: event.enableTrapAlarmSound,
    ));
  }

  void _onCriticalAlarmSoundEnabled(
    CriticalAlarmSoundEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      enableCriticalAlarmSound: event.enableCriticalAlarmSound,
    ));
  }

  void _onWarningAlarmSoundEnabled(
    WarningAlarmSoundEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      enableWarningAlarmSound: event.enableWarningAlarmSound,
    ));
  }

  void _onNormalAlarmSoundEnabled(
    NormalAlarmSoundEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      enableNormalAlarmSound: event.enableNormalAlarmSound,
    ));
  }

  void _onNoticeAlarmSoundEnabled(
    NoticeAlarmSoundEnabled event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(
      enableNoticeAlarmSound: event.enableNoticeAlarmSound,
    ));
  }

  void _onTrapAlarmSoundEnableSaved(
    TrapAlarmSoundEnableSaved event,
    Emitter<TrapAlarmSoundState> emit,
  ) {
    emit(state.copyWith(status: FormStatus.requestInProgress));

    //repo

    emit(state.copyWith(status: FormStatus.requestSuccess));
  }
}
