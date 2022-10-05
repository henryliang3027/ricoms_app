import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  ChartBloc({
    required int index,
    required User user,
    required DeviceRepository deviceRepository,
    required String startDate,
    required String endDate,
    required int nodeId,
    required String oid,
  })  : _index = index,
        _user = user,
        _deviceRepository = deviceRepository,
        _startDate = startDate,
        _endDate = endDate,
        _nodeId = nodeId,
        _oid = oid,
        super(const ChartState()) {
    on<ChartDataRequested>(_onChartDataRequested);

    add(const ChartDataRequested());
  }

  final int _index;
  final User _user;
  final DeviceRepository _deviceRepository;
  final String _startDate;
  final String _endDate;
  final int _nodeId;
  final String _oid;

  Future<void> _onChartDataRequested(
    ChartDataRequested event,
    Emitter<ChartState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    await Future.delayed(Duration(seconds: _index));

    List<dynamic> result = await _deviceRepository.getDeviceChartData(
      user: _user,
      startDate: _startDate,
      endDate: _endDate,
      deviceId: _nodeId,
      oid: _oid,
    );

    if (result[0]) {
      List<ChartDateValuePair> chartDateValuePairs = result[1];

      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        chartDateValuePairs: chartDateValuePairs,
      ));
    } else {
      String errMsg = result[1];
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        errMsg: errMsg,
      ));
    }
  }
}
