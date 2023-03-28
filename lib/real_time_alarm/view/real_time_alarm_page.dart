import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/real_time_alarm/bloc/real_time_alarm_bloc.dart';
import 'package:ricoms_app/real_time_alarm/view/real_time_alarm_form.dart';
import 'package:ricoms_app/repository/real_time_alarm_repository/real_time_alarm_repository.dart';

class RealTimeAlarmPage extends StatelessWidget {
  const RealTimeAlarmPage({
    Key? key,
    required this.pageController,
    required this.initialRootPath,
  }) : super(key: key);

  final PageController pageController;
  final List initialRootPath;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RealTimeAlarmBloc(
        user: context.read<AuthenticationBloc>().state.user,
        realTimeAlarmRepository:
            RepositoryProvider.of<RealTimeAlarmRepository>(context),
      ),
      child: RealTimeAlarmForm(
        pageController: pageController,
        initialPath: initialRootPath,
      ),
    );
  }
}
