import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/advanced/bloc/batch_device_setting/batch_device_setting_bloc.dart';
import 'package:ricoms_app/advanced/view/batch_setting_view/batch_device_setting_form.dart';
import 'package:ricoms_app/advanced/view/batch_setting_view/batch_device_setting_tabbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/batch_setting_repository.dart';
import 'package:ricoms_app/repository/device_repository.dart';

class BatchDeviceSettingPage extends StatelessWidget {
  const BatchDeviceSettingPage({
    Key? key,
    required this.moduleId,
    required this.nodeIds,
  }) : super(key: key);

  static Route route({
    required int moduleId,
    required List<int> nodeIds,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          BatchDeviceSettingPage(
        moduleId: moduleId,
        nodeIds: nodeIds,
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
  final List<int> nodeIds;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BatchDeviceSettingBloc(
        user: context.read<AuthenticationBloc>().state.user,
        moduleId: moduleId,
        nodeIds: nodeIds,
        batchSettingRepository:
            RepositoryProvider.of<BatchSettingRepository>(context),
        deviceRepository: RepositoryProvider.of<DeviceRepository>(context),
      ),
      child: const BatchDeviceSettingForm(),
    );
  }
}
