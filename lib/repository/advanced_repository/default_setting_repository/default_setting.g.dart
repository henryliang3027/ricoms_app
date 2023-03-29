// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefaultSetting _$DefaultSettingFromJson(Map<String, dynamic> json) =>
    DefaultSetting(
      deviceWorkingCycleIndex: json['rotation_index'] as int,
      archivedHistoricalRecordQuanitiy:
          json['device_trap_history_limit'] as int,
      enableApiLogPreservation: json['api_log_enable'] as int,
      apiLogPreservedQuantity: json['api_log_limit'] as int,
      apiLogPreservedDays: json['api_log_save_days'] as int,
      enableUserSystemLogPreservation: json['user_record_user_enable'] as int,
      userSystemLogPreservedQuantity: json['user_record_user_limit'] as int,
      userSystemLogPreservedDays: json['user_record_user_save_days'] as int,
      enableDeviceSystemLogPreservation:
          json['user_record_device_enable'] as int,
      deviceSystemLogPreservedQuantity: json['user_record_device_limit'] as int,
      deviceSystemLogPreservedDays: json['user_record_device_save_days'] as int,
    );

Map<String, dynamic> _$DefaultSettingToJson(DefaultSetting instance) =>
    <String, dynamic>{
      'rotation_index': instance.deviceWorkingCycleIndex,
      'device_trap_history_limit': instance.archivedHistoricalRecordQuanitiy,
      'api_log_enable': instance.enableApiLogPreservation,
      'api_log_limit': instance.apiLogPreservedQuantity,
      'api_log_save_days': instance.apiLogPreservedDays,
      'user_record_user_enable': instance.enableUserSystemLogPreservation,
      'user_record_user_limit': instance.userSystemLogPreservedQuantity,
      'user_record_user_save_days': instance.userSystemLogPreservedDays,
      'user_record_device_enable': instance.enableDeviceSystemLogPreservation,
      'user_record_device_limit': instance.deviceSystemLogPreservedQuantity,
      'user_record_device_save_days': instance.deviceSystemLogPreservedDays,
    };
