import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart_filter/chart_filter_bloc.dart';
import 'package:ricoms_app/root/view/monitoring_chart_display_page.dart';
import 'package:ricoms_app/root/view/monitoring_chart_filter_form.dart';
import 'package:ricoms_app/root/view/monitoring_chart_style.dart';

class DeviceMonitoringChartForm extends StatelessWidget {
  const DeviceMonitoringChartForm({
    Key? key,
    required this.nodeId,
  }) : super(key: key);

  final int nodeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _DeviceMonitoringChartContent(
        nodeId: nodeId,
      ),
      floatingActionButton: const _ChartFloatingActionButton(),
    );
  }
}

class _DeviceMonitoringChartContent extends StatelessWidget {
  const _DeviceMonitoringChartContent({
    Key? key,
    required this.nodeId,
  }) : super(key: key);

  final int nodeId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
      buildWhen: (previous, current) =>
          previous.filterSelectingMode != current.filterSelectingMode,
      builder: (context, state) {
        return state.filterSelectingMode
            ? const MonitoringChartFilterForm()
            : _MonitoringChartGridView(
                nodeId: nodeId,
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

class _MonitoringChartGridView extends StatelessWidget {
  const _MonitoringChartGridView({
    Key? key,
    required this.nodeId,
  }) : super(key: key);

  final int nodeId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
        buildWhen: (previous, current) =>
            previous.selectedCheckBoxValues != current.selectedCheckBoxValues,
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 0;
                    i < state.selectedCheckBoxValues.length;
                    i++) ...[
                  MonitoringChartDisplayPage(
                    index: i,
                    startDate: state.startDate,
                    endDate: state.endDate,
                    nodeId: nodeId,
                    oid: state.selectedCheckBoxValues[i].oid,
                    name: state.selectedCheckBoxValues[i].name,
                    majorH: state.selectedCheckBoxValues[i].majorH,
                    minorH: state.selectedCheckBoxValues[i].minorH,
                    majorL: state.selectedCheckBoxValues[i].majorL,
                    minorL: state.selectedCheckBoxValues[i].minorL,
                  )
                ],
              ],
            ),
          );
        });
  }
}
