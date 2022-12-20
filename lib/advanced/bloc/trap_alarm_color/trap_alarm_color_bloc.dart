import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/trap_alarm_color_repository.dart';
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
    on<TrapAlarmColorSaved>(_onTrapAlarmColorSaved);
    on<TrapAlarmColorReseted>(_onTrapAlarmColorReseted);
  }

  final User _user;
  final TrapAlarmColorRepository _trapAlarmColorRepository;

  void _onCriticalBackgroundColorChanged(
    CriticalBackgroundColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      criticalBackgroundColor: event.criticalBackgroundColor,
    ));
  }

  void _onCriticalTextColorChanged(
    CriticalTextColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      criticalTextColor: event.criticalTextColor,
    ));
  }

  void _onWarningBackgroundColorChanged(
    WarningBackgroundColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      warningBackgroundColor: event.warningBackgroundColor,
    ));
  }

  void _onWarningTextColorChanged(
    WarningTextColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      warningTextColor: event.warningTextColor,
    ));
  }

  void _onNormalBackgroundColorChanged(
    NormalBackgroundColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      normalBackgroundColor: event.normalBackgroundColor,
    ));
  }

  void _onNormalTextColorChanged(
    NormalTextColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      normalTextColor: event.normalTextColor,
    ));
  }

  void _onNoticeBackgroundColorChanged(
    NoticeBackgroundColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      noticeBackgroundColor: event.noticeBackgroundColor,
    ));
  }

  void _onNoticeTextColorChanged(
    NoticeTextColorChanged event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.none,
      noticeTextColor: event.noticeTextColor,
    ));
  }

  void _onTrapAlarmColorSaved(
    TrapAlarmColorSaved event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    CustomStyle.severityColor[3] = Color(state.criticalBackgroundColor);
    CustomStyle.severityFontColor[3] = Color(state.criticalTextColor);
    CustomStyle.severityColor[2] = Color(state.warningBackgroundColor);
    CustomStyle.severityFontColor[2] = Color(state.warningTextColor);
    CustomStyle.severityColor[1] = Color(state.normalBackgroundColor);
    CustomStyle.severityFontColor[1] = Color(state.normalTextColor);
    CustomStyle.severityColor[0] = Color(state.noticeBackgroundColor);
    CustomStyle.severityFontColor[0] = Color(state.noticeTextColor);

    CustomStyle.statusColor[3] = Color(state.criticalBackgroundColor);
    CustomStyle.statusColor[2] = Color(state.warningBackgroundColor);

    emit(state.copyWith(
      status: FormStatus.requestSuccess,
    ));
  }

  void _onTrapAlarmColorReseted(
    TrapAlarmColorReseted event,
    Emitter<TrapAlarmColorState> emit,
  ) {
    emit(state.copyWith(
      criticalBackgroundColor: 0xffdc3545,
      criticalTextColor: 0xffffffff,
      warningBackgroundColor: 0xffffc107,
      warningTextColor: 0xff000000,
      normalBackgroundColor: 0xff28a745,
      normalTextColor: 0xffffffff,
      noticeBackgroundColor: 0xff6c757d,
      noticeTextColor: 0xffffffff,
    ));

    // CustomStyle.severityColor[3] = Color(0xffdc3545);
    // CustomStyle.severityFontColor[3] = Color(0xffffffff);
    // CustomStyle.severityColor[2] = Color(0xffffc107);
    // CustomStyle.severityFontColor[2] = Color(0xff000000);
    // CustomStyle.severityColor[1] = Color(0xff28a745);
    // CustomStyle.severityFontColor[1] = Color(0xffffffff);
    // CustomStyle.severityColor[0] = Color(0xff6c757d);
    // CustomStyle.severityFontColor[0] = Color(0xffffffff);

    // CustomStyle.statusColor[3] = Color(0xffdc3545);
    // CustomStyle.statusColor[2] = Color(0xffffc107);
  }
}
