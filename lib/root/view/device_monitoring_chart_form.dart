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
          return DefaultTabController(
            length: state.selectedCheckBoxValues.length,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.blue,
                  child: TabBar(
                    unselectedLabelColor: Colors.white,
                    labelColor: Colors.blue,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Colors.white,
                    ),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                    tabs: [
                      for (CheckBoxValue checkBoxValue
                          in state.selectedCheckBoxValues) ...[
                        Text(checkBoxValue.name),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (CheckBoxValue checkBoxValue
                          in state.selectedCheckBoxValues) ...[
                        MonitoringChartDisplayPage(
                          startDate: state.startDate,
                          endDate: state.endDate,
                          nodeId: nodeId,
                          oid: checkBoxValue.oid,
                          name: checkBoxValue.name,
                          majorH: checkBoxValue.majorH,
                          minorH: checkBoxValue.minorH,
                          majorL: checkBoxValue.majorL,
                          minorL: checkBoxValue.minorL,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );

          // ListView(
          //   children: [
          //     for (CheckBoxValue checkBoxValue
          //         in state.selectedCheckBoxValues) ...[
          //       MonitoringChartDisplayPage(
          //         startDate: state.startDate,
          //         endDate: state.endDate,
          //         nodeId: nodeId,
          //         oid: checkBoxValue.oid,
          //         name: checkBoxValue.name,
          //         majorH: checkBoxValue.majorH,
          //         minorH: checkBoxValue.minorH,
          //         majorL: checkBoxValue.majorL,
          //         minorL: checkBoxValue.minorL,
          //       )
          //     ],
          //   ],
          // );
        });
  }
}