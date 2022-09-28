import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'chart_filter_event.dart';
part 'chart_filter_state.dart';

class ChartFilterBloc extends Bloc<ChartFilterEvent, ChartFilterState> {
  ChartFilterBloc({
    required User user,
    required DeviceRepository deviceRepository,
    required int nodeId,
    required DeviceBlock deviceBlock,
  })  : _user = user,
        _deviceRepository = deviceRepository,
        _nodeId = nodeId,
        _deviceBlock = deviceBlock,
        super(const ChartFilterState()) {
    on<ThresholdDataRequested>(_onThresholdDataRequested);
    on<StartDateChanged>(_onStartDateChanged);
    on<EndDateChanged>(_onEndDateChanged);
    on<FilterSelectingModeChanged>(_onFilterSelectingModeChanged);

    add(const ThresholdDataRequested());
  }

  final User _user;
  final DeviceRepository _deviceRepository;
  final int _nodeId;
  final DeviceBlock _deviceBlock;

  Future<void> _onThresholdDataRequested(
    ThresholdDataRequested event,
    Emitter<ChartFilterState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    dynamic data = await _deviceRepository.getDevicePage(
      user: _user,
      nodeId: _nodeId,
      pageId: _deviceBlock.id,
    );

    if (data is List) {
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        data: data,
        startDate: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        endDate: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        data: [],
        requestErrorMsg: data,
      ));
    }
  }

  void _onStartDateChanged(
    StartDateChanged event,
    Emitter<ChartFilterState> emit,
  ) {
    String formattedStartDate = event.startDate.replaceAll('/', '');
    String formattedEndDate = state.endDate.replaceAll('/', '');

    if (formattedEndDate == '') {
      //if start date and end date are empty string ''
      formattedEndDate = formattedStartDate;
    }

    DateTime startDate = DateTime.parse(formattedStartDate);
    DateTime endDate = DateTime.parse(formattedEndDate);

    String displayStartDate =
        DateFormat('yyyy-MM-dd').format(startDate).toString();
    String displayEndDate = DateFormat('yyyy-MM-dd').format(endDate).toString();

    //if end date should earlier than start date, then asign start date,
    //otherwise, asign end date
    String validEndDate =
        endDate.isAfter(startDate) ? displayEndDate : displayStartDate;
    String date = '$displayStartDate - $validEndDate';

    emit(state.copyWith(
      startDate: displayStartDate,
      endDate: validEndDate,
    ));
  }

  void _onEndDateChanged(
    EndDateChanged event,
    Emitter<ChartFilterState> emit,
  ) {
    String startDate = state.startDate;
    String endDate = event.endDate;

    if (startDate == '') {
      startDate = endDate;
    }

    emit(state.copyWith(
      startDate: startDate,
      endDate: endDate,
    ));
  }

  void _onFilterSelectingModeChanged(
    FilterSelectingModeChanged event,
    Emitter<ChartFilterState> emit,
  ) {
    emit(state.copyWith(
      filterSelectingMode: !state.filterSelectingMode,
    ));
  }
}
