import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart/chart_bloc.dart';
import 'package:ricoms_app/root/view/monitoring_chart_display_form.dart';

class MonitoringChartDisplayPage extends StatelessWidget {
  const MonitoringChartDisplayPage({
    Key? key,
    required this.index,
    required this.nodeId,
    required this.oid,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.majorH,
    required this.minorH,
    required this.majorL,
    required this.minorL,
  }) : super(key: key);

  final int index;
  final int nodeId;
  final String oid;
  final String name;
  final String startDate;
  final String endDate;
  final double majorH;
  final double minorH;
  final double majorL;
  final double minorL;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChartBloc(
        index: index,
        user: context.read<AuthenticationBloc>().state.user,
        deviceRepository: RepositoryProvider.of<DeviceRepository>(context),
        startDate: startDate,
        endDate: endDate,
        nodeId: nodeId,
        oid: oid,
      ),
      child: MonitoringChartDisplayForm(
        name: name,
      ),
    );
  }
}
