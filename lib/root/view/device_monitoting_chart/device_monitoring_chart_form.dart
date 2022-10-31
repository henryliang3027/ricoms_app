import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart_filter/chart_filter_bloc.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/monitoring_chart_display_form.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/monitoring_chart_filter_form.dart';

class DeviceMonitoringChartForm extends StatelessWidget {
  const DeviceMonitoringChartForm({
    Key? key,
    required this.nodeId,
    required this.nodeName,
  }) : super(key: key);

  final int nodeId;
  final String nodeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _DeviceMonitoringChartContent(
        nodeId: nodeId,
        nodeName: nodeName,
      ),
      floatingActionButton: const _ChartFloatingActionButton(),
    );
  }
}

class _DeviceMonitoringChartContent extends StatelessWidget {
  const _DeviceMonitoringChartContent({
    Key? key,
    required this.nodeId,
    required this.nodeName,
  }) : super(key: key);

  final int nodeId;
  final String nodeName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
      buildWhen: (previous, current) =>
          previous.filterSelectingMode != current.filterSelectingMode,
      builder: (context, state) {
        return state.filterSelectingMode
            ? const MonitoringChartFilterForm()
            : MonitoringChartDisplayForm(
                nodeId: nodeId,
                nodeName: nodeName,
              );
      },
    );
  }
}

class _ChartFloatingActionButton extends StatelessWidget {
  const _ChartFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
      builder: (context, state) {
        if (!state.filterSelectingMode) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: null,
                elevation: 0.0,
                backgroundColor: const Color(0x742195F3),
                onPressed: () async {
                  context
                      .read<ChartFilterBloc>()
                      .add(const FilterSelectingModeEnabled());
                },
                child: const Icon(
                  Icons.edit,
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
