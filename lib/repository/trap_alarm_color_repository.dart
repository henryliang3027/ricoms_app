import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_api.dart';

class TrapAlarmColorRepository {
  TrapAlarmColorRepository();

  final UserApi _userApi = UserApi(); // public field

  Future<dynamic> getTrapAlarmColor({required User user}) async {
    List<dynamic> result = _userApi.getTrapAlarmColorByUserId(user.id);
    if (result[0]) {
      return [true, result[1]];
    } else {
      return [false, result[1]];
    }
  }

  Future<dynamic> setTrapAlarmColor({
    required User user,
    required List<int> severityColors,
  }) async {
    List<dynamic> result =
        await _userApi.setTrapAlarmColorByUserId(user.id, severityColors);

    if (result[0]) {
      return [true];
    } else {
      return [false, result[1]];
    }
  }
}
