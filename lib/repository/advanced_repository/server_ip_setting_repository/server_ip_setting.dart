import 'package:json_annotation/json_annotation.dart';

part 'server_ip_setting.g.dart';

/// 解析'伺服器 ip 設定'資料 key-value,
/// fromJson : 從 json data 轉換為 ServerIPSetting 的資料結構
/// toJson : 從 ServerIPSetting 轉換為 json data
@JsonSerializable()
class ServerIPSetting {
  @JsonKey(name: 'server_master')
  final String masterServerIP;

  @JsonKey(name: 'server_slave')
  final String slaveServerIP;

  @JsonKey(name: 'master_wait_recovery')
  final String synchronizationInterval;

  @JsonKey(name: 'server_online')
  final String onlineServerIP;

  ServerIPSetting({
    required this.masterServerIP,
    required this.slaveServerIP,
    required this.synchronizationInterval,
    required this.onlineServerIP,
  });

  /// Connect the generated [_$ServerIPSettingFromJson] function to the `fromJson`
  /// factory.
  factory ServerIPSetting.fromJson(Map<String, dynamic> json) =>
      _$ServerIPSettingFromJson(json);

  /// Connect the generated [_$ServerIPSettingToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ServerIPSettingToJson(this);
}
