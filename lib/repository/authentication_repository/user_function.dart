import 'package:json_annotation/json_annotation.dart';

part 'user_function.g.dart';

@JsonSerializable()
class UserFunction {
  @JsonKey(name: 'func_id')
  final int functionId;

  @JsonKey(name: 'status')
  final int status;

  UserFunction({
    required this.functionId,
    required this.status,
  });

  /// Connect the generated [_$UserFunctionFromJson] function to the `fromJson`
  /// factory.
  factory UserFunction.fromJson(Map<String, dynamic> json) =>
      _$UserFunctionFromJson(json);

  /// Connect the generated [_$UserFunctionToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserFunctionToJson(this);
}
