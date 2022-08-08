// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_function.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFunction _$UserFunctionFromJson(Map<String, dynamic> json) => UserFunction(
      functionId: json['func_id'] as int,
      status: json['status'] as int,
    );

Map<String, dynamic> _$UserFunctionToJson(UserFunction instance) =>
    <String, dynamic>{
      'func_id': instance.functionId,
      'status': instance.status,
    };
