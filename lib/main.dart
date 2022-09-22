import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ricoms_app/app.dart';
import 'package:ricoms_app/repository/account_repository.dart';
import 'package:ricoms_app/repository/authentication_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ricoms_app/repository/bookmarks_repository.dart';
import 'package:ricoms_app/repository/dashboard_repository.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/history_repository.dart';
import 'package:ricoms_app/repository/real_time_alarm_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/repository/system_log_repository.dart';
import 'package:ricoms_app/repository/trap_forward_repository.dart';
import 'package:ricoms_app/repository/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // final dir = Directory('/data/user/0/com.example.ricoms_app/app_flutter/.db');
  // dir.deleteSync(recursive: true);
  await Hive.initFlutter('.db');
  Hive.registerAdapter<User>(UserAdapter());
  Hive.registerAdapter<DeviceMeta>(DeviceMetaAdapter());
  await Hive.openBox<User>('UserData');

  runApp(
    App(
      authenticationRepository: AuthenticationRepository(),
      realTimeAlarmRepository: RealTimeAlarmRepository(),
      rootRepository: RootRepository(),
      deviceRepository: DeviceRepository(),
      dashboardRepository: DashboardRepository(),
      historyRepository: HistoryRepository(),
      bookmarksRepository: BookmarksRepository(),
      systemLogRepository: SystemLogRepository(),
      accountRepository: AccountRepository(),
      trapForwardRepository: TrapForwardRepository(),
    ),
  );
}
