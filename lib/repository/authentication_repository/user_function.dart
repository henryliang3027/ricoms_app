import 'package:json_annotation/json_annotation.dart';

part 'user_function.g.dart';

/// 解析使用者可以使用的 RISOMS 功能 key-value,
/// fromJson : 從 json data 轉換為 UserFunction 的資料結構
/// toJson : 從 UserFunction 轉換為 json data
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
