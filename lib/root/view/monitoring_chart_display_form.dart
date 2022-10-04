import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart/chart_bloc.dart';
import 'package:ricoms_app/root/view/graph.dart';

class MonitoringChartDisplayForm extends StatefulWidget {
  const MonitoringChartDisplayForm({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  widget.name,
                ),
              ),
              Graph(chartDateValuePairList: state.chartDateValuePairs),
            ],
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
