import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/advanced/bloc/server_ip_setting/server_ip_setting_bloc.dart';
import 'package:ricoms_app/advanced/view/server_ip_setting_view/server_ip_setting_form.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/advanced_repository/server_ip_setting_repository/server_ip_setting_repository.dart';

class ServerIPSettingPage extends StatelessWidget {
  const ServerIPSettingPage({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ServerIPSettingPage(),
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
      create: (context) => ServerIPSettingBloc(
        user: context.read<AuthenticationBloc>().state.user,
        serverIPSettingRepository:
            RepositoryProvider.of<ServerIPSettingRepository>(context),
      ),
      child: const ServerIPSettingForm(),
    );
  }
}
