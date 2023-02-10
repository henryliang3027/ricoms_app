import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/advanced/bloc/trap_forward/trap_forward_bloc.dart';
import 'package:ricoms_app/advanced/view/trap_forward_view/trap_forward_form.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/trap_forward_repository.dart';

class TrapForwardPage extends StatelessWidget {
  const TrapForwardPage({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const TrapForwardPage(),
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
      create: (context) => TrapForwardBloc(
        user: context.read<AuthenticationBloc>().state.user,
        trapForwardRepository:
            RepositoryProvider.of<TrapForwardRepository>(context),
      ),
      child: const TrapForwardForm(),
    );
  }
}
