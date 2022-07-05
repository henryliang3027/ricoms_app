import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/dashboard_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_request.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required User user,
    required DashboardRepository dashboardRepository,
  })  : _user = user,
        _dashboardRepository = dashboardRepository,
        super(const DashboardState()) {
    on<AlarmStatisticRequested>(_onAlarmStatisticRequested);
    on<DeviceStatisticRequested>(_onDeviceStatisticRequested);
    add(const DeviceStatisticRequested(RequestMode.initial));

    final _deviceStatisticDataStream =
        Stream<int>.periodic(const Duration(seconds: 3), (count) => count);

    _deviceStatisticDataStreamSubscription =
        _deviceStatisticDataStream.listen((count) {
      print('_deviceStatisticDataStream trigger times: ${count}');
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

  Future<void> _onAlarmStatisticRequested(
    AlarmStatisticRequested event,
    Emitter<DashboardState> emit,
  ) async {
    if (event.requestMode == RequestMode.initial) {
      emit(state.copyWith(
        alarmStatisticsStatus: FormStatus.requestInProgress,
      ));
    }

    List<dynamic> result =
        await _dashboardRepository.getAlarmSeverityStatistics(
      user: _user,
      type: event.type,
    );

    if (result[0]) {
      emit(state.copyWith(
        alarmStatisticsStatus: FormStatus.requestSuccess,
        alarmStatistics: result[1],
      ));
    } else {
      emit(state.copyWith(
        alarmStatisticsStatus: FormStatus.requestFailure,
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
