import 'package:json_annotation/json_annotation.dart';

part 'module.g.dart';

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
