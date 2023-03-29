// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_setting_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BatchSettingDevice _$BatchSettingDeviceFromJson(Map<String, dynamic> json) =>
    BatchSettingDevice(
      id: json['id'] as int,
      ip: json['ip'] as String,
      deviceName: json['device'] as String,
      group: json['group'] as String,
      moduleName: json['name'] as String,
      shelf: json['shelf'] as int,
      slot: json['slot'] as int,
    );

Map<String, dynamic> _$BatchSettingDeviceToJson(BatchSettingDevice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ip': instance.ip,
      'device': instance.deviceName,
      'group': instance.group,
      'name': instance.moduleName,
      'shelf': instance.shelf,
      'slot': instance.slot,
    };
