import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/bookmarks/view/bookmarks.dart';
import 'package:ricoms_app/change_password/view/change_password_page.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
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

  final List<Widget> _widgetOptions = <Widget>[
    const RealTimeAlarmPage(),
    const RootPage(),
    const DashboardPage(),
    const HistoryPage(),
    const BookmarksPage(),
  ];

  final List<List<Widget>> _widgetActions = <List<Widget>>[
    [],
    [
      IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      IconButton(onPressed: () {}, icon: Icon(Icons.save_alt_outlined)),
    ],
    [],
    [
      IconButton(onPressed: () {}, icon: Icon(Icons.search)),
      IconButton(onPressed: () {}, icon: Icon(Icons.save_alt_outlined)),
    ],
    [],
  ];

  final List<BottomNavigationBarItem> _bottomBarItem = [
    const BottomNavigationBarItem(
      icon: Icon(CustomIcons.realtime_alarm),
      label: 'Real-Time Alarm',
    ),
    const BottomNavigationBarItem(
      icon: Icon(CustomIcons.root),
      label: 'Root',
    ),
    const BottomNavigationBarItem(
      icon: Icon(CustomIcons.dashboard),
      label: 'Dashboard',
    ),
    const BottomNavigationBarItem(
      icon: Icon(CustomIcons.history),
      label: 'History',
    ),
    const BottomNavigationBarItem(
      icon: Icon(CustomIcons.bookmarks),
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

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RootRepository>(
          create: (context) => RootRepository(user),
        ),
        RepositoryProvider<DeviceRepository>(
          create: (context) => DeviceRepository(user),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            _bottomBarItem[_selectedIndex].label!,
          ),
          actions: _widgetActions[_selectedIndex],
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
                SizedBox(
                  height: 120,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.white12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Padding(padding: EdgeInsets.only(top: 10.0)),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 66.0),
                          child: Image(
                            image: AssetImage('assets/RICOMS.PNG'),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 6.0)),
                        Text(user.name,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(CustomIcons.realtime_alarm),
                  ),
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
                  dense: true,
                  leading: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(CustomIcons.root),
                  ),
                  title: const Text('Root'),
                  onTap: () {
                    _pageController.jumpToPage(1);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(CustomIcons.dashboard),
                  ),
                  title: const Text('Dashboard'),
                  onTap: () {
                    _pageController.jumpToPage(2);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(CustomIcons.history),
                  ),
                  title: const Text('History'),
                  onTap: () {
                    _pageController.jumpToPage(3);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(CustomIcons.bookmarks),
                  ),
                  title: const Text('Bookmarks'),
                  onTap: () {
                    _pageController.jumpToPage(4);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(CustomIcons.account),
                  ),
                  title: const Text('Account'),
                  onTap: () {
                    _pageController.jumpToPage(1);
                    Navigator.pop(context);
                  },
                ),
                const Divider(
                  height: 0.0,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 2.0, 2.0, 0.0),
                  child: Text(
                    'Setting',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(CustomIcons.change_password),
                  ),
                  title: const Text('Change Password'),
                  onTap: () async {
                    bool actionResult = await Navigator.push(
                        context, ChangePasswordPage.route());
                    actionResult
                        ? context
                            .read<AuthenticationBloc>()
                            .add(AuthenticationLogoutRequested(user.id))
                        : null;
                  },
                ),
                const Divider(
                  height: 0.0,
                ),
                ListTile(
                  dense: true,
                  leading: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(CustomIcons.logout),
                  ),
                  title: const Text('Logout'),
                  onTap: () {
                    context
                        .read<AuthenticationBloc>()
                        .add(AuthenticationLogoutRequested(user.id));
                  },
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(2.0, 40.0, 2.0, 40.0),
                ),
                const Center(
                  //padding: EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                  child: Text('0.9.0'),
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
      ),
    );
  }
}
