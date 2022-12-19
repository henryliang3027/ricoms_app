part of 'trap_alarm_color_bloc.dart';

abstract class TrapAlarmColorEvent extends Equatable {
  const TrapAlarmColorEvent();
}

class CriticalTextColorChanged extends TrapAlarmColorEvent {
  const CriticalTextColorChanged(this.criticalTextColor);

  final int criticalTextColor;

  @override
  List<Object?> get props => [criticalTextColor];
}

class CriticalBackgroundColorChanged extends TrapAlarmColorEvent {
  const CriticalBackgroundColorChanged(this.criticalBackgroundColor);

  final int criticalBackgroundColor;

  @override
  List<Object?> get props => [criticalBackgroundColor];
}

class WarningTextColorChanged extends TrapAlarmColorEvent {
  const WarningTextColorChanged(this.warningTextColor);

  final int warningTextColor;

  @override
  List<Object?> get props => [warningTextColor];
}

class WarningBackgroundColorChanged extends TrapAlarmColorEvent {
  const WarningBackgroundColorChanged(this.warningBackgroundColor);

  final int warningBackgroundColor;

  @override
  List<Object?> get props => [warningBackgroundColor];
}

class NormalTextColorChanged extends TrapAlarmColorEvent {
  const NormalTextColorChanged(this.normalTextColor);

  final int normalTextColor;

  @override
  List<Object?> get props => [normalTextColor];
}

class NormalBackgroundColorChanged extends TrapAlarmColorEvent {
  const NormalBackgroundColorChanged(this.normalBackgroundColor);

  final int normalBackgroundColor;

  @override
  List<Object?> get props => [normalBackgroundColor];
}

class NoticeTextColorChanged extends TrapAlarmColorEvent {
  const NoticeTextColorChanged(this.noticeTextColor);

  final int noticeTextColor;

  @override
  List<Object?> get props => [noticeTextColor];
}

class NoticeBackgroundColorChanged extends TrapAlarmColorEvent {
  const NoticeBackgroundColorChanged(this.noticeBackgroundColor);

  final int noticeBackgroundColor;

  @override
  List<Object?> get props => [noticeBackgroundColor];
}

class TrapAlarmColorSaved extends TrapAlarmColorEvent {
  const TrapAlarmColorSaved();

  @override
  List<Object?> get props => [];
}

class TrapAlarmColorRestored extends TrapAlarmColorEvent {
  const TrapAlarmColorRestored();

  @override
  List<Object?> get props => [];
}
