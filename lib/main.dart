import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ricoms_app/app.dart';
import 'package:ricoms_app/repository/authentication_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_repository.dart';

Future<void> main() async {
  // add these lines
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Hive.initFlutter('.db');
  Hive.registerAdapter<User>(UserAdapter());
  await Hive.openBox<User>('User');
  runApp(
    App(
      authenticationRepository: AuthenticationRepository(UserRepository()),
    ),
  );
}
