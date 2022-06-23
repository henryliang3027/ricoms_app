import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/bookmarks/view/bookmarks.dart';
import 'package:ricoms_app/dashboard/view/dashboard.dart';
import 'package:ricoms_app/history/view/history.dart';
import 'package:ricoms_app/realtime_alarm/view/alarm.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/view/root_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final user = context.select(
      (AuthenticationBloc bloc) => bloc.state.user,
    );
    print('UserID: ${user.id}');

    RootRepository rootRepository = RootRepository(user);
    DeviceRepository deviceRepository = DeviceRepository(user);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RootRepository>(
          create: (context) => rootRepository,
        ),
        RepositoryProvider<DeviceRepository>(
          create: (context) => deviceRepository,
        ),
      ],
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: <Widget>[
            RealTimeAlarmPage(
              pageController: _pageController,
            ),
            RootPage(
              pageController: _pageController,
            ),
            DashboardPage(
              pageController: _pageController,
            ),
            HistoryPage(
              pageController: _pageController,
            ),
            BookmarksPage(
              pageController: _pageController,
            ),
          ],
          onPageChanged: (pageIndex) {
            setState(() {
              _selectedIndex = pageIndex;
            });
          },
        ),
      ),
    );
  }
}
