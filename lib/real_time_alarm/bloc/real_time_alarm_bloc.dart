import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/repository/real_time_alarm_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'real_time_alarm_event.dart';
part 'real_time_alarm_state.dart';

class RealTimeAlarmBloc extends Bloc<RealTimeAlarmEvent, RealTimeAlarmState> {
  RealTimeAlarmBloc({
    required User user,
    required RealTimeAlarmRepository realTimeAlarmRepository,
  })  : _user = user,
        _realTimeAlarmRepository = realTimeAlarmRepository,
        super(const RealTimeAlarmState()) {
    on<AllAlarmRequested>(_onAllAlarmRequested);
    on<CriticalAlarmRequested>(_onCriticalAlarmRequested);
    on<WarningAlarmRequested>(_onWarningAlarmRequested);
    on<NormalAlarmRequested>(_onNormalAlarmRequested);
    on<NoticeAlarmRequested>(_onNoticeAlarmRequested);

    add(const AllAlarmRequested());
    add(const CriticalAlarmRequested());
    add(const WarningAlarmRequested());
    add(const NormalAlarmRequested());
    add(const NoticeAlarmRequested());
  }

  final User _user;
  final RealTimeAlarmRepository _realTimeAlarmRepository;

  Future<void> _onAllAlarmRequested(
    AllAlarmRequested event,
    Emitter<RealTimeAlarmState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    List<dynamic> result =
        await _realTimeAlarmRepository.getRealTimeAlarm(_user, AlarmType.all);

    if (result[0]) {
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        allAlarms: result[1],
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        allAlarms: [result[1]],
      ));
    }
  }

  Future<void> _onCriticalAlarmRequested(
    CriticalAlarmRequested event,
    Emitter<RealTimeAlarmState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    List<dynamic> result = await _realTimeAlarmRepository.getRealTimeAlarm(
        _user, AlarmType.critical);

    if (result[0]) {
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        criticalAlarms: result[1],
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        criticalAlarms: [result[1]],
      ));
    }
  }

  Future<void> _onWarningAlarmRequested(
    WarningAlarmRequested event,
    Emitter<RealTimeAlarmState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    List<dynamic> result = await _realTimeAlarmRepository.getRealTimeAlarm(
        _user, AlarmType.warning);

    if (result[0]) {
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        warningAlarms: result[1],
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        warningAlarms: [result[1]],
      ));
    }
  }

  Future<void> _onNormalAlarmRequested(
    NormalAlarmRequested event,
    Emitter<RealTimeAlarmState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    List<dynamic> result = await _realTimeAlarmRepository.getRealTimeAlarm(
        _user, AlarmType.normal);

    if (result[0]) {
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        normalAlarms: result[1],
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        normalAlarms: [result[1]],
      ));
    }
  }

  Future<void> _onNoticeAlarmRequested(
    NoticeAlarmRequested event,
    Emitter<RealTimeAlarmState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    List<dynamic> result = await _realTimeAlarmRepository.getRealTimeAlarm(
        _user, AlarmType.notice);

    if (result[0]) {
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        noticeAlarms: result[1],
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        noticeAlarms: [result[1]],
      ));
    }
  }
}
