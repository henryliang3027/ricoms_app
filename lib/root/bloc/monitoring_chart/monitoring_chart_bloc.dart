import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/repository/root_repository/device_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/monitoring_chart_style.dart';

part 'monitoring_chart_event.dart';
part 'monitoring_chart_state.dart';

class MonitoringChartBloc
    extends Bloc<MonitoringChartEvent, MonitoringChartState> {
  MonitoringChartBloc({
    required User user,
    required DeviceRepository deviceRepository,
    required int nodeId,
    required DeviceBlock deviceBlock,
  })  : _user = user,
        _deviceRepository = deviceRepository,
        _nodeId = nodeId,
        _deviceBlock = deviceBlock,
        super(const MonitoringChartState()) {
    on<ParameterRequested>(_onParameterRequested);
    on<StartDateChanged>(_onStartDateChanged);
    on<EndDateChanged>(_onEndDateChanged);
    on<FilterSelectingModeEnabled>(_onFilterSelectingModeEnabled);
    on<FilterSelectingModeDisabled>(_onFilterSelectingModeDisabled);
    on<CheckBoxValueChanged>(_onCheckBoxValueChanged);
    on<AllCheckBoxValueChanged>(_onAllCheckBoxValueChanged);
    on<MultipleYAxisCheckBoxValueChanged>(_onMultipleYAxisCheckBoxValueChanged);
    on<SingleAxisChartDataExported>(_onSingleAxisChartDataExported);
    on<MultipleAxisChartDataExported>(_onMultipleAxisChartDataExported);

    add(const ParameterRequested());
  }

  final User _user;
  final DeviceRepository _deviceRepository;
  final int _nodeId;
  final DeviceBlock _deviceBlock;

  /// 處理 device 參數取得
  Future<void> _onParameterRequested(
    ParameterRequested event,
    Emitter<MonitoringChartState> emit,
  ) async {
    List<List<ItemProperty>> itemPropertiesCollection = [];
    Map<String, CheckBoxValue> checkBoxValues = {};

    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    // 藉由 api 取得 monitoring chart 分頁的 device 參數
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

  /// 處理起始日期的改變
  void _onStartDateChanged(
    StartDateChanged event,
    Emitter<MonitoringChartState> emit,
  ) {
    String formattedStartDate = event.startDate.replaceAll('/', '');
    String formattedEndDate = state.endDate.replaceAll('/', '');

    if (formattedEndDate == '') {
      //if start date and end date are empty string ''
      formattedEndDate = formattedStartDate;
    }

    DateTime startDate = DateTime.parse(formattedStartDate);
    DateTime endDate = DateTime.parse(formattedEndDate);
    DateTime lastate = startDate.add(const Duration(days: 30));

    String displayStartDate =
        DateFormat('yyyy-MM-dd').format(startDate).toString();
    String displayEndDate = DateFormat('yyyy-MM-dd').format(endDate).toString();

    String displayLastDate =
        DateFormat('yyyy-MM-dd').format(lastate).toString();

    //if end date should earlier than start date, then asign start date,
    //otherwise, asign end date
    String validEndDate = endDate.isAfter(startDate)
        ? endDate.isBefore(lastate)
            ? displayEndDate
            : displayLastDate
        : displayStartDate;

    emit(state.copyWith(
      startDate: displayStartDate,
      endDate: validEndDate,
    ));
  }

  /// 處理結束日期的改變
  void _onEndDateChanged(
    EndDateChanged event,
    Emitter<MonitoringChartState> emit,
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

  /// 處理使用者在觀看 monitor chart 的頁面 按下編輯的floating action button 會觸發 filter 模式
  void _onFilterSelectingModeEnabled(
    FilterSelectingModeEnabled event,
    Emitter<MonitoringChartState> emit,
  ) {
    emit(state.copyWith(
      filterSelectingMode: true,
      chartDataExportStatus: FormStatus.none,
    ));
  }

  /// 處理使用者在 fliter 頁面 按下 save button 會 disable filter 模式
  Future<void> _onFilterSelectingModeDisabled(
    FilterSelectingModeDisabled event,
    Emitter<MonitoringChartState> emit,
  ) async {
    Map<String, List<ChartDateValuePair>> chartDateValuePairsMap = {};

    emit(state.copyWith(
      filterSelectingMode: false,
      chartDataStatus: FormStatus.requestInProgress,
    ));

    List<dynamic> result = await _deviceRepository.getDeviceChartDataCollection(
        user: _user,
        startDate: state.startDate,
        endDate: state.endDate,
        deviceId: _nodeId,
        oids: state.selectedCheckBoxValues.keys.toList());

    if (result[0]) {
      chartDateValuePairsMap = result[1];
      emit(state.copyWith(
        chartDateValuePairsMap: chartDateValuePairsMap,
        chartDataStatus: FormStatus.requestSuccess,
      ));
    } else {
      emit(state.copyWith(
        chartDataStatus: FormStatus.requestFailure,
      ));
    }
  }

  /// 處理參數 check box 被勾選或取消勾選
  void _onCheckBoxValueChanged(
    CheckBoxValueChanged event,
    Emitter<MonitoringChartState> emit,
  ) {
    Map<String, CheckBoxValue> selectedCheckBoxValues = {};
    Map<String, CheckBoxValue> checkBoxValues = {};
    bool isSelectAll = false;
    bool isShowMultipleYAxis = false;
    bool isSelectMultipleYAxis = state.isSelectMultipleYAxis;
    int selectCount = 0;

    checkBoxValues.addAll(state.checkBoxValues);
    selectedCheckBoxValues.addAll(state.selectedCheckBoxValues);

    String name = checkBoxValues[event.oid]!.name;
    double? majorH = checkBoxValues[event.oid]!.majorH;
    double? minorH = checkBoxValues[event.oid]!.minorH;
    double? majorL = checkBoxValues[event.oid]!.majorL;
    double? minorL = checkBoxValues[event.oid]!.minorL;

    CheckBoxValue newCheckBoxValue = CheckBoxValue(
      name: name,
      majorH: majorH,
      minorH: minorH,
      majorL: majorL,
      minorL: minorL,
      value: event.value,
    );
    checkBoxValues[event.oid] = newCheckBoxValue;

    if (event.value == true) {
      selectedCheckBoxValues[event.oid] = newCheckBoxValue;
    } else {
      selectedCheckBoxValues.remove(event.oid);
    }

    checkBoxValues.forEach(
      (oid, checkBoxValue) {
        if (checkBoxValue.value == true) {
          selectCount += 1;
        }
      },
    );

    if (selectCount == state.checkBoxValues.length) {
      isSelectAll = true;
    } else if (selectCount > 0) {
      isShowMultipleYAxis = true;
    } else {
      //selectCount == 0
      isSelectMultipleYAxis = false;
    }

    emit(state.copyWith(
      isSelectAll: isSelectAll,
      isShowMultipleYAxis: isShowMultipleYAxis,
      isSelectMultipleYAxis: isSelectMultipleYAxis,
      selectedCheckBoxValues: selectedCheckBoxValues,
      checkBoxValues: checkBoxValues,
    ));
  }

  /// 處理所有參數 check box 被勾選或取消勾選
  void _onAllCheckBoxValueChanged(
    AllCheckBoxValueChanged event,
    Emitter<MonitoringChartState> emit,
  ) {
    Map<String, CheckBoxValue> selectedCheckBoxValues = {};
    Map<String, CheckBoxValue> checkBoxValues = {};
    bool isSelectMultipleYAxis = state.isSelectMultipleYAxis;

    state.checkBoxValues.forEach((oid, checkBoxValue) {
      String name = checkBoxValue.name;
      double? majorH = checkBoxValue.majorH;
      double? minorH = checkBoxValue.minorH;
      double? majorL = checkBoxValue.majorL;
      double? minorL = checkBoxValue.minorL;
      bool value = event.value;

      CheckBoxValue newCheckBoxValue = CheckBoxValue(
        name: name,
        majorH: majorH,
        minorH: minorH,
        majorL: majorL,
        minorL: minorL,
        value: value,
      );

      checkBoxValues[oid] = newCheckBoxValue;

      if (event.value == true) {
        selectedCheckBoxValues[oid] = newCheckBoxValue;
      } else {
        selectedCheckBoxValues.remove(oid);
      }
    });

    if (event.value == false) {
      isSelectMultipleYAxis = false;
    }

    emit(state.copyWith(
      isSelectAll: event.value,
      isShowMultipleYAxis: event.value,
      isSelectMultipleYAxis: isSelectMultipleYAxis,
      selectedCheckBoxValues: selectedCheckBoxValues,
      checkBoxValues: checkBoxValues,
    ));
  }

  /// 處理多軸顯示 check box 被勾選或取消勾選
  void _onMultipleYAxisCheckBoxValueChanged(
    MultipleYAxisCheckBoxValueChanged event,
    Emitter<MonitoringChartState> emit,
  ) {
    emit(state.copyWith(
      isSelectMultipleYAxis: event.value,
    ));
  }

  /// 處理單軸數據匯出
  Future<void> _onSingleAxisChartDataExported(
    SingleAxisChartDataExported event,
    Emitter<MonitoringChartState> emit,
  ) async {
    emit(state.copyWith(
      chartDataExportStatus: FormStatus.requestInProgress,
    ));

    List<dynamic> result = await _deviceRepository.exportSingleAxisChartData(
      nodeName: event.nodeName,
      parameterName: event.parameterName,
      chartDateValuePairs: event.chartDateValuePairs,
    );

    // List<dynamic> result = [true, 'test', 'tset'];

    if (result[0]) {
      emit(state.copyWith(
        chartDataExportStatus: FormStatus.requestSuccess,
        chartDataExportMsg: result[1],
        chartDataExportFilePath: result[2],
      ));
    } else {
      emit(state.copyWith(
        chartDataExportStatus: FormStatus.requestFailure,
        chartDataExportMsg: result[1],
        chartDataExportFilePath: '',
      ));
    }
  }

  /// 處理多軸數據匯出
  Future<void> _onMultipleAxisChartDataExported(
    MultipleAxisChartDataExported event,
    Emitter<MonitoringChartState> emit,
  ) async {
    emit(state.copyWith(
      chartDataExportStatus: FormStatus.requestInProgress,
    ));

    List<dynamic> result = await _deviceRepository.exportMultipleAxisChartData(
      nodeName: event.nodeName,
      checkBoxValues: event.checkBoxValues,
      chartDateValuePairs: event.chartDateValuePairs,
    );

    if (result[0]) {
      emit(state.copyWith(
        chartDataExportStatus: FormStatus.requestSuccess,
        chartDataExportMsg: result[1],
        chartDataExportFilePath: result[2],
      ));
    } else {
      emit(state.copyWith(
        chartDataExportStatus: FormStatus.requestFailure,
        chartDataExportMsg: result[1],
        chartDataExportFilePath: '',
      ));
    }
  }
}
