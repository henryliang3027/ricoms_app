import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ricoms_app/app.dart';
import 'package:ricoms_app/repository/authentication_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ricoms_app/repository/dashboard_repository.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/history_repository.dart';
import 'package:ricoms_app/repository/real_time_alarm_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/repository/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Hive.initFlutter('.db');
  Hive.registerAdapter<User>(UserAdapter());
  await Hive.openBox<User>('User');

  runApp(
    App(
      authenticationRepository: AuthenticationRepository(),
      realTimeAlarmRepository: RealTimeAlarmRepository(),
      rootRepository: RootRepository(),
      deviceRepository: DeviceRepository(),
      dashboardRepository: DashboardRepository(),
      historyRepository: HistoryRepository(),
    ),
  );
}
