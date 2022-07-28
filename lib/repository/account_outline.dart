import 'package:json_annotation/json_annotation.dart';

part 'account_outline.g.dart';

@JsonSerializable()
class AccountOutline {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'account')
  final String account;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'permission')
  final String permission;

  @JsonKey(name: 'dept')
  final String? department;

  AccountOutline({
    required this.id,
    required this.account,
    required this.name,
    required this.permission,
    this.department,
  });

  /// Connect the generated [_$AccountOutlineFromJson] function to the `fromJson`
  /// factory.
  factory AccountOutline.fromJson(Map<String, dynamic> json) =>
      _$AccountOutlineFromJson(json);

  /// Connect the generated [_$AccountToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AccountOutlineToJson(this);
}
