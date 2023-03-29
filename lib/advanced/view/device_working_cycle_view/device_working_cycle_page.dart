import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/advanced/bloc/device_working_cycle/device_working_cycle_bloc.dart';
import 'package:ricoms_app/advanced/view/device_working_cycle_view/device_working_cycle_form.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/advanced_repository/device_working_cycle_repository/device_working_cycle_repository.dart';

class DeviceWorkingCyclePage extends StatelessWidget {
  const DeviceWorkingCyclePage({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const DeviceWorkingCyclePage(),
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
      create: (context) => DeviceWorkingCycleBloc(
        user: context.read<AuthenticationBloc>().state.user,
        deviceWorkingCycleRepository:
            RepositoryProvider.of<DeviceWorkingCycleRepository>(context),
      ),
      child: const DeviceWorkingCycleForm(),
    );
  }
}
