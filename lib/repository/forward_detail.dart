import 'package:json_annotation/json_annotation.dart';

part 'forward_detail.g.dart';

/// 解析 forward 設定內容 key-value,
/// fromJson : 從 json data 轉換為 ForwardDetail 的資料結構
/// toJson : 從 ForwardDetail 轉換為 json data
@JsonSerializable(explicitToJson: true)
class ForwardDetail {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'enable')
  final int enable;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'ip')
  final String ip;

  @JsonKey(name: 'item')
  final List<Parameter> parameters;

  ForwardDetail({
    required this.id,
    required this.enable,
    required this.name,
    required this.ip,
    required this.parameters,
  });

  /// Connect the generated [_$ForwardDetailFromJson] function to the `fromJson`
  /// factory.
  factory ForwardDetail.fromJson(Map<String, dynamic> json) =>
      _$ForwardDetailFromJson(json);

  /// Connect the generated [_$ForwardDetailToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ForwardDetailToJson(this);
}

/// 解析 forward 設定內容裡的 'item' 欄位的所有 key-value
@JsonSerializable(explicitToJson: true)
class Parameter {
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'OID')
  final String oid;

  @JsonKey(name: 'checked')
  final int checked;

  Parameter({
    required this.name,
    required this.oid,
    required this.checked,
  });

  /// Connect the generated [_$ParameterFromJson] function to the `fromJson`
  /// factory.
  factory Parameter.fromJson(Map<String, dynamic> json) =>
      _$ParameterFromJson(json);

  /// Connect the generated [_$ParameterToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ParameterToJson(this);
}
