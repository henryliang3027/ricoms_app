import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/advanced/bloc/batch_setting/device_setting_result/device_setting_result_bloc.dart';
import 'package:ricoms_app/advanced/view/batch_setting_view/device_setting_result_form.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/advanced_repository/batch_setting_repository/batch_setting_device.dart';
import 'package:ricoms_app/repository/advanced_repository/batch_setting_repository/batch_setting_repository.dart';

class DeviceSettingResultPage extends StatelessWidget {
  const DeviceSettingResultPage({
    Key? key,
    required this.devices,
    required this.deviceParamsMap,
  }) : super(key: key);

  static Route route({
    required List<BatchSettingDevice> devices,
    required Map<String, String> deviceParamsMap,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          DeviceSettingResultPage(
        devices: devices,
        deviceParamsMap: deviceParamsMap,
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

  final List<BatchSettingDevice> devices;
  final Map<String, String> deviceParamsMap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviceSettingResultBloc(
        user: context.read<AuthenticationBloc>().state.user,
        devices: devices,
        deviceParamsMap: deviceParamsMap,
        batchSettingRepository:
            RepositoryProvider.of<BatchSettingRepository>(context),
      ),
      child: const DeviceSettingResultForm(),
    );
  }
}
