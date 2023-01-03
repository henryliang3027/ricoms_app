// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_record_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogRecordSetting _$LogRecordSettingFromJson(Map<String, dynamic> json) =>
    LogRecordSetting(
      archivedHistoricalRecordQuanitiy:
          json['history_max_table_size'] as String,
      enableApiLogPreservation: json['log_schedule'] as String,
      apiLogPreservedQuantity: json['log_max_size'] as String,
      apiLogPreservedDays: json['log_max_save_days'] as String,
      enableUserSystemLogPreservation: json['device_schedule'] as String,
      userSystemLogPreservedQuantity: json['device_max_size'] as String,
      userSystemLogPreservedDays: json['device_max_save_days'] as String,
      enableDeviceSystemLogPreservation: json['user_schedule'] as String,
      deviceSystemLogPreservedQuantity: json['user_max_size'] as String,
      deviceSystemLogPreservedDays: json['user_max_save_days'] as String,
    );

Map<String, dynamic> _$LogRecordSettingToJson(LogRecordSetting instance) =>
    <String, dynamic>{
      'history_max_table_size': instance.archivedHistoricalRecordQuanitiy,
      'log_schedule': instance.enableApiLogPreservation,
      'log_max_size': instance.apiLogPreservedQuantity,
      'log_max_save_days': instance.apiLogPreservedDays,
      'device_schedule': instance.enableUserSystemLogPreservation,
      'device_max_size': instance.userSystemLogPreservedQuantity,
      'device_max_save_days': instance.userSystemLogPreservedDays,
      'user_schedule': instance.enableDeviceSystemLogPreservation,
      'user_max_size': instance.deviceSystemLogPreservedQuantity,
      'user_max_save_days': instance.deviceSystemLogPreservedDays,
    };
