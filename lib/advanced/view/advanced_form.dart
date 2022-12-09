import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/advanced/view/trap_forward_page.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/home/view/home_bottom_navigation_bar.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/common_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdvancedForm extends StatelessWidget {
  const AdvancedForm({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? isExit = await CommonWidget.showExitAppDialog(context: context);
        return isExit ?? false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.advanced),
          leading: HomeDrawerToolTip.setToolTip(context),
          elevation: 0.0,
        ),
        bottomNavigationBar: HomeBottomNavigationBar(
          pageController: pageController,
          selectedIndex: 5, // No need to show button, set an useless index
        ),
        drawer: HomeDrawer(
          user: context.read<AuthenticationBloc>().state.user,
          pageController: pageController,
          currentPageIndex: 7,
        ),
        body: const Material(
          color: Colors.white,
          child: _AdvancedOptions(),
        ),
      ),
    );
  }
}

class _AdvancedOptions extends StatelessWidget {
  const _AdvancedOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map _userFunctionMap =
        context.read<AuthenticationBloc>().state.userFunctionMap;

    List<String> _trapListTileTitles = [
      AppLocalizations.of(context)!.trapForward,
      AppLocalizations.of(context)!.colorOfTrapAlarm,
      AppLocalizations.of(context)!.alarmSoundOfTrap,
    ];

    List<String> _systemListTileTitles = [
      AppLocalizations.of(context)!.serverIPSetting,
      AppLocalizations.of(context)!.clearLogRecordsSetting,
      AppLocalizations.of(context)!.resetToDefaultSettings,
    ];

    List<String> _deviceListTileTitles = [
      AppLocalizations.of(context)!.batchSetting,
      AppLocalizations.of(context)!.deviceWorkingCycle,
    ];

    List<int> _trapFunctionPermissions = [
      22,
      39,
      40,
    ];

    List<int> _systemFunctionPermissions = [
      27,
      34,
      38,
    ];

    List<int> _deviceFunctionPermissions = [
      30,
      36,
    ];

    List<Route> _trapFunctionRoutes = [
      TrapForwardPage.route(),
      TrapForwardPage.route(),
      TrapForwardPage.route(),
    ];

    List<Route> _systemFunctionRoutes = [
      TrapForwardPage.route(),
      TrapForwardPage.route(),
      TrapForwardPage.route(),
    ];

    List<Route> _deviceFunctionRoutes = [
      TrapForwardPage.route(),
      TrapForwardPage.route(),
      TrapForwardPage.route(),
    ];

    Widget _buildCatecory({required IconData icon, required String title}) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 2.0, 12.0),
        child: Row(
          children: [
            Icon(
              icon,
              //size: 26.0,
              color: Colors.blue,
            ),
            const SizedBox(
              width: 4.0,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      );
    }

    List<Widget> _buildTrapOptions() {
      List<Widget> trapListTiles = [];

      for (int i = 0; i < _trapFunctionPermissions.length; i++) {
        if (_userFunctionMap[_trapFunctionPermissions[i]]) {
          ListTile listTile = ListTile(
            trailing: const Icon(Icons.keyboard_arrow_right_outlined),
            title: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                _trapListTileTitles[i],
                style: const TextStyle(
                  fontSize: CommonStyle.sizeL,
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context, _trapFunctionRoutes[i]);
            },
          );
          trapListTiles.add(listTile);
        } else {
          continue;
        }
      }

      if (trapListTiles.isNotEmpty) {
        trapListTiles.insert(
          0,
          _buildCatecory(
            icon: CustomIcons.trap_alarm,
            title: AppLocalizations.of(context)!.advancedTrap,
          ),
        );
      }

      return trapListTiles;
    }

    List<Widget> _buildSystemOptions() {
      List<Widget> systemListTiles = [];

      for (int i = 0; i < _systemFunctionPermissions.length; i++) {
        if (_userFunctionMap[_systemFunctionPermissions[i]]) {
          ListTile listTile = ListTile(
            trailing: const Icon(Icons.keyboard_arrow_right_outlined),
            title: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                _systemListTileTitles[i],
                style: const TextStyle(
                  fontSize: CommonStyle.sizeL,
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context, _systemFunctionRoutes[i]);
            },
          );
          systemListTiles.add(listTile);
        } else {
          continue;
        }
      }

      if (systemListTiles.isNotEmpty) {
        systemListTiles.insert(
          0,
          _buildCatecory(
            icon: CustomIcons.trap_alarm,
            title: AppLocalizations.of(context)!.advancedSystem,
          ),
        );
      }

      return systemListTiles;
    }

    List<Widget> _buildDeviceOptions() {
      List<Widget> deviceListTiles = [];

      for (int i = 0; i < _deviceFunctionPermissions.length; i++) {
        if (_userFunctionMap[_deviceFunctionPermissions[i]]) {
          ListTile listTile = ListTile(
            trailing: const Icon(Icons.keyboard_arrow_right_outlined),
            title: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                _deviceListTileTitles[i],
                style: const TextStyle(
                  fontSize: CommonStyle.sizeL,
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context, _deviceFunctionRoutes[i]);
            },
          );
          deviceListTiles.add(listTile);
        } else {
          continue;
        }
      }

      if (deviceListTiles.isNotEmpty) {
        deviceListTiles.insert(
          0,
          _buildCatecory(
            icon: CustomIcons.trap_alarm,
            title: AppLocalizations.of(context)!.advancedDevice,
          ),
        );
      }

      return deviceListTiles;
    }

    return ListView(
      children: [
        ..._buildTrapOptions(),
        const SizedBox(
          height: 10.0,
        ),
        ..._buildSystemOptions(),
        const SizedBox(
          height: 10.0,
        ),
        ..._buildDeviceOptions(),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
