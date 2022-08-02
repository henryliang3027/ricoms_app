// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountDetail _$AccountDetailFromJson(Map<String, dynamic> json) =>
    AccountDetail(
      account: json['account'] as String,
      name: json['name'] as String,
      permission: json['permission'] as String,
      department: json['dept'] as String?,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      tel: json['tel'] as String?,
      ext: json['ext'] as String?,
      password: json['pwd'] as String?,
    );

Map<String, dynamic> _$AccountDetailToJson(AccountDetail instance) =>
    <String, dynamic>{
      'account': instance.account,
      'name': instance.name,
      'permission': instance.permission,
      'dept': instance.department,
      'email': instance.email,
      'mobile': instance.mobile,
      'tel': instance.tel,
      'ext': instance.ext,
      'pwd': instance.password,
    };
