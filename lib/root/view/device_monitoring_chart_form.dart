import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart_filter/chart_filter_bloc.dart';
import 'package:ricoms_app/root/view/monitoring_chart_filter_form.dart';

class DeviceMonitoringChartForm extends StatelessWidget {
  const DeviceMonitoringChartForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _DeviceMonitoringChartContent(),
      floatingActionButton: _ChartFloatingActionButton(),
    );
  }
}

class _DeviceMonitoringChartContent extends StatelessWidget {
  const _DeviceMonitoringChartContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
      buildWhen: (previous, current) =>
          previous.filterSelectingMode != current.filterSelectingMode,
      builder: (context, state) {
        return state.filterSelectingMode
            ? const MonitoringChartFilterForm()
            : const _MonitoringChartDisplay();
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
                      .add(const FilterSelectingModeChanged());
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

class _MonitoringChartDisplay extends StatelessWidget {
  const _MonitoringChartDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Chart'),
    );
  }
}
