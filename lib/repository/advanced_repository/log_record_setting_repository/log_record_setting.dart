import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'log_record_setting.g.dart';

/// 解析'清除記錄相關設定'資料 key-value,
/// fromJson : 從 json data 轉換為 LogRecordSetting 的資料結構
/// toJson : 從 LogRecordSetting 轉換為 json data
@JsonSerializable()
class LogRecordSetting extends Equatable {
  @JsonKey(name: 'history_max_table_size')
  final String archivedHistoricalRecordQuanitiy;

  @JsonKey(name: 'log_schedule')
  final String enableApiLogPreservation;

  @JsonKey(name: 'log_max_size')
  final String apiLogPreservedQuantity;

  @JsonKey(name: 'log_max_save_days')
  final String apiLogPreservedDays;

  @JsonKey(name: 'user_schedule')
  final String enableUserSystemLogPreservation;

  @JsonKey(name: 'user_max_size')
  final String userSystemLogPreservedQuantity;

  @JsonKey(name: 'user_max_save_days')
  final String userSystemLogPreservedDays;

  @JsonKey(name: 'device_schedule')
  final String enableDeviceSystemLogPreservation;

  @JsonKey(name: 'device_max_size')
  final String deviceSystemLogPreservedQuantity;

  @JsonKey(name: 'device_max_save_days')
  final String deviceSystemLogPreservedDays;

  const LogRecordSetting({
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

  LogRecordSetting copyWith({
    String? archivedHistoricalRecordQuanitiy,
    String? enableApiLogPreservation,
    String? apiLogPreservedQuantity,
    String? apiLogPreservedDays,
    String? enableUserSystemLogPreservation,
    String? userSystemLogPreservedQuantity,
    String? userSystemLogPreservedDays,
    String? enableDeviceSystemLogPreservation,
    String? deviceSystemLogPreservedQuantity,
    String? deviceSystemLogPreservedDays,
  }) {
    return LogRecordSetting(
      archivedHistoricalRecordQuanitiy: archivedHistoricalRecordQuanitiy ??
          this.archivedHistoricalRecordQuanitiy,
      enableApiLogPreservation:
          enableApiLogPreservation ?? this.enableApiLogPreservation,
      apiLogPreservedQuantity:
          apiLogPreservedQuantity ?? this.apiLogPreservedQuantity,
      apiLogPreservedDays: apiLogPreservedDays ?? this.apiLogPreservedDays,
      enableUserSystemLogPreservation: enableUserSystemLogPreservation ??
          this.enableUserSystemLogPreservation,
      userSystemLogPreservedQuantity:
          userSystemLogPreservedQuantity ?? this.userSystemLogPreservedQuantity,
      userSystemLogPreservedDays:
          userSystemLogPreservedDays ?? this.userSystemLogPreservedDays,
      enableDeviceSystemLogPreservation: enableDeviceSystemLogPreservation ??
          this.enableDeviceSystemLogPreservation,
      deviceSystemLogPreservedQuantity: deviceSystemLogPreservedQuantity ??
          this.deviceSystemLogPreservedQuantity,
      deviceSystemLogPreservedDays:
          deviceSystemLogPreservedDays ?? this.deviceSystemLogPreservedDays,
    );
  }

  /// Connect the generated [_$LogRecordSettingFromJson] function to the `fromJson`
  /// factory.
  factory LogRecordSetting.fromJson(Map<String, dynamic> json) =>
      _$LogRecordSettingFromJson(json);

  /// Connect the generated [_$LogRecordSettingToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LogRecordSettingToJson(this);

  @override
  List<Object?> get props => [
        archivedHistoricalRecordQuanitiy,
        enableApiLogPreservation,
        apiLogPreservedQuantity,
        apiLogPreservedDays,
        enableUserSystemLogPreservation,
        userSystemLogPreservedQuantity,
        userSystemLogPreservedDays,
        enableDeviceSystemLogPreservation,
        deviceSystemLogPreservedQuantity,
        deviceSystemLogPreservedDays,
      ];
}
