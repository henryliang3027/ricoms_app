import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/advanced/bloc/batch_setting/config_device/config_device_bloc.dart';
import 'package:ricoms_app/advanced/view/batch_setting_view/config_device_form.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/batch_setting_device.dart';
import 'package:ricoms_app/repository/batch_setting_repository.dart';

class ConfigDevicePage extends StatelessWidget {
  const ConfigDevicePage({
    Key? key,
    required this.moduleId,
    required this.devices,
  }) : super(key: key);

  static Route route({
    required int moduleId,
    required List<BatchSettingDevice> devices,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ConfigDevicePage(
        moduleId: moduleId,
        devices: devices,
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
  final List<BatchSettingDevice> devices;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfigDeviceBloc(
        user: context.read<AuthenticationBloc>().state.user,
        moduleId: moduleId,
        batchSettingRepository:
            RepositoryProvider.of<BatchSettingRepository>(context),
      ),
      child: ConfigDeviceForm(
        devices: devices,
      ),
    );
  }
}
