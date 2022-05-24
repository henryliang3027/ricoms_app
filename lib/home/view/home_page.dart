import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/bookmarks/view/bookmarks.dart';
import 'package:ricoms_app/change_password/view/change_password_page.dart';
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
    final user = context.select(
      (AuthenticationBloc bloc) => bloc.state.user,
    );
    print('UserID: ${user.id}');

    return Scaffold(
      appBar: AppBar(
        title: Text(_bottomBarItem[_selectedIndex].label!),
      ),
      drawer: SafeArea(
        child: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    const SizedBox(
                      child: Image(image: AssetImage('assets/ic_launcher.png')),
                    ),
                    Padding(padding: EdgeInsets.only(top: 2.0)),
                    Text(user.name,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                ),
              ),
              ListTile(
                leading: Card(
                    elevation: 0,
                    shape: const CircleBorder(),
                    color: Colors.grey.shade300,
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.notifications_active_outlined))),
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
                leading: Card(
                    elevation: 0,
                    shape: const CircleBorder(),
                    color: Colors.grey.shade300,
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.account_tree_outlined))),
                title: const Text('Root'),
                onTap: () {
                  _pageController.jumpToPage(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Card(
                    elevation: 0,
                    shape: const CircleBorder(),
                    color: Colors.grey.shade300,
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.pie_chart_outline))),
                title: const Text('Dashboard'),
                onTap: () {
                  _pageController.jumpToPage(2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Card(
                    elevation: 0,
                    shape: const CircleBorder(),
                    color: Colors.grey.shade300,
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.history_outlined))),
                title: const Text('History'),
                onTap: () {
                  _pageController.jumpToPage(3);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Card(
                    elevation: 0,
                    shape: const CircleBorder(),
                    color: Colors.grey.shade300,
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.star_border_outlined))),
                title: const Text('Bookmarks'),
                onTap: () {
                  _pageController.jumpToPage(4);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Card(
                    elevation: 0,
                    shape: const CircleBorder(),
                    color: Colors.grey.shade300,
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.supervisor_account_outlined))),
                title: const Text('Account'),
                onTap: () {
                  _pageController.jumpToPage(1);
                  Navigator.pop(context);
                },
              ),
              const Divider(
                height: 2.0,
              ),
              const SizedBox(
                height: 8.0,
              ),
              const Padding(
                padding: EdgeInsets.all(6.0),
                child: Text(
                  'Setting',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              ListTile(
                leading: Card(
                    elevation: 0,
                    shape: const CircleBorder(),
                    color: Colors.grey.shade300,
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.security_outlined))),
                title: const Text('Change Password'),
                onTap: () async {
                  bool actionResult =
                      await Navigator.push(context, ChangePasswordPage.route());
                  actionResult
                      ? context
                          .read<AuthenticationBloc>()
                          .add(AuthenticationLogoutRequested(user.id))
                      : null;
                },
              ),
              const Padding(
                padding: EdgeInsets.all(6.0),
              ),
              const Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Card(
                    elevation: 0,
                    shape: const CircleBorder(),
                    color: Colors.grey.shade300,
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.logout_outlined,
                          color: Colors.red,
                        ))),
                title: const Text('Logout'),
                onTap: () {
                  context
                      .read<AuthenticationBloc>()
                      .add(AuthenticationLogoutRequested(user.id));
                },
              ),
            ],
          ),
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
