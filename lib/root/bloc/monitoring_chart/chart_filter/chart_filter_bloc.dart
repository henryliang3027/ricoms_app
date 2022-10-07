import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/view/monitoring_chart_style.dart';

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
    on<FilterSelectingModeEnabled>(_onFilterSelectingModeEnabled);
    on<FilterSelectingModeDisabled>(_onFilterSelectingModeDisabled);
    on<CheckBoxValueChanged>(_onCheckBoxValueChanged);

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
    List<List<ItemProperty>> itemPropertiesCollection = [];
    Map<String, CheckBoxValue> checkBoxValues = {};

    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    dynamic data = await _deviceRepository.getDevicePage(
      user: _user,
      nodeId: _nodeId,
      pageId: _deviceBlock.id,
    );

    if (data is List) {
      for (List item in data) {
        List<ItemProperty> itemProperties = [];
        for (var e in item) {
          MonitoringChartStyle.getChartFilterData(
            e: e,
            itemProperties: itemProperties,
            checkBoxValues: checkBoxValues,
          );
        }
        itemPropertiesCollection.add(itemProperties);
      }

      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        itemPropertiesCollection: itemPropertiesCollection,
        checkBoxValues: checkBoxValues,
        startDate: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        endDate: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
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

  void _onFilterSelectingModeEnabled(
    FilterSelectingModeEnabled event,
    Emitter<ChartFilterState> emit,
  ) {
    emit(state.copyWith(
      filterSelectingMode: true,
      selectedCheckBoxValues: [],
    ));
  }

  void _onFilterSelectingModeDisabled(
    FilterSelectingModeDisabled event,
    Emitter<ChartFilterState> emit,
  ) {
    List<CheckBoxValue> selectedCheckBoxValues = [];

    state.checkBoxValues.forEach((oid, checkBoxValue) {
      if (checkBoxValue.value == true) {
        selectedCheckBoxValues.add(checkBoxValue);
      }
    });

    emit(state.copyWith(
      filterSelectingMode: false,
      selectedCheckBoxValues: selectedCheckBoxValues,
    ));
  }

  void _onCheckBoxValueChanged(
    CheckBoxValueChanged event,
    Emitter<ChartFilterState> emit,
  ) {
    Map<String, CheckBoxValue> checkBoxValues = {};

    checkBoxValues.addAll(state.checkBoxValues);

    String oid = checkBoxValues[event.oid]!.oid;
    String name = checkBoxValues[event.oid]!.name;
    double? majorH = checkBoxValues[event.oid]!.majorH;
    double? minorH = checkBoxValues[event.oid]!.minorH;
    double? majorL = checkBoxValues[event.oid]!.majorL;
    double? minorL = checkBoxValues[event.oid]!.minorL;

    CheckBoxValue newCheckBoxValue = CheckBoxValue(
      oid: oid,
      name: name,
      majorH: majorH,
      minorH: minorH,
      majorL: majorL,
      minorL: minorL,
      value: event.value,
    );
    checkBoxValues[event.oid] = newCheckBoxValue;

    emit(state.copyWith(
      checkBoxValues: checkBoxValues,
    ));
  }
}
