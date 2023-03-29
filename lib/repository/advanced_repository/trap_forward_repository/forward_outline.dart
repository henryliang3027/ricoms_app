import 'package:json_annotation/json_annotation.dart';

part 'forward_outline.g.dart';

/// 解析 forward 列表個別項目的 key-value,
/// fromJson : 從 json data 轉換為 ForwardOutline 的資料結構
/// toJson : 從 ForwardOutline 轉換為 json data
/// item 欄位後端有回傳資料, 但沒有使用到
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
