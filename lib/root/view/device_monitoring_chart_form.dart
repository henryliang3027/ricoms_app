import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart_filter/chart_filter_bloc.dart';
import 'package:ricoms_app/root/view/monitoring_chart_display_page.dart';
import 'package:ricoms_app/root/view/monitoring_chart_filter_form.dart';
import 'package:ricoms_app/root/view/monitoring_chart_style.dart';
import 'package:ricoms_app/root/view/multiple_axis_chart_page.dart';

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
    int i = -1;
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
        buildWhen: (previous, current) =>
            previous.selectedCheckBoxValues != current.selectedCheckBoxValues ||
            previous.isSelectMultipleYAxis != current.isSelectMultipleYAxis,
        builder: (context, state) {
          return state.isSelectMultipleYAxis
              ? MultipleAxisChartPage(
                  nodeId: nodeId,
                  startDate: state.startDate,
                  endDate: state.endDate,
                  selectedCheckBoxValues: state.selectedCheckBoxValues,
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      for (MapEntry<String, CheckBoxValue> entry
                          in state.selectedCheckBoxValues.entries) ...[
                        MonitoringChartDisplayPage(
                          index: i += 1,
                          startDate: state.startDate,
                          endDate: state.endDate,
                          nodeId: nodeId,
                          oid: entry.key,
                          name: entry.value.name,
                          majorH: entry.value.majorH,
                          minorH: entry.value.minorH,
                          majorL: entry.value.majorL,
                          minorL: entry.value.minorL,
                        )
                      ],
                    ],
                  ),
                );
        });
  }
}
