import 'package:flutter/material.dart';
import 'package:ricoms_app/about/about_page.dart';
import 'package:ricoms_app/account/view/account_page.dart';
import 'package:ricoms_app/advanced/view/advanced_view/advanced_page.dart';
import 'package:ricoms_app/bookmarks/view/bookmarks_page.dart';
import 'package:ricoms_app/dashboard/view/dashboard_page.dart';
import 'package:ricoms_app/history/view/history_page.dart';
import 'package:ricoms_app/real_time_alarm/view/real_time_alarm_page.dart';
import 'package:ricoms_app/root/view/root_page.dart';
import 'package:ricoms_app/system_log/view/system_log_page.dart';

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
            initialRootPath: initialRootPath,
          ),
          BookmarksPage(
            pageController: _pageController,
            initialRootPath: initialRootPath,
          ),
          SystemLogPage(
            pageController: _pageController,
            initialRootPath: initialRootPath,
          ),
          AccountPage(
            pageController: _pageController,
          ),
          AdvancedPage(
            pageController: _pageController,
          ),
          AboutPage(
            pageController: _pageController,
          ),
        ],
      ),
    );
  }
}
