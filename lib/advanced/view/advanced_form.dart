import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/home/view/home_bottom_navigation_bar.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/common_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/utils/message_localization.dart';

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
          title: Text(AppLocalizations.of(context)!.account),
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
        body: Container(
          color: Colors.white,
          child: const _AdvancedOption(),
        ),
      ),
    );
  }
}

class _AdvancedOption extends StatelessWidget {
  const _AdvancedOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          ListTile(
            leading: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.roundabout_right_rounded),
            ),
            trailing: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.keyboard_arrow_right_outlined),
            ),
            title: Text(
              AppLocalizations.of(context)!.advancedTrap,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
            ),
            onTap: () {
              Navigator.push(context, _TrapForm.route());
            },
          ),
          ListTile(
            leading: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.settings_system_daydream_outlined),
            ),
            trailing: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.keyboard_arrow_right_outlined),
            ),
            title: Text(
              AppLocalizations.of(context)!.advancedSystem,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(CustomIcons.device),
            ),
            trailing: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.keyboard_arrow_right_outlined),
            ),
            title: Text(
              AppLocalizations.of(context)!.advancedDevice,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _TrapForm extends StatelessWidget {
  const _TrapForm({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const _TrapForm(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.advancedTrap),
      ),
      body: Container(
        color: Colors.white,
        child: const _TrapOption(),
      ),
    );
  }
}

class _TrapOption extends StatelessWidget {
  const _TrapOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          ListTile(
            trailing: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.keyboard_arrow_right_outlined),
            ),
            title: Text(
              AppLocalizations.of(context)!.trapFowward,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            trailing: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.keyboard_arrow_right_outlined),
            ),
            title: Text(
              AppLocalizations.of(context)!.colorOfTrapAlarm,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            trailing: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.keyboard_arrow_right_outlined),
            ),
            title: Text(
              AppLocalizations.of(context)!.alarmSoundOfTrap,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
