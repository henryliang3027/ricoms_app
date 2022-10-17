import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart_filter/chart_filter_bloc.dart';
import 'package:ricoms_app/root/view/monitoring_chart_filter_form.dart';
import 'package:ricoms_app/root/view/monitoring_chart_style.dart';
import 'package:ricoms_app/root/view/multiple_axis_chart_page.dart';
import 'package:ricoms_app/root/view/single_axis_chart_page.dart';

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
  final int maxLine = 2;

  List<Widget> _buildCharts({
    required String startDate,
    required String endDate,
    required Map<String, CheckBoxValue> selectedCheckBoxValues,
    required bool isMultipleAxis,
  }) {
    if (isMultipleAxis) {
      int index = -2;
      List<Widget> multipleAxisCharts = [];
      Map<String, CheckBoxValue> checkBoxValues = {};
      List<MapEntry<String, CheckBoxValue>> selectedCheckBoxValueEntries =
          selectedCheckBoxValues.entries.toList();
      int quotient = selectedCheckBoxValueEntries.length ~/ maxLine;
      int remainder = selectedCheckBoxValueEntries.length % maxLine;
      int count = 0;

      for (int i = 0; i < quotient * maxLine; i++) {
        MapEntry<String, CheckBoxValue> entry = selectedCheckBoxValueEntries[i];
        checkBoxValues[entry.key] = entry.value;
        count += 1;

        if (count == maxLine) {
          multipleAxisCharts.add(MultipleAxisChartPage(
            index: index += 2,
            nodeId: nodeId,
            startDate: startDate,
            endDate: endDate,
            selectedCheckBoxValues:
                Map<String, CheckBoxValue>.from(checkBoxValues),
          ));

          // clone a new one and assign selectedCheckBoxValues bofore clear checkBoxValues
          checkBoxValues.clear();
          count = 0;
        }
      }

      if (remainder > 0) {
        for (int i = quotient * maxLine;
            i < selectedCheckBoxValueEntries.length;
            i++) {
          MapEntry<String, CheckBoxValue> entry =
              selectedCheckBoxValueEntries[i];
          checkBoxValues[entry.key] = entry.value;
        }

        multipleAxisCharts.add(MultipleAxisChartPage(
          index: index += 2,
          nodeId: nodeId,
          startDate: startDate,
          endDate: endDate,
          selectedCheckBoxValues:
              Map<String, CheckBoxValue>.from(checkBoxValues),
        ));
      }

      return multipleAxisCharts;
    } else {
      int i = -1;
      List<Widget> singleAxisCharts = [];
      for (MapEntry<String, CheckBoxValue> entry
          in selectedCheckBoxValues.entries) {
        singleAxisCharts.add(SingleAxisChartPage(
          index: i += 1,
          startDate: startDate,
          endDate: endDate,
          nodeId: nodeId,
          oid: entry.key,
          name: entry.value.name,
          majorH: entry.value.majorH,
          minorH: entry.value.minorH,
          majorL: entry.value.majorL,
          minorL: entry.value.minorL,
        ));
      }

      return singleAxisCharts;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
        buildWhen: (previous, current) =>
            previous.selectedCheckBoxValues != current.selectedCheckBoxValues ||
            previous.isSelectMultipleYAxis != current.isSelectMultipleYAxis,
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: _buildCharts(
                startDate: state.startDate,
                endDate: state.endDate,
                selectedCheckBoxValues: state.selectedCheckBoxValues,
                isMultipleAxis: state.isSelectMultipleYAxis,
              ),
            ),
          );
        });
  }
}
