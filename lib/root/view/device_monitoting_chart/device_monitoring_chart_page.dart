import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart_filter/chart_filter_bloc.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/device_monitoring_chart_form.dart';

class DeviceMonitoringChartPage extends StatelessWidget {
  const DeviceMonitoringChartPage({
    Key? key,
    required this.deviceBlock,
    required this.nodeId,
  }) : super(key: key);

  final DeviceBlock deviceBlock;
  final int nodeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChartFilterBloc(
          user: context.read<AuthenticationBloc>().state.user,
          deviceRepository: RepositoryProvider.of<DeviceRepository>(context),
          nodeId: nodeId,
          deviceBlock: deviceBlock),
      child: DeviceMonitoringChartForm(
        nodeId: nodeId,
      ),
    );
  }
}
