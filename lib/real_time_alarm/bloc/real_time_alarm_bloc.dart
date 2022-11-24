import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/repository/real_time_alarm_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_request.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

part 'real_time_alarm_event.dart';
part 'real_time_alarm_state.dart';

const throttleDuration = Duration(milliseconds: 1000);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

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
    on<AlarmPeriodicUpdated>(_onAlarmPeriodicUpdated);
    on<CheckDeviceStatus>(
      _onCheckDeviceStatus,
      transformer: throttleDroppable(throttleDuration),
    );

    add(const AllAlarmRequested(RequestMode.initial));
    add(const CriticalAlarmRequested(RequestMode.initial));
    add(const WarningAlarmRequested(RequestMode.initial));
    add(const NormalAlarmRequested(RequestMode.initial));
    add(const NoticeAlarmRequested(RequestMode.initial));
  }

  final User _user;
  final RealTimeAlarmRepository _realTimeAlarmRepository;

  StreamSubscription<int>? _dataStreamSubscription;

  @override
  Future<void> close() {
    _dataStreamSubscription?.cancel();
    return super.close();
  }

  Future<void> _onAlarmPeriodicUpdated(
    AlarmPeriodicUpdated event,
    Emitter<RealTimeAlarmState> emit,
  ) async {
    final dataStream =
        Stream<int>.periodic(const Duration(seconds: 3), (count) => count);

    _dataStreamSubscription?.cancel();
    _dataStreamSubscription = dataStream.listen((count) {
      if (kDebugMode) {
        print('${event.alarmType.toString()} trigger times: $count');
      }

      if (event.alarmType == AlarmType.all) {
        add(const AllAlarmRequested(RequestMode.update));
      } else if (event.alarmType == AlarmType.critical) {
        add(const CriticalAlarmRequested(RequestMode.update));
      } else if (event.alarmType == AlarmType.warning) {
        add(const WarningAlarmRequested(RequestMode.update));
      } else if (event.alarmType == AlarmType.normal) {
        add(const NormalAlarmRequested(RequestMode.update));
      } else if (event.alarmType == AlarmType.notice) {
        add(const NoticeAlarmRequested(RequestMode.update));
      } else {
        add(const AllAlarmRequested(RequestMode.update));
      }
    });
  }

  Future<void> _onAllAlarmRequested(
    AllAlarmRequested event,
    Emitter<RealTimeAlarmState> emit,
  ) async {
    if (event.requestMode == RequestMode.initial) {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        allAlarmsStatus: FormStatus.requestInProgress,
      ));
    }

    List<dynamic> result = await _realTimeAlarmRepository.getRealTimeAlarm(
      user: _user,
      alarmType: AlarmType.all,
    );

    if (result[0]) {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        allAlarmsStatus: FormStatus.requestSuccess,
        allAlarms: result[1],
      ));
    } else {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        allAlarmsStatus: FormStatus.requestFailure,
        allAlarms: [result[1]],
      ));
    }
  }

  Future<void> _onCriticalAlarmRequested(
    CriticalAlarmRequested event,
    Emitter<RealTimeAlarmState> emit,
  ) async {
    if (event.requestMode == RequestMode.initial) {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        criticalAlarmsStatus: FormStatus.requestInProgress,
      ));
    }

    List<dynamic> result = await _realTimeAlarmRepository.getRealTimeAlarm(
      user: _user,
      alarmType: AlarmType.critical,
    );

    if (result[0]) {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        criticalAlarmsStatus: FormStatus.requestSuccess,
        criticalAlarms: result[1],
      ));
    } else {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        criticalAlarmsStatus: FormStatus.requestFailure,
        criticalAlarms: [result[1]],
      ));
    }
  }

  Future<void> _onWarningAlarmRequested(
    WarningAlarmRequested event,
    Emitter<RealTimeAlarmState> emit,
  ) async {
    if (event.requestMode == RequestMode.initial) {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        warningAlarmsStatus: FormStatus.requestInProgress,
      ));
    }

    List<dynamic> result = await _realTimeAlarmRepository.getRealTimeAlarm(
        user: _user, alarmType: AlarmType.warning);

    if (result[0]) {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        warningAlarmsStatus: FormStatus.requestSuccess,
        warningAlarms: result[1],
      ));
    } else {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        warningAlarmsStatus: FormStatus.requestFailure,
        warningAlarms: [result[1]],
      ));
    }
  }

  Future<void> _onNormalAlarmRequested(
    NormalAlarmRequested event,
    Emitter<RealTimeAlarmState> emit,
  ) async {
    if (event.requestMode == RequestMode.initial) {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        normalAlarmsStatus: FormStatus.requestInProgress,
      ));
    }

    List<dynamic> result = await _realTimeAlarmRepository.getRealTimeAlarm(
      user: _user,
      alarmType: AlarmType.normal,
    );

    if (result[0]) {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        normalAlarmsStatus: FormStatus.requestSuccess,
        normalAlarms: result[1],
      ));
    } else {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        normalAlarmsStatus: FormStatus.requestFailure,
        normalAlarms: [result[1]],
      ));
    }
  }

  Future<void> _onNoticeAlarmRequested(
    NoticeAlarmRequested event,
    Emitter<RealTimeAlarmState> emit,
  ) async {
    if (event.requestMode == RequestMode.initial) {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        noticeAlarmsStatus: FormStatus.requestInProgress,
      ));
    }

    List<dynamic> result = await _realTimeAlarmRepository.getRealTimeAlarm(
      user: _user,
      alarmType: AlarmType.notice,
    );

    if (result[0]) {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        noticeAlarmsStatus: FormStatus.requestSuccess,
        noticeAlarms: result[1],
      ));
    } else {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        noticeAlarmsStatus: FormStatus.requestFailure,
        noticeAlarms: [result[1]],
      ));
    }
  }

  Future<void> _onCheckDeviceStatus(
    CheckDeviceStatus event,
    Emitter<RealTimeAlarmState> emit,
  ) async {
    emit(state.copyWith(
      targetDeviceStatus: FormStatus.requestInProgress,
    ));

    List<dynamic> result = await _realTimeAlarmRepository.getDeviceStatus(
      user: _user,
      path: event.path,
    );

    if (result[0]) {
      event.initialPath.addAll(event.path);
      event.pageController.jumpToPage(1);
    } else {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.requestFailure,
        errmsg: result[1],
      ));
    }
  }
}
