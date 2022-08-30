import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/change_password/view/change_password_page.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    Map _userFunctionMap =
        context.read<AuthenticationBloc>().state.userFunctionMap;

    List<String> _listTileTitles = [
      AppLocalizations.of(context)!.realTimeAlarm,
      AppLocalizations.of(context)!.network,
      AppLocalizations.of(context)!.dashboard,
      AppLocalizations.of(context)!.history,
      AppLocalizations.of(context)!.bookmarks,
    ];

    List<IconData> _listTileIcons = [
      CustomIcons.realtimeAlarm,
      CustomIcons.network,
      CustomIcons.dashboard,
      CustomIcons.history,
      CustomIcons.bookmarks,
    ];

    List<String> _extraListTileTitles = [
      AppLocalizations.of(context)!.account,
    ];

    List<IconData> _extraListTileIcons = [
      CustomIcons.account,
    ];

    List<int> _extraListFunctionPermissions = [
      5,
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

    List<Widget> _buildExtraListView(int currentPageIndex) {
      List<Widget> extraListTile = [];

      for (int i = 0; i < _extraListTileTitles.length; i++) {
        if (_userFunctionMap[_extraListFunctionPermissions[i]]) {
          int pageIndex = _listTileTitles.length;
          ListTile listTile = ListTile(
            dense: true,
            leading: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                _extraListTileIcons[i],
                color:
                    currentPageIndex == pageIndex ? Colors.blue : Colors.grey,
              ),
            ),
            title: Text(
              _extraListTileTitles[i],
              style: TextStyle(
                fontSize: CommonStyle.sizeL,
                color:
                    currentPageIndex == pageIndex ? Colors.blue : Colors.black,
              ),
            ),
            onTap: () {
              pageController.jumpToPage(pageIndex);
              Navigator.pop(context); //close drawer
            },
          );
          extraListTile.add(listTile);
        } else {
          continue;
        }
      }

      return extraListTile;
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Padding(padding: EdgeInsets.only(top: 10.0)),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 66.0),
                    child: Image(
                      image: AssetImage('assets/RICOMS.PNG'),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 6.0)),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: CommonStyle.sizeXL,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 6.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        CommonStyle.version,
                        style: TextStyle(fontSize: CommonStyle.sizeS),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Divider(
              height: 0.0,
            ),
            ..._buildMainListView(currentPageIndex),
            ..._buildExtraListView(currentPageIndex),
            const Divider(
              height: 0.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 2.0, 2.0, 0.0),
              child: Text(
                AppLocalizations.of(context)!.setting,
                style: const TextStyle(
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
              title: Text(
                AppLocalizations.of(context)!.changePassword,
                style: const TextStyle(fontSize: CommonStyle.sizeL),
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
              title: Text(
                AppLocalizations.of(context)!.logout,
                style: const TextStyle(fontSize: CommonStyle.sizeL),
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
          ],
        ),
      ),
    );
  }
}
