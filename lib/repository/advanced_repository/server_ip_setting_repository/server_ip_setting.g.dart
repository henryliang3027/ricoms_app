// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_ip_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerIPSetting _$ServerIPSettingFromJson(Map<String, dynamic> json) =>
    ServerIPSetting(
      masterServerIP: json['server_master'] as String,
      slaveServerIP: json['server_slave'] as String,
      synchronizationInterval: json['master_wait_recovery'] as String,
      onlineServerIP: json['server_online'] as String,
    );

Map<String, dynamic> _$ServerIPSettingToJson(ServerIPSetting instance) =>
    <String, dynamic>{
      'server_master': instance.masterServerIP,
      'server_slave': instance.slaveServerIP,
      'master_wait_recovery': instance.synchronizationInterval,
      'server_online': instance.onlineServerIP,
    };
