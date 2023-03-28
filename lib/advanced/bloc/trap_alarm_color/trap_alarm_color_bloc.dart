import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_alarm_color_repository/trap_alarm_color_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/custom_style.dart';

part 'trap_alarm_color_event.dart';
part 'trap_alarm_color_state.dart';

class TrapAlarmColorBloc
    extends Bloc<TrapAlarmColorEvent, TrapAlarmColorState> {
  TrapAlarmColorBloc({
    required User user,
    required TrapAlarmColorRepository trapAlarmColorRepository,
  })  : _user = user,
        _trapAlarmColorRepository = trapAlarmColorRepository,
        super(TrapAlarmColorState(
          criticalBackgroundColor: CustomStyle.severityColor[3]!.value,
          criticalTextColor: CustomStyle.severityFontColor[3]!.value,
          warningBackgroundColor: CustomStyle.severityColor[2]!.value,
          warningTextColor: CustomStyle.severityFontColor[2]!.value,
          normalBackgroundColor: CustomStyle.severityColor[1]!.value,
          normalTextColor: CustomStyle.severityFontColor[1]!.value,
          noticeBackgroundColor: CustomStyle.severityColor[0]!.value,
          noticeTextColor: CustomStyle.severityFontColor[0]!.value,
        )) {
    on<CriticalBackgroundColorChanged>(_onCriticalBackgroundColorChanged);
    on<CriticalTextColorChanged>(_onCriticalTextColorChanged);
    on<WarningBackgroundColorChanged>(_onWarningBackgroundColorChanged);
    on<WarningTextColorChanged>(_onWarningTextColorChanged);
    on<NormalBackgroundColorChanged>(_onNormalBackgroundColorChanged);
    on<NormalTextColorChanged>(_onNormalTextColorChanged);
    on<NoticeBackgroundColorChanged>(_onNoticeBackgroundColorChanged);
    on<NoticeTextColorChanged>(_onNoticeTextColorChanged);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<TrapAlarmColorSaved>(_onTrapAlarmColorSaved);
    on<TrapAlarmColorReseted>(_onTrapAlarmColorReseted);
  }

  final User _user;
  final TrapAlarmColorRepository _trapAlarmColorRepository;

  /// 處理 Critical 背景顏色的更改
  void _onCriticalBackgroundColorChanged(
    CriticalBackgroundColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      criticalBackgroundColor: event.criticalBackgroundColor,
    ));
  }

  /// 處理 Critical 文字顏色的更改
  void _onCriticalTextColorChanged(
    CriticalTextColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      criticalTextColor: event.criticalTextColor,
    ));
  }

  /// 處理 Warning 背景顏色的更改
  void _onWarningBackgroundColorChanged(
    WarningBackgroundColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      warningBackgroundColor: event.warningBackgroundColor,
    ));
  }

  /// 處理 Warning 文字顏色的更改
  void _onWarningTextColorChanged(
    WarningTextColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      warningTextColor: event.warningTextColor,
    ));
  }

  /// 處理 Normal 背景顏色的更改
  void _onNormalBackgroundColorChanged(
    NormalBackgroundColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      normalBackgroundColor: event.normalBackgroundColor,
    ));
  }

  /// 處理 Normal 文字顏色的更改
  void _onNormalTextColorChanged(
    NormalTextColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      normalTextColor: event.normalTextColor,
    ));
  }

  /// 處理 Notice 背景顏色的更改
  void _onNoticeBackgroundColorChanged(
    NoticeBackgroundColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      noticeBackgroundColor: event.noticeBackgroundColor,
    ));
  }

  /// 處理 Notice 文字顏色的更改
  void _onNoticeTextColorChanged(
    NoticeTextColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      noticeTextColor: event.noticeTextColor,
    ));
  }

  /// 處理編輯模式的開啟
  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      isEditing: true,
    ));
  }

  /// 處理編輯模式的關閉, 並恢復目前設定值
  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      isEditing: false,
      criticalBackgroundColor: CustomStyle.severityColor[3]!.value,
      criticalTextColor: CustomStyle.severityFontColor[3]!.value,
      warningBackgroundColor: CustomStyle.severityColor[2]!.value,
      warningTextColor: CustomStyle.severityFontColor[2]!.value,
      normalBackgroundColor: CustomStyle.severityColor[1]!.value,
      normalTextColor: CustomStyle.severityFontColor[1]!.value,
      noticeBackgroundColor: CustomStyle.severityColor[0]!.value,
      noticeTextColor: CustomStyle.severityFontColor[0]!.value,
    ));
  }

  /// 處理顏色設定資料的儲存, 儲存於手機端
  void _onTrapAlarmColorSaved(
    TrapAlarmColorSaved event,
    Emitter<TrapAlarmColorState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    CustomStyle.setSeverityColors([
      state.noticeBackgroundColor,
      state.normalBackgroundColor,
      state.warningBackgroundColor,
      state.criticalBackgroundColor,
      state.noticeTextColor,
      state.normalTextColor,
      state.warningTextColor,
      state.criticalTextColor,
    ]);

    List<dynamic> result = await _trapAlarmColorRepository
        .setTrapAlarmColor(user: _user, severityColors: [
      state.noticeBackgroundColor,
      state.normalBackgroundColor,
      state.warningBackgroundColor,
      state.criticalBackgroundColor,
      state.noticeTextColor,
      state.normalTextColor,
      state.warningTextColor,
      state.criticalTextColor,
    ]);

    if (result[0]) {
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        isEditing: false,
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        isEditing: false,
        errmsg: result[1],
      ));
    }
  }

  /// 恢復原廠顏色設定
  void _onTrapAlarmColorReseted(
    TrapAlarmColorReseted event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      criticalBackgroundColor: 0xffdc3545,
      criticalTextColor: 0xffffffff,
      warningBackgroundColor: 0xffffc107,
      warningTextColor: 0xff000000,
      normalBackgroundColor: 0xff28a745,
      normalTextColor: 0xffffffff,
      noticeBackgroundColor: 0xff6c757d,
      noticeTextColor: 0xffffffff,
    ));
  }
}
