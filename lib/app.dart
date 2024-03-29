import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/home/view/home_page.dart';
import 'package:ricoms_app/login/view/login_page.dart';
import 'package:ricoms_app/repository/account_repository/account_repository.dart';
import 'package:ricoms_app/repository/advanced_repository/batch_setting_repository/batch_setting_repository.dart';
import 'package:ricoms_app/repository/advanced_repository/default_setting_repository/default_setting_repository.dart';
import 'package:ricoms_app/repository/advanced_repository/log_record_setting_repository/log_record_setting_repository.dart';
import 'package:ricoms_app/repository/advanced_repository/server_ip_setting_repository/server_ip_setting_repository.dart';
import 'package:ricoms_app/repository/authentication_repository/authentication_repository.dart';
import 'package:ricoms_app/repository/bookmarks_repository/bookmarks_repository.dart';
import 'package:ricoms_app/repository/dashboard_repository/dashboard_repository.dart';
import 'package:ricoms_app/repository/root_repository/device_repository.dart';
import 'package:ricoms_app/repository/advanced_repository/device_working_cycle_repository/device_working_cycle_repository.dart';
import 'package:ricoms_app/repository/history_repository/history_repository.dart';
import 'package:ricoms_app/repository/real_time_alarm_repository/real_time_alarm_repository.dart';
import 'package:ricoms_app/repository/root_repository/root_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/repository/system_log_repository/system_log_repository.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_alarm_color_repository/trap_alarm_color_repository.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_alarm_sound_repository/trap_alarm_sound_repository.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_forward_repository/trap_forward_repository.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
    required this.realTimeAlarmRepository,
    required this.rootRepository,
    required this.deviceRepository,
    required this.dashboardRepository,
    required this.historyRepository,
    required this.bookmarksRepository,
    required this.systemLogRepository,
    required this.accountRepository,
    required this.trapForwardRepository,
    required this.trapAlarmColorRepository,
    required this.trapAlarmSoundRepository,
    required this.serverIPSettingRepository,
    required this.logRecordSettingRepository,
    required this.defaultSettingRepository,
    required this.batchSettingRepository,
    required this.deviceWorkingCycleRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final RealTimeAlarmRepository realTimeAlarmRepository;
  final RootRepository rootRepository;
  final DeviceRepository deviceRepository;
  final DashboardRepository dashboardRepository;
  final HistoryRepository historyRepository;
  final BookmarksRepository bookmarksRepository;
  final SystemLogRepository systemLogRepository;
  final AccountRepository accountRepository;
  final TrapForwardRepository trapForwardRepository;
  final TrapAlarmColorRepository trapAlarmColorRepository;
  final TrapAlarmSoundRepository trapAlarmSoundRepository;
  final ServerIPSettingRepository serverIPSettingRepository;
  final LogRecordSettingRepository logRecordSettingRepository;
  final DefaultSettingRepository defaultSettingRepository;
  final BatchSettingRepository batchSettingRepository;
  final DeviceWorkingCycleRepository deviceWorkingCycleRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => authenticationRepository,
        ),
        RepositoryProvider<RealTimeAlarmRepository>(
          create: (context) => realTimeAlarmRepository,
        ),
        RepositoryProvider<RootRepository>(
          create: (context) => rootRepository,
        ),
        RepositoryProvider<DeviceRepository>(
          create: (context) => deviceRepository,
        ),
        RepositoryProvider<DashboardRepository>(
          create: (context) => dashboardRepository,
        ),
        RepositoryProvider<HistoryRepository>(
          create: (context) => historyRepository,
        ),
        RepositoryProvider<BookmarksRepository>(
          create: (context) => bookmarksRepository,
        ),
        RepositoryProvider<SystemLogRepository>(
          create: (context) => systemLogRepository,
        ),
        RepositoryProvider<AccountRepository>(
          create: (context) => accountRepository,
        ),
        RepositoryProvider<TrapForwardRepository>(
          create: (context) => trapForwardRepository,
        ),
        RepositoryProvider<TrapAlarmColorRepository>(
          create: (context) => trapAlarmColorRepository,
        ),
        RepositoryProvider<TrapAlarmSoundRepository>(
          create: (context) => trapAlarmSoundRepository,
        ),
        RepositoryProvider<ServerIPSettingRepository>(
          create: (context) => serverIPSettingRepository,
        ),
        RepositoryProvider<LogRecordSettingRepository>(
          create: (context) => logRecordSettingRepository,
        ),
        RepositoryProvider<DefaultSettingRepository>(
          create: (context) => defaultSettingRepository,
        ),
        RepositoryProvider<BatchSettingRepository>(
          create: (context) => batchSettingRepository,
        ),
        RepositoryProvider<DeviceWorkingCycleRepository>(
          create: (context) => deviceWorkingCycleRepository,
        ),
      ],
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          trapAlarmColorRepository: trapAlarmColorRepository,
          trapAlarmSoundRepository: trapAlarmSoundRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const <Locale>[
        Locale('en'),
        Locale('zh'),
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant'), //to use traditional chinese datepicker
      ],
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) async {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
