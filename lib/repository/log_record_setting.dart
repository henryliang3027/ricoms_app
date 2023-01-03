import 'package:json_annotation/json_annotation.dart';

part 'log_record_setting.g.dart';

@JsonSerializable()
class LogRecordSetting {
  @JsonKey(name: 'history_max_table_size')
  final String archivedHistoricalRecordQuanitiy;

  @JsonKey(name: 'log_schedule')
  final String enableApiLogPreservation;

  @JsonKey(name: 'log_max_size')
  final String apiLogPreservedQuantity;

  @JsonKey(name: 'log_max_save_days')
  final String apiLogPreservedDays;

  @JsonKey(name: 'device_schedule')
  final String enableUserSystemLogPreservation;

  @JsonKey(name: 'device_max_size')
  final String userSystemLogPreservedQuantity;

  @JsonKey(name: 'device_max_save_days')
  final String userSystemLogPreservedDays;

  @JsonKey(name: 'user_schedule')
  final String enableDeviceSystemLogPreservation;

  @JsonKey(name: 'user_max_size')
  final String deviceSystemLogPreservedQuantity;

  @JsonKey(name: 'user_max_save_days')
  final String deviceSystemLogPreservedDays;

  LogRecordSetting({
    required this.archivedHistoricalRecordQuanitiy,
    required this.enableApiLogPreservation,
    required this.apiLogPreservedQuantity,
    required this.apiLogPreservedDays,
    required this.enableUserSystemLogPreservation,
    required this.userSystemLogPreservedQuantity,
    required this.userSystemLogPreservedDays,
    required this.enableDeviceSystemLogPreservation,
    required this.deviceSystemLogPreservedQuantity,
    required this.deviceSystemLogPreservedDays,
  });

  /// Connect the generated [_$LogRecordSettingFromJson] function to the `fromJson`
  /// factory.
  factory LogRecordSetting.fromJson(Map<String, dynamic> json) =>
      _$LogRecordSettingFromJson(json);

  /// Connect the generated [_$LogRecordSettingToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LogRecordSettingToJson(this);
}
