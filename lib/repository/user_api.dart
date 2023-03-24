import 'dart:async';
import 'package:hive/hive.dart';
import 'package:ricoms_app/repository/user.dart';

/// 負責管理手機端資料庫
class UserApi {
  UserApi() : _userBox = Hive.box('UserData');
  final Box<User> _userBox;

  /// 取得已登入的使用者, 通常只會有一個使用者是已登入,其他都是登出狀態
  User? getActivateUser() {
    List<User> users = _userBox.values.toList();

    for (User user in users) {
      if (user.isActivate) {
        return user;
      }
    }

    return null;
  }

  /// 使用者登出, 將該使用者改為登出狀態
  Future<bool> deActivateUser(String userId) async {
    User? user = _userBox.get(userId);

    if (user == null) {
      return false;
    } else {
      User newUser = User(
        id: user.id,
        ip: user.ip,
        name: user.name,
        password: user.password,
        permission: user.permission,
        email: user.email,
        mobile: user.mobile,
        tel: user.tel,
        ext: user.ext,
        bookmarks: user.bookmarks,
        account: user.account,
        isActivate: false,
        severityColors: user.severityColors,
      );
      await _userBox.put(userId, newUser);

      return true;
    }
  }

  /// 新增使用者到手機端資料庫, 如果該使用者 id 已存在, 則更新其資料
  Future<void> addUserByKey({
    required String userId,
    String ip = '',
    String name = '',
    String account = '',
    String password = '',
    String permission = '',
    String email = '',
    String mobile = '',
    String tel = '',
    String ext = '',
  }) async {
    User? user = _userBox.get(userId); //get user if it already exists

    if (user == null) {
      // add user
      User newUser = User(
        id: userId,
        ip: ip,
        name: name,
        account: account,
        password: password,
        permission: permission,
        email: email,
        mobile: mobile,
        tel: tel,
        ext: ext,
        bookmarks: const [],
        isActivate: true,
      );
      await _userBox.put(userId, newUser);
    } else {
      //update user's data
      User updatedUser = User(
        id: user.id,
        ip: ip,
        name: name,
        account: account,
        password: password,
        permission: permission,
        email: email,
        mobile: mobile,
        tel: tel,
        ext: ext,
        bookmarks: user.bookmarks, //get user's latest bookbarks
        isActivate: true,
        severityColors: user.severityColors,
        alarmSoundEnableValues: user.alarmSoundEnableValues,
      );
      await _userBox.put(userId, updatedUser);
    }
  }

  /// 刪除使用者 (尚未調用)
  Future<void> removeFromBox(int index) async => await _userBox.deleteAt(index);

  /// 刪除所有使用者 (尚未調用)
  Future<void> deleteAll() async => await _userBox.clear();

  /// 藉由使用者 id 取得使用者的書籤
  List<DeviceMeta> getBookmarksByUserId(String userId) =>
      _userBox.get(userId) != null ? _userBox.get(userId)!.bookmarks : [];

  /// 藉由使用者 id 加入 device 到使用者的書籤
  Future<bool> addBookmarksByUserId(
      String userId, DeviceMeta deviceMeta) async {
    //nodeId represent to edfa id or a8k slot id
    User? user = _userBox.get(userId); //get user if it already exists

    if (user != null) {
      List<DeviceMeta> newBookmarks = [];
      newBookmarks.addAll(user.bookmarks);
      newBookmarks.add(deviceMeta);

      User updatedUser = User(
        id: user.id,
        ip: user.ip,
        name: user.name,
        password: user.password,
        account: user.account,
        permission: user.permission,
        email: user.email,
        mobile: user.mobile,
        tel: user.tel,
        ext: user.ext,
        bookmarks: newBookmarks,
        isActivate: true,
        severityColors: user.severityColors,
        alarmSoundEnableValues: user.alarmSoundEnableValues,
      );
      await _userBox.put(userId, updatedUser);

      return true;
    } else {
      return false;
    }
  }

  /// 藉由使用者 id 將 device 從使用者的書籤中刪除
  Future<bool> deleteBookmarksByUserId(String userId, int deviceId) async {
    User? user = _userBox.get(userId); //get user if it already exists

    if (user != null) {
      List<DeviceMeta> newBookmarks = [];
      newBookmarks.addAll(user.bookmarks);
      newBookmarks.removeWhere((deviceMeta) => deviceMeta.id == deviceId);

      User updatedUser = User(
        id: user.id,
        ip: user.ip,
        name: user.name,
        account: user.account,
        password: user.password,
        permission: user.permission,
        email: user.email,
        mobile: user.mobile,
        tel: user.tel,
        ext: user.ext,
        bookmarks: newBookmarks,
        isActivate: true,
        severityColors: user.severityColors,
        alarmSoundEnableValues: user.alarmSoundEnableValues,
      );
      await _userBox.put(userId, updatedUser);

      return true;
    } else {
      return false;
    }
  }

  /// 藉由使用者 id 將 "多筆" device 從使用者的書籤中刪除
  Future<bool> deleteMultipleBookmarksByUserId(
      String userId, List<int> deviceIds) async {
    User? user = _userBox.get(userId); //get user if it already exists

    if (user != null) {
      List<DeviceMeta> newBookmarks = [];
      newBookmarks.addAll(user.bookmarks);
      newBookmarks
          .removeWhere((deviceMeta) => deviceIds.contains(deviceMeta.id));

      User updatedUser = User(
        id: user.id,
        ip: user.ip,
        name: user.name,
        account: user.account,
        password: user.password,
        permission: user.permission,
        email: user.email,
        mobile: user.mobile,
        tel: user.tel,
        ext: user.ext,
        bookmarks: newBookmarks,
        isActivate: true,
        severityColors: user.severityColors,
        alarmSoundEnableValues: user.alarmSoundEnableValues,
      );
      await _userBox.put(userId, updatedUser);

      return true;
    } else {
      return false;
    }
  }

  /// 藉由使用者 id 設定使用者個人的 alarm color
  Future<dynamic> setTrapAlarmColorByUserId(
    String userId,
    List<int> severityColors,
  ) async {
    User? user = _userBox.get(userId); //get user if it already exists

    if (user != null) {
      User updatedUser = User(
        id: user.id,
        ip: user.ip,
        name: user.name,
        account: user.account,
        password: user.password,
        permission: user.permission,
        email: user.email,
        mobile: user.mobile,
        tel: user.tel,
        ext: user.ext,
        bookmarks: user.bookmarks,
        isActivate: true,
        severityColors: severityColors,
        alarmSoundEnableValues: user.alarmSoundEnableValues,
      );

      await _userBox.put(userId, updatedUser);

      return [true];
    } else {
      return [false, 'User does not exist.'];
    }
  }

  /// 藉由使用者 id 取得使用者個人的 alarm color
  List<dynamic> getTrapAlarmColorByUserId(
    String userId,
  ) {
    User? user = _userBox.get(userId); //get user if it already exists

    if (user != null) {
      return [true, user.severityColors];
    } else {
      return [false, 'User does not exist.'];
    }
  }

  /// 藉由使用者 id 儲存使用者個人的 alarm sound 啟用/停用設定
  Future<dynamic> setAlarmSoundEnableValuesByUserId(
    String userId,
    List<bool> alarmSoundEnableValues,
  ) async {
    User? user = _userBox.get(userId);

    if (user != null) {
      User updatedUser = User(
        id: user.id,
        ip: user.ip,
        name: user.name,
        account: user.account,
        password: user.password,
        permission: user.permission,
        email: user.email,
        mobile: user.mobile,
        tel: user.tel,
        ext: user.ext,
        bookmarks: user.bookmarks,
        isActivate: true,
        severityColors: user.severityColors,
        alarmSoundEnableValues: alarmSoundEnableValues,
      );

      await _userBox.put(userId, updatedUser);

      return [true];
    } else {
      return [false, 'User does not exist.'];
    }
  }

  /// 藉由使用者 id 取得使用者個人的 alarm sound 啟用/停用設定
  List<dynamic> getAlarmSoundEnableValuesByUserId(
    String userId,
  ) {
    User? user = _userBox.get(userId);

    if (user != null) {
      return [true, user.alarmSoundEnableValues];
    } else {
      return [false, 'User does not exist.'];
    }
  }
}
