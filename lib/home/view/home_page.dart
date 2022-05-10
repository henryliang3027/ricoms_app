import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/bookmarks/view/bookmarks.dart';
import 'package:ricoms_app/dashboard/view/dashboard.dart';
import 'package:ricoms_app/history/view/history.dart';
import 'package:ricoms_app/realtime_alarm/view/alarm.dart';
import 'package:ricoms_app/root/view/root.dart';

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
  final List<Widget> _widgetOptions = <Widget>[
    const RealTimeAlarmPage(),
    const RootPage(),
    const DashboardPage(),
    const HistoryPage(),
    const BookmarksPage(),
  ];

  final List<BottomNavigationBarItem> _bottomBarItem = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.notifications_active_outlined),
      label: 'Real-Time Alarm',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_tree_outlined),
      label: 'Root',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.insert_chart_outlined_outlined),
      label: 'Dashboard',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.history_outlined),
      label: 'History',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.star_border_outlined),
      label: 'Bookmarks',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        _selectedIndex,
        duration: const Duration(milliseconds: 100),
        curve: Curves.bounceIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.select(
      (AuthenticationBloc bloc) => bloc.state.user.id,
    );
    print('UserID: $userId');

    return Scaffold(
      appBar: AppBar(
        title: Text(_bottomBarItem[_selectedIndex].label!),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active_outlined),
              title: const Text('Real-Time Alarm'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                _pageController.jumpToPage(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Root'),
              onTap: () {
                _pageController.jumpToPage(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Dashboard'),
              onTap: () {
                _pageController.jumpToPage(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('History'),
              onTap: () {
                _pageController.jumpToPage(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Bookmarks'),
              onTap: () {
                _pageController.jumpToPage(4);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Account'),
              onTap: () {
                _pageController.jumpToPage(1);
                Navigator.pop(context);
              },
            ),
            const Divider(
              height: 2.0,
            ),
            ListTile(
              title: const Text('Change Password'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested(userId));
              },
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: _widgetOptions,
        onPageChanged: (pageIndex) {
          setState(() {
            _selectedIndex = pageIndex;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: _bottomBarItem,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).hintColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
