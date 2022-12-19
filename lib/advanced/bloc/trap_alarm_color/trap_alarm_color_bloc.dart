import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/trap_alarm_color_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'trap_alarm_color_event.dart';
part 'trap_alarm_color_state.dart';

class TrapAlarmColorBloc
    extends Bloc<TrapAlarmColorEvent, TrapAlarmColorState> {
  TrapAlarmColorBloc({
    required User user,
    required TrapAlarmColorRepository trapAlarmColorRepository,
  })  : _user = user,
        _trapAlarmColorRepository = trapAlarmColorRepository,
        super(const TrapAlarmColorState()) {
    on<CriticalBackgroundColorChanged>(_onCriticalBackgroundColorChanged);
  }

  final User _user;
  final TrapAlarmColorRepository _trapAlarmColorRepository;

  void _onCriticalBackgroundColorChanged(
    CriticalBackgroundColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      criticalBackgroundColor: event.criticalBackgroundColor,
    ));
  }
}
