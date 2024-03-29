part of 'trap_alarm_color_bloc.dart';

class TrapAlarmColorState extends Equatable {
  const TrapAlarmColorState({
    this.status = FormStatus.none,
    this.isEditing = false,
    this.criticalTextColor = 0xffffffff,
    this.criticalBackgroundColor = 0xffdc3545,
    this.warningTextColor = 0xff000000,
    this.warningBackgroundColor = 0xffffc107,
    this.normalTextColor = 0xffffffff,
    this.normalBackgroundColor = 0xff28a745,
    this.noticeTextColor = 0xffffffff,
    this.noticeBackgroundColor = 0xff6c757d,
    this.errmsg = '',
  });

  final FormStatus status;
  final bool isEditing;
  final int criticalTextColor;
  final int criticalBackgroundColor;
  final int warningTextColor;
  final int warningBackgroundColor;
  final int normalTextColor;
  final int normalBackgroundColor;
  final int noticeTextColor;
  final int noticeBackgroundColor;
  final String errmsg;

  TrapAlarmColorState copyWith({
    FormStatus? status,
    bool? isEditing,
    int? criticalTextColor,
    int? criticalBackgroundColor,
    int? warningTextColor,
    int? warningBackgroundColor,
    int? normalTextColor,
    int? normalBackgroundColor,
    int? noticeTextColor,
    int? noticeBackgroundColor,
    String? errmsg,
  }) {
    return TrapAlarmColorState(
      status: status ?? this.status,
      isEditing: isEditing ?? this.isEditing,
      criticalTextColor: criticalTextColor ?? this.criticalTextColor,
      criticalBackgroundColor:
          criticalBackgroundColor ?? this.criticalBackgroundColor,
      warningTextColor: warningTextColor ?? this.warningTextColor,
      warningBackgroundColor:
          warningBackgroundColor ?? this.warningBackgroundColor,
      normalTextColor: normalTextColor ?? this.normalTextColor,
      normalBackgroundColor:
          normalBackgroundColor ?? this.normalBackgroundColor,
      noticeTextColor: noticeTextColor ?? this.noticeTextColor,
      noticeBackgroundColor:
          noticeBackgroundColor ?? this.noticeBackgroundColor,
      errmsg: errmsg ?? this.errmsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        isEditing,
        criticalTextColor,
        criticalBackgroundColor,
        warningTextColor,
        warningBackgroundColor,
        normalTextColor,
        normalBackgroundColor,
        noticeTextColor,
        noticeBackgroundColor,
        errmsg,
      ];
}
