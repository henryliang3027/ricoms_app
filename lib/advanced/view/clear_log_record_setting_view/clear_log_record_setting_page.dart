import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/advanced/bloc/log_record_setting/log_record_setting_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/log_record_setting_repository.dart';

import 'clear_log_record_setting_form.dart';

class LogRecordSettingPage extends StatelessWidget {
  const LogRecordSettingPage({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LogRecordSettingPage(),
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
      create: (context) => LogRecordSettingBloc(
        user: context.read<AuthenticationBloc>().state.user,
        logRecordSettingRepository:
            RepositoryProvider.of<LogRecordSettingRepository>(context),
      ),
      child: const LogRecordSettingForm(),
    );
  }
}
