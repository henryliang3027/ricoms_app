import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_api.dart';

class TrapAlarmSoundRepository {
  TrapAlarmSoundRepository();

  final UserApi _userApi = UserApi();

  /// 從手機端資料庫取得使用者個人的 alarm sound 設定
  Future<dynamic> getAlarmSoundEnableValues({required User user}) async {
    List<dynamic> result = _userApi.getAlarmSoundEnableValuesByUserId(user.id);
    if (result[0]) {
      return [true, result[1]];
    } else {
      return [false, result[1]];
    }
  }

  /// 更新使用者個人的 alarm sound 的設定到手機端資料庫
  Future<dynamic> setAlarmSoundEnableValues({
    required User user,
    required List<bool> alarmSoundEnableValues,
  }) async {
    List<dynamic> result = await _userApi.setAlarmSoundEnableValuesByUserId(
        user.id, alarmSoundEnableValues);

    if (result[0]) {
      return [true];
    } else {
      return [false, result[1]];
    }
  }
}
