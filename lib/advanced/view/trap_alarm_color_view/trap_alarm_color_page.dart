import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/advanced/bloc/trap_alarm_color/trap_alarm_color_bloc.dart';
import 'package:ricoms_app/advanced/view/trap_alarm_color_view/trap_alarm_color_form.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/trap_alarm_color_repository.dart';

class TrapAlarmColorPage extends StatelessWidget {
  const TrapAlarmColorPage({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const TrapAlarmColorPage(),
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
      create: (context) => TrapAlarmColorBloc(
        user: context.read<AuthenticationBloc>().state.user,
        trapAlarmColorRepository:
            RepositoryProvider.of<TrapAlarmColorRepository>(context),
      ),
      child: const TrapAlarmColorForm(),
    );
  }
}
