import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/advanced/bloc/trap_alarm_sound/trap_alarm_sound_bloc.dart';
import 'package:ricoms_app/advanced/view/trap_alarm_sound_view/trap_alarm_sound_form.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/trap_alarm_sound_repository.dart';

class TrapAlarmSoundPage extends StatelessWidget {
  const TrapAlarmSoundPage({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const TrapAlarmSoundPage(),
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
      create: (context) => TrapAlarmSoundBloc(
        user: context.read<AuthenticationBloc>().state.user,
        trapAlarmSoundRepository:
            RepositoryProvider.of<TrapAlarmSoundRepository>(context),
      ),
      child: const TrapAlarmSoundForm(),
    );
  }
}
