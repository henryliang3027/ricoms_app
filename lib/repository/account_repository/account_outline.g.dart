// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_outline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountOutline _$AccountOutlineFromJson(Map<String, dynamic> json) =>
    AccountOutline(
      id: json['id'] as int,
      account: json['account'] as String,
      name: json['name'] as String,
      permission: json['permission'] as String,
      department: json['dept'] as String?,
    );

Map<String, dynamic> _$AccountOutlineToJson(AccountOutline instance) =>
    <String, dynamic>{
      'id': instance.id,
      'account': instance.account,
      'name': instance.name,
      'permission': instance.permission,
      'dept': instance.department,
    };
