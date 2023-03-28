import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/advanced_repository/default_setting_repository/default_setting.dart';
import 'package:ricoms_app/repository/advanced_repository/default_setting_repository/default_setting_repository.dart';
import 'package:ricoms_app/repository/advanced_repository/log_record_setting_repository/log_record_setting.dart';
import 'package:ricoms_app/repository/advanced_repository/log_record_setting_repository/log_record_setting_repository.dart';
import 'package:ricoms_app/repository/advanced_repository/device_working_cycle_repository/device_working_cycle_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'default_setting_event.dart';
part 'default_setting_state.dart';

class DefaultSettingBloc
    extends Bloc<DefaultSettingEvent, DefaultSettingState> {
  DefaultSettingBloc({
    required User user,
    required DefaultSettingRepository defaultSettingRepository,
    required DeviceWorkingCycleRepository deviceWorkingCycleRepository,
    required LogRecordSettingRepository logRecordSettingRepository,
  })  : _user = user,
        _defaultSettingRepository = defaultSettingRepository,
        _deviceWorkingCycleRepository = deviceWorkingCycleRepository,
        _logRecordSettingRepository = logRecordSettingRepository,
        super(const DefaultSettingState()) {
    on<DefaultSettingRequested>(_onDefaultSettingRequested);
    on<DefaultSettingItemToggled>(_onDefaultSettingItemToggled);
    on<AllItemsSelected>(_onAllItemsSelected);
    on<DefaultSettingSaved>(_onDefaultSettingSaved);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);

    add(const DefaultSettingRequested());
  }

  final User _user;
  final DefaultSettingRepository _defaultSettingRepository;
  final DeviceWorkingCycleRepository _deviceWorkingCycleRepository;
  final LogRecordSettingRepository _logRecordSettingRepository;

  /// 數字轉為字串, 1:enable, 0:disable
  String _intToString(var enable) {
    return enable == 1 || enable == '1' ? 'enable' : 'disable';
  }

  /// 字串轉為數字, enable:1, disable:0
  String _boolStringToIntString(String enable) {
    return enable == 'enable' ? '1' : '0';
  }

  /// 處理原廠預設值與目前設定值的取得
  void _onDefaultSettingRequested(
    DefaultSettingRequested event,
    Emitter<DefaultSettingState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
      submissionStatus: SubmissionStatus.none,
    ));

    // 取得原廠預設值
    List<dynamic> resultOfGetDefaultSetting =
        await _defaultSettingRepository.getDefaultSetting(user: _user);

    // 取得目前裝置輪詢週期
    List<dynamic> resultOfGetCurrentDeviceWorkingSetting =
        await _deviceWorkingCycleRepository.getWorkingCycleList(user: _user);

    // 取得目前設定值, 歷史紀錄封存筆數設定值, API log 紀錄設定值, 使用者系統記錄設定值, 裝置系統記錄設定值
    // api resopnse example:
    // "history_max_table_size": "100000",
    // "log_schedule": "1",
    // "log_max_size": "100000",
    // "log_max_save_days": "10",
    // "device_schedule": "1",
    // "device_max_size": "90000",
    // "device_max_save_days": "180",
    // "user_schedule": "1",
    // "user_max_size": "9000",
    // "user_max_save_days": "180"
    List<dynamic> resultOfGetCurrentLogRecordSetting =
        await _logRecordSettingRepository.getLogRecordSetting(user: _user);

    if (resultOfGetDefaultSetting[0] &&
        resultOfGetCurrentDeviceWorkingSetting[0] &&
        resultOfGetCurrentLogRecordSetting[0]) {
      // default setting value
      DefaultSetting defaultSetting = resultOfGetDefaultSetting[1];

      List<DeviceWorkingCycle> deviceWorkingCycleList =
          resultOfGetCurrentDeviceWorkingSetting[1];

      // current device working cycle index
      String currentIndex = resultOfGetCurrentDeviceWorkingSetting[2];

      DeviceWorkingCycle defaultDeviceWorkingCycle =
          deviceWorkingCycleList.firstWhere(
        (deviceWorkingCycle) =>
            deviceWorkingCycle.index ==
            defaultSetting.deviceWorkingCycleIndex.toString(),
      );

      DeviceWorkingCycle currentDeviceWorkingCycle =
          deviceWorkingCycleList.firstWhere(
        (deviceWorkingCycle) => deviceWorkingCycle.index == currentIndex,
      );

      // current log record setting value
      LogRecordSetting logRecordSetting = resultOfGetCurrentLogRecordSetting[1];

      List<DefaultSettingItem> defaultSettingItems = [
        DefaultSettingItem(
          defaultValue: defaultDeviceWorkingCycle.name,
          currentValue: currentDeviceWorkingCycle.name,
          defaultIdx: defaultDeviceWorkingCycle.index,
          currentIdx: currentDeviceWorkingCycle.index,
        ),
        DefaultSettingItem(
          defaultValue:
              defaultSetting.archivedHistoricalRecordQuanitiy.toString(),
          currentValue: logRecordSetting.archivedHistoricalRecordQuanitiy,
        ),
        DefaultSettingItem(
          defaultValue: _intToString(defaultSetting.enableApiLogPreservation),
          currentValue: _intToString(logRecordSetting.enableApiLogPreservation),
        ),
        DefaultSettingItem(
          defaultValue: defaultSetting.apiLogPreservedQuantity.toString(),
          currentValue: logRecordSetting.apiLogPreservedQuantity,
        ),
        DefaultSettingItem(
          defaultValue: defaultSetting.apiLogPreservedDays.toString(),
          currentValue: logRecordSetting.apiLogPreservedDays,
        ),
        DefaultSettingItem(
          defaultValue:
              _intToString(defaultSetting.enableUserSystemLogPreservation),
          currentValue:
              _intToString(logRecordSetting.enableUserSystemLogPreservation),
        ),
        DefaultSettingItem(
          defaultValue:
              defaultSetting.userSystemLogPreservedQuantity.toString(),
          currentValue: logRecordSetting.userSystemLogPreservedQuantity,
        ),
        DefaultSettingItem(
          defaultValue: defaultSetting.userSystemLogPreservedDays.toString(),
          currentValue: logRecordSetting.userSystemLogPreservedDays,
        ),
        DefaultSettingItem(
          defaultValue:
              _intToString(defaultSetting.enableDeviceSystemLogPreservation),
          currentValue:
              _intToString(logRecordSetting.enableDeviceSystemLogPreservation),
        ),
        DefaultSettingItem(
          defaultValue:
              defaultSetting.deviceSystemLogPreservedQuantity.toString(),
          currentValue: logRecordSetting.deviceSystemLogPreservedQuantity,
        ),
        DefaultSettingItem(
          defaultValue: defaultSetting.deviceSystemLogPreservedDays.toString(),
          currentValue: logRecordSetting.deviceSystemLogPreservedDays,
        ),
      ];

      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.none,
        defaultSettingItems: defaultSettingItems,
        isEditing: false,
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        submissionStatus: SubmissionStatus.none,
        isEditing: false,
        requestErrorMsg: resultOfGetDefaultSetting[1],
      ));
    }
  }

  /// 處理設定項目的選取
  void _onDefaultSettingItemToggled(
    DefaultSettingItemToggled event,
    Emitter<DefaultSettingState> emit,
  ) {
    List<DefaultSettingItem> defaultSettingItems = [];
    defaultSettingItems.addAll(state.defaultSettingItems);

    DefaultSettingItem defaultSettingItem = DefaultSettingItem(
      defaultValue: defaultSettingItems[event.index].defaultValue,
      currentValue: defaultSettingItems[event.index].currentValue,
      defaultIdx: defaultSettingItems[event.index].defaultIdx,
      currentIdx: defaultSettingItems[event.index].currentIdx,
      isSelected: !defaultSettingItems[event.index].isSelected,
    );

    defaultSettingItems[event.index] = defaultSettingItem;

    emit(state.copyWith(
      status: FormStatus.requestSuccess,
      submissionStatus: SubmissionStatus.none,
      defaultSettingItems: defaultSettingItems,
    ));
  }

  /// 處理設定項目的全部選取
  void _onAllItemsSelected(
    AllItemsSelected event,
    Emitter<DefaultSettingState> emit,
  ) {
    List<DefaultSettingItem> newDefaultSettingItems = [];

    for (DefaultSettingItem defaultSettingItem in state.defaultSettingItems) {
      DefaultSettingItem newDfaultSettingItem = DefaultSettingItem(
        defaultValue: defaultSettingItem.defaultValue,
        currentValue: defaultSettingItem.currentValue,
        defaultIdx: defaultSettingItem.defaultIdx,
        currentIdx: defaultSettingItem.currentIdx,
        isSelected: true,
      );

      newDefaultSettingItems.add(newDfaultSettingItem);
    }

    emit(state.copyWith(
      status: FormStatus.requestSuccess,
      submissionStatus: SubmissionStatus.none,
      defaultSettingItems: newDefaultSettingItems,
      isEditing: true,
    ));
  }

  /// 處理被選取的設定項目的更新, 向後端更新設定值
  void _onDefaultSettingSaved(
    DefaultSettingSaved event,
    Emitter<DefaultSettingState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestSuccess,
      submissionStatus: SubmissionStatus.submissionInProgress,
      isEditing: false,
    ));

    bool resetLogRecord = false;
    bool resetWorkingCycle = false;
    bool setWorkingCycleSuccessful = false;
    bool setLogRecordSuccessful = false;

    for (int i = 0; i < state.defaultSettingItems.length; i++) {
      if (i == 0) {
        if (state.defaultSettingItems[0].isSelected) {
          resetWorkingCycle = true;
        }
      } else {
        if (state.defaultSettingItems[i].isSelected) {
          resetLogRecord = true;
          break;
        }
      }
    }

    if (resetWorkingCycle == false && resetLogRecord == false) {
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.submissionSuccess,
        isEditing: false,
      ));
    } else if (resetWorkingCycle == true && resetLogRecord == false) {
      setWorkingCycleSuccessful = await _updateDeviceWorkingCycle();

      if (setWorkingCycleSuccessful) {
        emit(state.copyWith(
          status: FormStatus.requestSuccess,
          submissionStatus: SubmissionStatus.submissionSuccess,
          isEditing: false,
        ));
      } else {
        emit(state.copyWith(
          status: FormStatus.requestSuccess,
          submissionStatus: SubmissionStatus.submissionFailure,
          isEditing: false,
        ));
      }
    } else if (resetWorkingCycle == false && resetLogRecord == true) {
      setLogRecordSuccessful = await _updateLogRecordSetting();

      if (setLogRecordSuccessful) {
        emit(state.copyWith(
          status: FormStatus.requestSuccess,
          submissionStatus: SubmissionStatus.submissionSuccess,
          isEditing: false,
        ));
      } else {
        emit(state.copyWith(
          status: FormStatus.requestSuccess,
          submissionStatus: SubmissionStatus.submissionFailure,
          isEditing: false,
        ));
      }
    } else {
      setWorkingCycleSuccessful = await _updateDeviceWorkingCycle();
      setLogRecordSuccessful = await _updateLogRecordSetting();

      if (setWorkingCycleSuccessful && setLogRecordSuccessful) {
        emit(state.copyWith(
          status: FormStatus.requestSuccess,
          submissionStatus: SubmissionStatus.submissionSuccess,
          isEditing: false,
        ));
      } else {
        emit(state.copyWith(
          status: FormStatus.requestSuccess,
          submissionStatus: SubmissionStatus.submissionFailure,
          isEditing: false,
        ));
      }
    }
  }

  /// 更新裝置輪詢週期設定值
  Future<bool> _updateDeviceWorkingCycle() async {
    List<dynamic> resultOfSetWorkingCycle =
        await _deviceWorkingCycleRepository.setWorkingCycle(
      user: _user,
      index: state.defaultSettingItems[0].defaultIdx,
    );

    return resultOfSetWorkingCycle[0];
  }

  /// 更新歷史紀錄封存筆數設定值, API log 紀錄設定值, 使用者系統記錄設定值, 裝置系統記錄設定值
  Future<bool> _updateLogRecordSetting() async {
    LogRecordSetting logRecordSetting = LogRecordSetting(
      archivedHistoricalRecordQuanitiy: state.defaultSettingItems[1].isSelected
          ? state.defaultSettingItems[1].defaultValue
          : state.defaultSettingItems[1].currentValue,
      enableApiLogPreservation: state.defaultSettingItems[2].isSelected
          ? _boolStringToIntString(state.defaultSettingItems[2].defaultValue)
          : _boolStringToIntString(state.defaultSettingItems[2].currentValue),
      apiLogPreservedQuantity: state.defaultSettingItems[3].isSelected
          ? state.defaultSettingItems[3].defaultValue
          : state.defaultSettingItems[3].currentValue,
      apiLogPreservedDays: state.defaultSettingItems[4].isSelected
          ? state.defaultSettingItems[4].defaultValue
          : state.defaultSettingItems[4].currentValue,
      enableUserSystemLogPreservation: state.defaultSettingItems[5].isSelected
          ? _boolStringToIntString(state.defaultSettingItems[5].defaultValue)
          : _boolStringToIntString(state.defaultSettingItems[5].currentValue),
      userSystemLogPreservedQuantity: state.defaultSettingItems[6].isSelected
          ? state.defaultSettingItems[6].defaultValue
          : state.defaultSettingItems[6].currentValue,
      userSystemLogPreservedDays: state.defaultSettingItems[7].isSelected
          ? state.defaultSettingItems[7].defaultValue
          : state.defaultSettingItems[7].currentValue,
      enableDeviceSystemLogPreservation: state.defaultSettingItems[8].isSelected
          ? _boolStringToIntString(state.defaultSettingItems[8].defaultValue)
          : _boolStringToIntString(state.defaultSettingItems[8].currentValue),
      deviceSystemLogPreservedQuantity: state.defaultSettingItems[9].isSelected
          ? state.defaultSettingItems[9].defaultValue
          : state.defaultSettingItems[9].currentValue,
      deviceSystemLogPreservedDays: state.defaultSettingItems[10].isSelected
          ? state.defaultSettingItems[10].defaultValue
          : state.defaultSettingItems[10].currentValue,
    );

    List<dynamic> resultOfSetLogRecord =
        await _logRecordSettingRepository.setLogRecordSetting(
      user: _user,
      logRecordSetting: logRecordSetting,
    );
    return resultOfSetLogRecord[0];
  }

  /// 處理編輯模式的開啟
  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<DefaultSettingState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.requestSuccess,
      submissionStatus: SubmissionStatus.none,
      isEditing: true,
    ));
  }

  /// 處理編輯模式的關閉
  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<DefaultSettingState> emit,
  ) {
    List<DefaultSettingItem> newDefaultSettingItems = [];

    for (DefaultSettingItem defaultSettingItem in state.defaultSettingItems) {
      DefaultSettingItem newDefaultSettingItem = DefaultSettingItem(
        defaultValue: defaultSettingItem.defaultValue,
        currentValue: defaultSettingItem.currentValue,
        defaultIdx: defaultSettingItem.defaultIdx,
        currentIdx: defaultSettingItem.currentIdx,
        isSelected: false,
      );

      newDefaultSettingItems.add(newDefaultSettingItem);
    }

    emit(state.copyWith(
      status: FormStatus.requestSuccess,
      submissionStatus: SubmissionStatus.none,
      defaultSettingItems: newDefaultSettingItems,
      isEditing: false,
    ));
  }
}
