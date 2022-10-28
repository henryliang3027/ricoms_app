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
          title: Text(AppLocalizations.of(context)!.advanced),
          leading: HomeDrawerToolTip.setToolTip(context),
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
    List<Widget> _buildTrapOptions() {
      return [
        ListTile(
          trailing: const Icon(Icons.keyboard_arrow_right_outlined),
          title: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              AppLocalizations.of(context)!.trapForward,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(context, TrapForwardPage.route());
          },
        ),
        ListTile(
          trailing: const Icon(Icons.keyboard_arrow_right_outlined),
          title: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              AppLocalizations.of(context)!.colorOfTrapAlarm,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey,
              ),
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          trailing: const Icon(Icons.keyboard_arrow_right_outlined),
          title: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              AppLocalizations.of(context)!.alarmSoundOfTrap,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey,
              ),
            ),
          ),
          onTap: () {},
        ),
      ];
    }

    List<Widget> _buildSystemOptions() {
      return [
        ListTile(
          trailing: const Icon(Icons.keyboard_arrow_right_outlined),
          title: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              AppLocalizations.of(context)!.serverIPSetting,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey,
              ),
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          trailing: const Icon(Icons.keyboard_arrow_right_outlined),
          title: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              AppLocalizations.of(context)!.clearLogRecordsSetting,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey,
              ),
            ),
          ),
          onTap: () {},
        ),
      ];
    }

    List<Widget> _buildDeviceOptions() {
      return [
        ListTile(
          trailing: const Icon(Icons.keyboard_arrow_right_outlined),
          title: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              AppLocalizations.of(context)!.batchSetting,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey,
              ),
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          trailing: const Icon(Icons.keyboard_arrow_right_outlined),
          title: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              AppLocalizations.of(context)!.deviceWorkingCycle,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey,
              ),
            ),
          ),
          onTap: () {},
        ),
      ];
    }

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

    return ListView(
      children: [
        _buildCatecory(
          icon: CustomIcons.trap_alarm,
          title: AppLocalizations.of(context)!.advancedTrap,
        ),
        ..._buildTrapOptions(),
        const SizedBox(
          height: 10.0,
        ),
        _buildCatecory(
          icon: CustomIcons.system,
          title: AppLocalizations.of(context)!.advancedSystem,
        ),
        ..._buildSystemOptions(),
        const SizedBox(
          height: 10.0,
        ),
        _buildCatecory(
          icon: CustomIcons.device_simple,
          title: AppLocalizations.of(context)!.advancedDevice,
        ),
        ..._buildDeviceOptions(),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
