import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_api.dart';

class TrapAlarmSoundRepository {
  TrapAlarmSoundRepository();

  final UserApi _userApi = UserApi();

  Future<dynamic> getAlarmSoundEnableValues({required User user}) async {
    List<dynamic> result = _userApi.getAlarmSoundEnableValuesByUserId(user.id);
    if (result[0]) {
      return [true, result[1]];
    } else {
      return [false, result[1]];
    }
  }

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
