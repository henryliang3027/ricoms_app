import 'package:flutter/material.dart';
import 'package:ricoms_app/app.dart';
import 'package:ricoms_app/repository/authentication_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_repository.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<User>(UserAdapter());
  await Hive.openBox<User>('User');
  runApp(
    App(
      authenticationRepository: AuthenticationRepository(UserRepository()),
    ),
  );
}
