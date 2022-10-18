import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/monitoring_chart_style.dart';

part 'multiple_axis_chart_event.dart';
part 'multiple_axis_chart_state.dart';

class MultipleAxisChartBloc
    extends Bloc<MultipleAxisChartEvent, MultipleAxisChartState> {
  MultipleAxisChartBloc({
    required int index,
    required User user,
    required DeviceRepository deviceRepository,
    required String startDate,
    required String endDate,
    required int nodeId,
    required Map<String, CheckBoxValue> selectedCheckBoxValues,
  })  : _index = index,
        _user = user,
        _deviceRepository = deviceRepository,
        _startDate = startDate,
        _endDate = endDate,
        _nodeId = nodeId,
        _selectedCheckBoxValues = selectedCheckBoxValues,
        super(const MultipleAxisChartState()) {
    on<ChartDataRequested>(_onChartDataRequested);

    add(const ChartDataRequested());
  }

  final int _index;
  final User _user;
  final DeviceRepository _deviceRepository;
  final String _startDate;
  final String _endDate;
  final int _nodeId;
  final Map<String, CheckBoxValue> _selectedCheckBoxValues;

  Future<void> _onChartDataRequested(
    ChartDataRequested event,
    Emitter<MultipleAxisChartState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    await Future.delayed(Duration(seconds: _index));

    List<dynamic> result = await _deviceRepository.getMultipleDeviceChartData(
      user: _user,
      startDate: _startDate,
      endDate: _endDate,
      deviceId: _nodeId,
      oids: _selectedCheckBoxValues.keys.toList(),
    );

    if (result[0]) {
      Map<String, List<ChartDateValuePair>> chartDateValues = result[1];

      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        chartDateValues: chartDateValues,
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
