import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart/chart_bloc.dart';
import 'package:ricoms_app/root/view/line_chart.dart';

class MonitoringChartDisplayForm extends StatelessWidget {
  const MonitoringChartDisplayForm({
    Key? key,
    required this.name,
    required this.majorH,
    required this.majorL,
  }) : super(key: key);

  final String name;
  final double majorH;
  final double majorL;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      builder: (context, state) {
        if (state.status.isRequestSuccess) {
          return MonitoringLineChart(
            chartDateValuePairs: state.chartDateValuePairs,
            name: name,
            majorH: majorH,
            majorL: majorL,
          );
        } else if (state.status.isRequestFailure) {
          return Center(
            child: Text(state.errMsg),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
