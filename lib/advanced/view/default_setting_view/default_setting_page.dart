import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/advanced/bloc/default_setting/default_setting_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/advanced_repository/default_setting_repository/default_setting_repository.dart';
import 'package:ricoms_app/repository/advanced_repository/device_working_cycle_repository/device_working_cycle_repository.dart';
import 'package:ricoms_app/repository/advanced_repository/log_record_setting_repository/log_record_setting_repository.dart';

import 'default_setting_form.dart';

class DefaultSettingPage extends StatelessWidget {
  const DefaultSettingPage({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const DefaultSettingPage(),
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
    return BlocProvider(
      create: (context) => DefaultSettingBloc(
        user: context.read<AuthenticationBloc>().state.user,
        defaultSettingRepository:
            RepositoryProvider.of<DefaultSettingRepository>(context),
        deviceWorkingCycleRepository:
            RepositoryProvider.of<DeviceWorkingCycleRepository>(context),
        logRecordSettingRepository:
            RepositoryProvider.of<LogRecordSettingRepository>(context),
      ),
      child: const DefaultSettingForm(),
    );
  }
}
