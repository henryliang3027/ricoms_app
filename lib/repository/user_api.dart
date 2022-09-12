import 'dart:async';
import 'package:hive/hive.dart';
import 'package:ricoms_app/repository/user.dart';

class UserApi {
  UserApi() : _userBox = Hive.box('UserData');
  final Box<User> _userBox;

  User? getActivateUser() {
    List<User> users = _userBox.values.toList();

    for (User user in users) {
      if (user.isActivate) {
        return user;
      }
    }

    return null;
  }

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
          isActivate: false);
      await _userBox.put(userId, newUser);

      return true;
    }
  }

  // add user if it does not existed, otherwise, update user's data
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
          isActivate: true);
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
          isActivate: true);
      await _userBox.put(userId, updatedUser);
    }
  }

  // delete data from box
  Future<void> removeFromBox(int index) async => await _userBox.deleteAt(index);

  // delete all data from box
  Future<void> deleteAll() async => await _userBox.clear();

  // get user device bookmarks
  List<DeviceMeta> getBookmarksByUserId(String userId) =>
      _userBox.get(userId) != null ? _userBox.get(userId)!.bookmarks : [];

  // add user device bookmarks
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
      );
      await _userBox.put(userId, updatedUser);

      return true;
    } else {
      return false;
    }
  }

  // delete user device bookmarks
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
      );
      await _userBox.put(userId, updatedUser);

      return true;
    } else {
      return false;
    }
  }

  // delete user device bookmarks
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
      );
      await _userBox.put(userId, updatedUser);

      return true;
    } else {
      return false;
    }
  }
}
