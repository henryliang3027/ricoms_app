import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/repository/real_time_alarm_repository/real_time_alarm_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/alarm_sound_config.dart';
import 'package:ricoms_app/utils/common_request.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:ricoms_app/utils/request_interval.dart';
import 'package:stream_transform/stream_transform.dart';

part 'real_time_alarm_event.dart';
part 'real_time_alarm_state.dart';

const throttleDuration = Duration(milliseconds: 1000);
const throttleDurationOfAlarmSoundPlayed = Duration(milliseconds: 3000);

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
    on<AlarmSoundPlayed>(
      _onAlarmSoundPlayed,
      transformer: throttleDroppable(throttleDurationOfAlarmSoundPlayed),
    );
    on<CheckDeviceStatus>(
      _onCheckDeviceStatus,
      transformer: throttleDroppable(throttleDuration),
    );

    // add(const AllAlarmRequested(RequestMode.initial));
    // add(const CriticalAlarmRequested(RequestMode.initial));
    // add(const WarningAlarmRequested(RequestMode.initial));
    // add(const NormalAlarmRequested(RequestMode.initial));
    // add(const NoticeAlarmRequested(RequestMode.initial));

    // 原則上要加 await, 這裡先不加, 因為沒有要馬上播放, 如果要馬上播放會沒有聲音
    _assetsAudioPlayer.open(
      Audio("assets/audios/trap_sound.mp3"),
      autoStart: false,
    );
  }

  final User _user;
  final RealTimeAlarmRepository _realTimeAlarmRepository;
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  StreamSubscription<int>? _dataStreamSubscription;

  @override
  Future<void> close() {
    _dataStreamSubscription?.cancel();
    return super.close();
  }

  void _onAlarmSoundPlayed(
    AlarmSoundPlayed event,
    Emitter<RealTimeAlarmState> emit,
  ) {
    if (AlarmSoundConfig.activateAlarm) {
      if (AlarmSoundConfig.enableTrapAlarmSound[event.latestAlarm.severity]) {
        _assetsAudioPlayer.play();
      }
    }
  }

  Future<void> _onAlarmPeriodicUpdated(
    AlarmPeriodicUpdated event,
    Emitter<RealTimeAlarmState> emit,
  ) async {
    final dataStream = Stream<int>.periodic(
        const Duration(seconds: RequestInterval.realTimeAlarm),
        (count) => count);

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
      List<Alarm> allAlarms = result[1];

      if (state.allAlarms.isNotEmpty) {
        if (state.allAlarms.first != allAlarms.first) {
          add(AlarmSoundPlayed(allAlarms.first));
        }
      }

      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        allAlarmsStatus: FormStatus.requestSuccess,
        allAlarms: allAlarms,
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
      List<Alarm> criticalAlarms = result[1];

      if (state.criticalAlarms.isNotEmpty) {
        if (state.criticalAlarms.first != criticalAlarms.first) {
          add(AlarmSoundPlayed(criticalAlarms.first));
        }
      }

      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        criticalAlarmsStatus: FormStatus.requestSuccess,
        criticalAlarms: criticalAlarms,
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
      List<Alarm> warningAlarms = result[1];

      if (state.warningAlarms.isNotEmpty) {
        if (state.warningAlarms.first != warningAlarms.first) {
          add(AlarmSoundPlayed(warningAlarms.first));
        }
      }

      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        warningAlarmsStatus: FormStatus.requestSuccess,
        warningAlarms: warningAlarms,
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
      List<Alarm> normalAlarms = result[1];

      if (state.normalAlarms.isNotEmpty) {
        if (state.normalAlarms.first != normalAlarms.first) {
          add(AlarmSoundPlayed(normalAlarms.first));
        }
      }

      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        normalAlarmsStatus: FormStatus.requestSuccess,
        normalAlarms: normalAlarms,
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
      List<Alarm> noticeAlarms = result[1];

      if (state.noticeAlarms.isNotEmpty) {
        if (state.noticeAlarms.first != noticeAlarms.first) {
          add(AlarmSoundPlayed(noticeAlarms.first));
        }
      }

      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        noticeAlarmsStatus: FormStatus.requestSuccess,
        noticeAlarms: noticeAlarms,
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

    List<dynamic> result = await getDeviceStatus(
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
