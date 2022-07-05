import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/bookmarks/view/bookmarks.dart';
import 'package:ricoms_app/dashboard/view/dashboard_page.dart';
import 'package:ricoms_app/history/view/history.dart';
import 'package:ricoms_app/real_time_alarm/view/real_time_alarm_page.dart';
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
  final PageController _pageController = PageController();

  List initialRootPath = [];

  @override
  Widget build(BuildContext context) {
    final user = context.select(
      (AuthenticationBloc bloc) => bloc.state.user,
    );
    print('UserID: ${user.id}');

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          RealTimeAlarmPage(
            pageController: _pageController,
            initialRootPath: initialRootPath,
          ),
          RootPage(
            pageController: _pageController,
            initialRootPath: initialRootPath,
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
      ),
    );
  }
}
