import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ricoms_app/app.dart';
import 'package:ricoms_app/repository/account_repository.dart';
import 'package:ricoms_app/repository/authentication_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ricoms_app/repository/batch_setting_repository.dart';
import 'package:ricoms_app/repository/bookmarks_repository.dart';
import 'package:ricoms_app/repository/dashboard_repository.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/device_working_cycle_repository.dart';
import 'package:ricoms_app/repository/history_repository.dart';
import 'package:ricoms_app/repository/log_record_setting_repository.dart';
import 'package:ricoms_app/repository/real_time_alarm_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/repository/server_ip_setting_repository.dart';
import 'package:ricoms_app/repository/system_log_repository.dart';
import 'package:ricoms_app/repository/trap_alarm_color_repository.dart';
import 'package:ricoms_app/repository/trap_alarm_sound_repository.dart';
import 'package:ricoms_app/repository/trap_forward_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.

//   print("Handling a background message: ${message.messageId}");
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // final dir = Directory('/data/user/0/com.example.ricoms_app/app_flutter/.db');
  // dir.deleteSync(recursive: true);
  await Hive.initFlutter('.db');
  Hive.registerAdapter<User>(UserAdapter());
  Hive.registerAdapter<DeviceMeta>(DeviceMetaAdapter());
  await Hive.openBox<User>('UserData');

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print(fcmToken);

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
      trapAlarmColorRepository: TrapAlarmColorRepository(),
      trapAlarmSoundRepository: TrapAlarmSoundRepository(),
      serverIPSettingRepository: ServerIPSettingRepository(),
      logRecordSettingRepository: LogRecordSettingRepository(),
      batchSettingRepository: BatchSettingRepository(),
      deviceWorkingCycleRepository: DeviceWorkingCycleRepository(),
    ),
  );
}
