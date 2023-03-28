import 'package:json_annotation/json_annotation.dart';

part 'batch_setting_device.g.dart';

/// 解析 batch setting 用的 device 資料 key-value,
/// fromJson : 從 json data 轉換為 BatchSettingDevice 的資料結構
/// toJson : 從 BatchSettingDevice 轉換為 json data
@JsonSerializable()
class BatchSettingDevice {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'ip')
  final String ip;

  @JsonKey(name: 'device')
  final String deviceName;

  @JsonKey(name: 'group')
  final String group;

  @JsonKey(name: 'name')
  final String moduleName;

  @JsonKey(name: 'shelf')
  final int shelf;

  @JsonKey(name: 'slot')
  final int slot;

  BatchSettingDevice({
    required this.id,
    required this.ip,
    required this.deviceName,
    required this.group,
    required this.moduleName,
    required this.shelf,
    required this.slot,
  });

  /// Connect the generated [_$BatchSettingDeviceFromJson] function to the `fromJson`
  /// factory.
  factory BatchSettingDevice.fromJson(Map<String, dynamic> json) =>
      _$BatchSettingDeviceFromJson(json);

  /// Connect the generated [_$BatchSettingDeviceToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BatchSettingDeviceToJson(this);
}
