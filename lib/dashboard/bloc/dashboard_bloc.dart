import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/dashboard_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_request.dart';
import 'package:ricoms_app/utils/request_interval.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required User user,
    required DashboardRepository dashboardRepository,
  })  : _user = user,
        _dashboardRepository = dashboardRepository,
        super(const DashboardState()) {
    on<AlarmOneDayStatisticRequested>(_onAlarmOneDayStatisticRequested);
    on<AlarmThreeDaysStatisticRequested>(_onAlarmThreeDaysStatisticRequested);
    on<AlarmOneWeekStatisticRequested>(_onAlarmOneWeekStatisticRequested);
    on<AlarmTwoWeeksStatisticRequested>(_onAlarmTwoWeeksStatisticRequested);
    on<AlarmOneMonthStatisticRequested>(_onAlarmOneMonthStatisticRequested);
    on<AlarmStatisticPeriodicUpdated>(_onAlarmStatisticPeriodicUpdated);
    on<DeviceStatisticRequested>(_onDeviceStatisticRequested);

    add(const DeviceStatisticRequested(RequestMode.initial));
    add(const AlarmOneDayStatisticRequested(RequestMode.initial));
    add(const AlarmThreeDaysStatisticRequested(RequestMode.initial));
    add(const AlarmOneWeekStatisticRequested(RequestMode.initial));
    add(const AlarmTwoWeeksStatisticRequested(RequestMode.initial));
    add(const AlarmOneMonthStatisticRequested(RequestMode.initial));

    final _deviceStatisticDataStream = Stream<int>.periodic(
        const Duration(seconds: RequestInterval.deviceStatistics),
        (count) => count);

    _deviceStatisticDataStreamSubscription =
        _deviceStatisticDataStream.listen((count) {
      // print('_deviceStatisticDataStream trigger times: ${count}');
      add(const DeviceStatisticRequested(RequestMode.update));
    });
  }

  final User _user;
  final DashboardRepository _dashboardRepository;

  StreamSubscription<int>? _alarmStatisticDataStreamSubscription;
  StreamSubscription<int>? _deviceStatisticDataStreamSubscription;

  @override
  Future<void> close() {
    _alarmStatisticDataStreamSubscription?.cancel();
    _deviceStatisticDataStreamSubscription?.cancel();
    return super.close();
  }

  Future<void> _onAlarmStatisticPeriodicUpdated(
    AlarmStatisticPeriodicUpdated event,
    Emitter<DashboardState> emit,
  ) async {
    final alarmStatisticDataStream = Stream<int>.periodic(
        const Duration(seconds: RequestInterval.dashbordAlarmStatistics),
        (count) => count);

    _alarmStatisticDataStreamSubscription?.cancel();
    _alarmStatisticDataStreamSubscription =
        alarmStatisticDataStream.listen((count) {
      // print('alarmStatisticDataStream trigger times: ${count}');

      if (event.type == 1) {
        add(const AlarmOneDayStatisticRequested(RequestMode.update));
      } else if (event.type == 2) {
        add(const AlarmThreeDaysStatisticRequested(RequestMode.update));
      } else if (event.type == 3) {
        add(const AlarmOneWeekStatisticRequested(RequestMode.update));
      } else if (event.type == 4) {
        add(const AlarmTwoWeeksStatisticRequested(RequestMode.update));
      } else if (event.type == 5) {
        add(const AlarmOneMonthStatisticRequested(RequestMode.update));
      } else {
        add(const AlarmOneDayStatisticRequested(RequestMode.update));
      }
    });
  }

  Future<void> _onAlarmOneDayStatisticRequested(
    AlarmOneDayStatisticRequested event,
    Emitter<DashboardState> emit,
  ) async {
    if (event.requestMode == RequestMode.initial) {
      emit(state.copyWith(
        alarmOneDayStatisticsStatus: FormStatus.requestInProgress,
      ));
    }

    List<dynamic> result =
        await _dashboardRepository.getAlarmSeverityStatistics(
      user: _user,
      type: 1,
    );

    if (result[0]) {
      emit(state.copyWith(
        alarmOneDayStatisticsStatus: FormStatus.requestSuccess,
        alarmOneDayStatistics: result[1],
      ));
    } else {
      emit(state.copyWith(
        alarmOneDayStatisticsStatus: FormStatus.requestFailure,
        errmsg: result[1],
      ));
    }
  }

  Future<void> _onAlarmThreeDaysStatisticRequested(
    AlarmThreeDaysStatisticRequested event,
    Emitter<DashboardState> emit,
  ) async {
    if (event.requestMode == RequestMode.initial) {
      emit(state.copyWith(
        alarmThreeDaysStatisticsStatus: FormStatus.requestInProgress,
      ));
    }

    List<dynamic> result =
        await _dashboardRepository.getAlarmSeverityStatistics(
      user: _user,
      type: 2,
    );

    if (result[0]) {
      emit(state.copyWith(
        alarmThreeDaysStatisticsStatus: FormStatus.requestSuccess,
        alarmThreeDaysStatistics: result[1],
      ));
    } else {
      emit(state.copyWith(
        alarmThreeDaysStatisticsStatus: FormStatus.requestFailure,
        errmsg: result[1],
      ));
    }
  }

  Future<void> _onAlarmOneWeekStatisticRequested(
    AlarmOneWeekStatisticRequested event,
    Emitter<DashboardState> emit,
  ) async {
    if (event.requestMode == RequestMode.initial) {
      emit(state.copyWith(
        alarmOneWeekStatisticsStatus: FormStatus.requestInProgress,
      ));
    }

    List<dynamic> result =
        await _dashboardRepository.getAlarmSeverityStatistics(
      user: _user,
      type: 3,
    );

    if (result[0]) {
      emit(state.copyWith(
        alarmOneWeekStatisticsStatus: FormStatus.requestSuccess,
        alarmOneWeekStatistics: result[1],
      ));
    } else {
      emit(state.copyWith(
        alarmOneWeekStatisticsStatus: FormStatus.requestFailure,
        errmsg: result[1],
      ));
    }
  }

  Future<void> _onAlarmTwoWeeksStatisticRequested(
    AlarmTwoWeeksStatisticRequested event,
    Emitter<DashboardState> emit,
  ) async {
    if (event.requestMode == RequestMode.initial) {
      emit(state.copyWith(
        alarmTwoWeeksStatisticsStatus: FormStatus.requestInProgress,
      ));
    }

    List<dynamic> result =
        await _dashboardRepository.getAlarmSeverityStatistics(
      user: _user,
      type: 4,
    );

    if (result[0]) {
      emit(state.copyWith(
        alarmTwoWeeksStatisticsStatus: FormStatus.requestSuccess,
        alarmTwoWeeksStatistics: result[1],
      ));
    } else {
      emit(state.copyWith(
        alarmTwoWeeksStatisticsStatus: FormStatus.requestFailure,
        errmsg: result[1],
      ));
    }
  }

  Future<void> _onAlarmOneMonthStatisticRequested(
    AlarmOneMonthStatisticRequested event,
    Emitter<DashboardState> emit,
  ) async {
    if (event.requestMode == RequestMode.initial) {
      emit(state.copyWith(
        alarmOneMonthStatisticsStatus: FormStatus.requestInProgress,
      ));
    }

    List<dynamic> result =
        await _dashboardRepository.getAlarmSeverityStatistics(
      user: _user,
      type: 5,
    );

    if (result[0]) {
      emit(state.copyWith(
        alarmOneMonthStatisticsStatus: FormStatus.requestSuccess,
        alarmOneMonthStatistics: result[1],
      ));
    } else {
      emit(state.copyWith(
        alarmOneMonthStatisticsStatus: FormStatus.requestFailure,
        errmsg: result[1],
      ));
    }
  }

  Future<void> _onDeviceStatisticRequested(
    DeviceStatisticRequested event,
    Emitter<DashboardState> emit,
  ) async {
    if (event.requestMode == RequestMode.initial) {
      emit(state.copyWith(
        deviceStatisticsStatus: FormStatus.requestInProgress,
      ));
    }

    List<dynamic> result = await _dashboardRepository.getDeviceStatusStatistics(
      user: _user,
    );

    if (result[0]) {
      emit(state.copyWith(
        deviceStatisticsStatus: FormStatus.requestSuccess,
        deviceStatistics: result[1],
      ));
    } else {
      emit(state.copyWith(
        deviceStatisticsStatus: FormStatus.requestFailure,
        errmsg: result[1],
      ));
    }
  }
}
