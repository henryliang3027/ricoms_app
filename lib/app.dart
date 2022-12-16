import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/home/view/home_page.dart';
import 'package:ricoms_app/login/view/login_page.dart';
import 'package:ricoms_app/repository/account_repository.dart';
import 'package:ricoms_app/repository/authentication_repository.dart';
import 'package:ricoms_app/repository/batch_setting_repository.dart';
import 'package:ricoms_app/repository/bookmarks_repository.dart';
import 'package:ricoms_app/repository/dashboard_repository.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/history_repository.dart';
import 'package:ricoms_app/repository/real_time_alarm_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/repository/system_log_repository.dart';
import 'package:ricoms_app/repository/trap_forward_repository.dart';

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
    required this.batchSettingRepository,
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
  final BatchSettingRepository batchSettingRepository;

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
        RepositoryProvider<BatchSettingRepository>(
          create: (context) => batchSettingRepository,
        ),
      ],
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
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
