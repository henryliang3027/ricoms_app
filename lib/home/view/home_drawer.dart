import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/account/view/account_page.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/change_password/view/change_password_page.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_function.dart';
import 'package:ricoms_app/utils/common_style.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key? key,
    required this.user,
    required this.pageController,
    required this.currentPageIndex,
  }) : super(key: key);

  final User user;
  final PageController pageController;
  final int currentPageIndex;

  @override
  Widget build(BuildContext context) {
    List<UserFunction> userFunctions =
        context.read<AuthenticationBloc>().state.userFunctions;

    for (var item in userFunctions) {
      print('${item.name} ${item.status}');
    }

    List<String> _listTileTitles = [
      'Real-Time Alarm',
      'Network',
      'Dashboard',
      'History',
      'Bookmarks',
    ];

    List<IconData> _listTileIcons = [
      CustomIcons.realtimeAlarm,
      CustomIcons.network,
      CustomIcons.dashboard,
      CustomIcons.history,
      CustomIcons.bookmarks,
    ];

    List<Widget> _buildMainListView(int currentPageIndex) {
      return [
        for (int i = 0; i < _listTileTitles.length; i++)
          ListTile(
            dense: true,
            leading: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                _listTileIcons[i],
                color: currentPageIndex == i ? Colors.blue : Colors.grey,
              ),
            ),
            title: Text(
              _listTileTitles[i],
              style: TextStyle(
                fontSize: CommonStyle.sizeL,
                color: currentPageIndex == i ? Colors.blue : Colors.black,
              ),
            ),
            onTap: () {
              pageController.jumpToPage(i);
              Navigator.pop(context); //close drawer
            },
          ),
      ];
    }

    return SafeArea(
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
                    const Padding(padding: EdgeInsets.only(top: 6.0)),
                    Text(user.name,
                        style: const TextStyle(
                          fontSize: CommonStyle.sizeXL,
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                ),
              ),
            ),
            ..._buildMainListView(currentPageIndex),
            ListTile(
              dense: true,
              leading: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(CustomIcons.account),
              ),
              title: const Text(
                'Account',
                style: TextStyle(fontSize: CommonStyle.sizeL),
              ),
              onTap: () {
                Navigator.push(context, AccountPage.route());
              },
            ),
            const Divider(
              height: 0.0,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10.0, 2.0, 2.0, 0.0),
              child: Text(
                'Setting',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: CommonStyle.sizeS,
                ),
              ),
            ),
            ListTile(
              dense: true,
              leading: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(CustomIcons.changePassword),
              ),
              title: const Text(
                'Change Password',
                style: TextStyle(fontSize: CommonStyle.sizeL),
              ),
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
            const Divider(
              height: 0.0,
            ),
            ListTile(
              dense: true,
              leading: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(CustomIcons.logout),
              ),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: CommonStyle.sizeL),
              ),
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
              child: Text(
                CommonStyle.version,
                style: TextStyle(fontSize: CommonStyle.sizeS),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
