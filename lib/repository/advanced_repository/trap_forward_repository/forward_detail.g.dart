// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forward_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForwardDetail _$ForwardDetailFromJson(Map<String, dynamic> json) =>
    ForwardDetail(
      id: json['id'] as int?,
      enable: json['enable'] as int,
      name: json['name'] as String,
      ip: json['ip'] as String,
      parameters: (json['item'] as List<dynamic>)
          .map((e) => Parameter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ForwardDetailToJson(ForwardDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'enable': instance.enable,
      'name': instance.name,
      'ip': instance.ip,
      'item': instance.parameters.map((e) => e.toJson()).toList(),
    };

Parameter _$ParameterFromJson(Map<String, dynamic> json) => Parameter(
      name: json['name'] as String,
      oid: json['OID'] as String,
      checked: json['checked'] as int,
    );

Map<String, dynamic> _$ParameterToJson(Parameter instance) => <String, dynamic>{
      'name': instance.name,
      'OID': instance.oid,
      'checked': instance.checked,
    };
