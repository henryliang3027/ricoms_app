import 'package:json_annotation/json_annotation.dart';

part 'default_setting.g.dart';

/// 解析原廠設定資料 key-value,
/// fromJson : 從 json data 轉換為 DefaultSetting 的資料結構
/// toJson : 從 DefaultSetting 轉換為 json data
@JsonSerializable()
class DefaultSetting {
  @JsonKey(name: 'rotation_index')
  final int deviceWorkingCycleIndex;

  @JsonKey(name: 'device_trap_history_limit')
  final int archivedHistoricalRecordQuanitiy;

  @JsonKey(name: 'api_log_enable')
  final int enableApiLogPreservation;

  @JsonKey(name: 'api_log_limit')
  final int apiLogPreservedQuantity;

  @JsonKey(name: 'api_log_save_days')
  final int apiLogPreservedDays;

  @JsonKey(name: 'user_record_user_enable')
  final int enableUserSystemLogPreservation;

  @JsonKey(name: 'user_record_user_limit')
  final int userSystemLogPreservedQuantity;

  @JsonKey(name: 'user_record_user_save_days')
  final int userSystemLogPreservedDays;

  @JsonKey(name: 'user_record_device_enable')
  final int enableDeviceSystemLogPreservation;

  @JsonKey(name: 'user_record_device_limit')
  final int deviceSystemLogPreservedQuantity;

  @JsonKey(name: 'user_record_device_save_days')
  final int deviceSystemLogPreservedDays;

  DefaultSetting({
    required this.deviceWorkingCycleIndex,
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

  /// Connect the generated [_$DefaultSettingFromJson] function to the `fromJson`
  /// factory.
  factory DefaultSetting.fromJson(Map<String, dynamic> json) =>
      _$DefaultSettingFromJson(json);

  /// Connect the generated [_$DefaultSettingToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DefaultSettingToJson(this);
}
