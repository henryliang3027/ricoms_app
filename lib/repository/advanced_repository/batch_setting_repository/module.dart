import 'package:json_annotation/json_annotation.dart';

part 'module.g.dart';

/// 解析批次設定用的模組資料 key-value,
/// fromJson : 從 json data 轉換為 Module 的資料結構
/// toJson : 從 Module 轉換為 json data
@JsonSerializable()
class Module {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  Module({
    required this.id,
    required this.name,
  });

  /// Connect the generated [_$ModuleFromJson] function to the `fromJson`
  /// factory.
  factory Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);

  /// Connect the generated [_$ModuleToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ModuleToJson(this);
}
