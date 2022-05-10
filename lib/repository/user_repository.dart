import 'dart:async';
import 'package:hive/hive.dart';
import 'package:ricoms_app/repository/user.dart';

class UserRepository {
  UserRepository() : _userBox = Hive.box('User');
  final Box<User> _userBox;

  // get full note
  Future<User?> getActivateUser() async {
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
      User newUser = User(id: user.id, ip: user.ip, isActivate: false);
      await _userBox.put(userId, newUser);

      return true;
    }
  }

  // to add data in box
  Future<void> addUserByKey(String userId, User user) async =>
      await _userBox.put(userId, user);

  // delete data from box
  Future<void> removeFromBox(int index) async => await _userBox.deleteAt(index);

  // delete all data from box
  Future<void> deleteAll() async => await _userBox.clear();
}
