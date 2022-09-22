// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forward_outline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForwardOutline _$ForwardOutlineFromJson(Map<String, dynamic> json) =>
    ForwardOutline(
      id: json['id'] as int,
      enable: json['enable'] as int,
      name: json['name'] as String,
      ip: json['ip'] as String,
      parameter: json['item'] as String,
    );

Map<String, dynamic> _$ForwardOutlineToJson(ForwardOutline instance) =>
    <String, dynamic>{
      'id': instance.id,
      'enable': instance.enable,
      'name': instance.name,
      'ip': instance.ip,
      'item': instance.parameter,
    };
