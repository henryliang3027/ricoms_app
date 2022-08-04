// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_function.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFunction _$UserFunctionFromJson(Map<String, dynamic> json) => UserFunction(
      functionId: json['func_id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      status: json['status'] as int,
    );

Map<String, dynamic> _$UserFunctionToJson(UserFunction instance) =>
    <String, dynamic>{
      'func_id': instance.functionId,
      'name': instance.name,
      'type': instance.type,
      'status': instance.status,
    };
