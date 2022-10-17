import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart/chart_bloc.dart';
import 'package:ricoms_app/root/view/single_axis_chart_form.dart';

class SingleAxisChartPage extends StatelessWidget {
  const SingleAxisChartPage({
    Key? key,
    required this.index,
    required this.nodeId,
    required this.oid,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.majorH,
    this.minorH,
    this.majorL,
    this.minorL,
  }) : super(key: key);

  final int index;
  final int nodeId;
  final String oid;
  final String name;
  final String startDate;
  final String endDate;
  final double? majorH;
  final double? minorH;
  final double? majorL;
  final double? minorL;

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
      child: SingleAxisChartForm(
        name: name,
        majorH: majorH,
        majorL: majorL,
        majorHAnnotationColor: Colors.red,
        majorLAnnotationColor: Colors.red,
      ),
    );
  }
}
