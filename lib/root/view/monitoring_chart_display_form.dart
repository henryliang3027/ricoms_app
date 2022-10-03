import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart/chart_bloc.dart';
import 'package:ricoms_app/root/view/graph.dart';

class MonitoringChartDisplayForm extends StatefulWidget {
  const MonitoringChartDisplayForm({Key? key}) : super(key: key);

  @override
  State<MonitoringChartDisplayForm> createState() =>
      _MonitoringChartDisplayFormState();
}

class _MonitoringChartDisplayFormState
    extends State<MonitoringChartDisplayForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      builder: (context, state) {
        if (state.status.isRequestSuccess) {
          return Center(
            child: Graph(chartDateValuePairList: state.chartDateValuePairs),
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
