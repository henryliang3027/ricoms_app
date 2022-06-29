import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/home/view/home_bottom_navigation_bar.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';
import 'package:ricoms_app/real_time_alarm/bloc/real_time_alarm_bloc.dart';
import 'package:ricoms_app/real_time_alarm/view/real_time_alarm_form.dart';
import 'package:ricoms_app/repository/real_time_alarm_repository.dart';
import 'package:ricoms_app/repository/user.dart';

class RealTimeAlarmPage extends StatefulWidget {
  const RealTimeAlarmPage({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  State<RealTimeAlarmPage> createState() => _RealTimeAlarmPageState();
}

class _RealTimeAlarmPageState extends State<RealTimeAlarmPage> {
  @override
  Widget build(BuildContext context) {
    //get user
    // not sure if it trigger setState
    // because it cause lauoutBuilder exception when use to pass as argument
    // User _user = context.select(
    //   (AuthenticationBloc bloc) => bloc.state.user,
    // );

    return Scaffold(
      appBar: AppBar(title: const Text('Real-Time Alarm')),
      bottomNavigationBar: HomeBottomNavigationBar(
        pageController: widget.pageController,
        selectedIndex: 0,
      ),
      drawer: HomeDrawer(
        user: context.read<AuthenticationBloc>().state.user,
        pageController: widget.pageController,
      ),
      body: BlocProvider(
        create: (context) => RealTimeAlarmBloc(
          user: context.read<AuthenticationBloc>().state.user,
          realTimeAlarmRepository:
              RepositoryProvider.of<RealTimeAlarmRepository>(context),
        ),
        child: const RealTimeAlarmForm(),
      ),
    );
  }
}
