import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/advanced/bloc/batch_setting/select_device/select_device_bloc.dart';
import 'package:ricoms_app/advanced/view/batch_setting_view/select_device_form.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/advanced_repository/batch_setting_repository/batch_setting_repository.dart';

class SelectDevicePage extends StatelessWidget {
  const SelectDevicePage({
    Key? key,
    required this.moduleId,
  }) : super(key: key);

  static Route route({
    required int moduleId,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SelectDevicePage(
        moduleId: moduleId,
      ),
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

  final int moduleId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectDeviceBloc(
        user: context.read<AuthenticationBloc>().state.user,
        moduleId: moduleId,
        batchSettingRepository:
            RepositoryProvider.of<BatchSettingRepository>(context),
      ),
      child: SelectDeviceForm(
        moduleId: moduleId,
      ),
    );
  }
}
