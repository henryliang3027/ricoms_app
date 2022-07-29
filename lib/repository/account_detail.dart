import 'package:json_annotation/json_annotation.dart';

part 'account_detail.g.dart';

@JsonSerializable()
class AccountDetail {
  @JsonKey(name: 'account')
  final String account;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'permission')
  final String permission;

  @JsonKey(name: 'dept')
  final String? department;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'mobile')
  final String? mobile;

  @JsonKey(name: 'tel')
  final String? tel;

  @JsonKey(name: 'ext')
  final String? ext;

  AccountDetail({
    required this.account,
    required this.name,
    required this.permission,
    this.department,
    this.email,
    this.mobile,
    this.tel,
    this.ext,
  });

  /// Connect the generated [_$AccountDetailFromJson] function to the `fromJson`
  /// factory.
  factory AccountDetail.fromJson(Map<String, dynamic> json) =>
      _$AccountDetailFromJson(json);

  /// Connect the generated [_$AccountToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AccountDetailToJson(this);
}
