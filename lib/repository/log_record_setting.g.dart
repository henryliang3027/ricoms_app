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
      enableUserSystemLogPreservation: json['user_schedule'] as String,
      userSystemLogPreservedQuantity: json['user_max_size'] as String,
      userSystemLogPreservedDays: json['user_max_save_days'] as String,
      enableDeviceSystemLogPreservation: json['device_schedule'] as String,
      deviceSystemLogPreservedQuantity: json['device_max_size'] as String,
      deviceSystemLogPreservedDays: json['device_max_save_days'] as String,
    );

Map<String, dynamic> _$LogRecordSettingToJson(LogRecordSetting instance) =>
    <String, dynamic>{
      'history_max_table_size': instance.archivedHistoricalRecordQuanitiy,
      'log_schedule': instance.enableApiLogPreservation,
      'log_max_size': instance.apiLogPreservedQuantity,
      'log_max_save_days': instance.apiLogPreservedDays,
      'user_schedule': instance.enableUserSystemLogPreservation,
      'user_max_size': instance.userSystemLogPreservedQuantity,
      'user_max_save_days': instance.userSystemLogPreservedDays,
      'device_schedule': instance.enableDeviceSystemLogPreservation,
      'device_max_size': instance.deviceSystemLogPreservedQuantity,
      'device_max_save_days': instance.deviceSystemLogPreservedDays,
    };
