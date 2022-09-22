import 'package:json_annotation/json_annotation.dart';

part 'forward_outline.g.dart';

@JsonSerializable()
class ForwardOutline {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'enable')
  final int enable;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'ip')
  final String ip;

  @JsonKey(name: 'item')
  final String parameter;

  ForwardOutline({
    required this.id,
    required this.enable,
    required this.name,
    required this.ip,
    required this.parameter,
  });

  /// Connect the generated [_$ForwardOutlineFromJson] function to the `fromJson`
  /// factory.
  factory ForwardOutline.fromJson(Map<String, dynamic> json) =>
      _$ForwardOutlineFromJson(json);

  /// Connect the generated [_$ForwardOutlineToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ForwardOutlineToJson(this);
}
