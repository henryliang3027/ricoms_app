import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/default_setting.dart';
import 'package:ricoms_app/repository/default_setting_repository.dart';
import 'package:ricoms_app/repository/device_working_cycle_repository.dart';
import 'package:ricoms_app/repository/log_record_setting.dart';
import 'package:ricoms_app/repository/log_record_setting_repository.dart';
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
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);

    add(const DefaultSettingRequested());
  }

  final User _user;
  final DefaultSettingRepository _defaultSettingRepository;
  final DeviceWorkingCycleRepository _deviceWorkingCycleRepository;
  final LogRecordSettingRepository _logRecordSettingRepository;

  String _intToString(var enable) {
    return enable == 1 || enable == '1' ? 'enable' : 'disable';
  }

  int _stringToInt(String enable) {
    return enable == '1' ? 1 : 0;
  }

  void _onDefaultSettingRequested(
    DefaultSettingRequested event,
    Emitter<DefaultSettingState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
      submissionStatus: SubmissionStatus.none,
    ));

    List<dynamic> resultOfGetDefaultSetting =
        await _defaultSettingRepository.getDefaultSetting(user: _user);

    List<dynamic> resultOfGetCurrentDeviceWorkingSetting =
        await _deviceWorkingCycleRepository.getWorkingCycleList(user: _user);

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

  void _onDefaultSettingSaved(
    DefaultSettingSaved event,
    Emitter<DefaultSettingState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestSuccess,
      submissionStatus: SubmissionStatus.submissionInProgress,
      isEditing: false,
    ));

    // for(int i= 0; i < state.defaultSettingItems.length; i++){
    //   if(i == 0) {
    //     DefaultSettingItem defaultSettingItem = state.defaultSettingItems[0];
    //     if(defaultSettingItem.isSelected){

    //     }

    //   }
    //   else {

    //   }
    // }

    // List<dynamic> result =
    //     await _logRecordSettingRepository.(
    //   user: _user,
    //   archivedHistoricalRecordQuanitiy: state.archivedHistoricalRecordQuanitiy,
    //   enableApiLogPreservation: _boolToString(state.enableApiLogPreservation),
    //   apiLogPreservedQuantity: state.apiLogPreservedQuantity,
    //   apiLogPreservedDays: state.apiLogPreservedDays,
    //   enableUserSystemLogPreservation:
    //       _boolToString(state.enableUserSystemLogPreservation),
    //   userSystemLogPreservedQuantity: state.userSystemLogPreservedQuantity,
    //   userSystemLogPreservedDays: state.userSystemLogPreservedDays,
    //   enableDeviceSystemLogPreservation:
    //       _boolToString(state.enableDeviceSystemLogPreservation),
    //   deviceSystemLogPreservedQuantity: state.deviceSystemLogPreservedQuantity,
    //   deviceSystemLogPreservedDays: state.deviceSystemLogPreservedDays,
    // );

    // if (result[0]) {
    //   emit(state.copyWith(
    //     submissionStatus: SubmissionStatus.submissionSuccess,
    //   ));
    // } else {
    //   emit(state.copyWith(
    //     submissionStatus: SubmissionStatus.submissionFailure,
    //     submissionErrorMsg: result[1],
    //   ));
    // }
  }

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

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<DefaultSettingState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.requestSuccess,
      submissionStatus: SubmissionStatus.none,
      isEditing: false,
    ));
  }
}
