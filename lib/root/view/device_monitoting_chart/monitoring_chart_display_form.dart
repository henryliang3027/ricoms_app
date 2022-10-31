import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart_filter/chart_filter_bloc.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/multiple_axis_chart_page.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/single_axis_chart_form.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/monitoring_chart_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MonitoringChartDisplayForm extends StatelessWidget {
  const MonitoringChartDisplayForm({
    Key? key,
    required this.nodeId,
    required this.nodeName,
  }) : super(key: key);

  final int nodeId;
  final String nodeName;
  final int maxLine = 2;

  ListView _buildChart({
    required String startDate,
    required String endDate,
    required Map<String, CheckBoxValue> selectedCheckBoxValues,
    required Map<String, List<ChartDateValuePair>> chartDateValuePairs,
    required bool isMultipleAxis,
  }) {
    if (isMultipleAxis) {
      return ListView.builder(
          cacheExtent: 10000.0,
          itemCount: selectedCheckBoxValues.length % maxLine == 0
              ? selectedCheckBoxValues.length ~/ maxLine
              : selectedCheckBoxValues.length ~/ maxLine + 1,
          itemBuilder: (context, index) {
            index *= 2;
            Map<String, CheckBoxValue> checkBoxValues = {};
            Map<String, List<ChartDateValuePair>> chartDateValuePairsBlock = {};
            List<MapEntry<String, CheckBoxValue>> selectedCheckBoxValueEntries =
                selectedCheckBoxValues.entries.toList();

            if (index + 1 < selectedCheckBoxValues.length) {
              for (int i = index; i < index + maxLine; i++) {
                MapEntry<String, CheckBoxValue> entry =
                    selectedCheckBoxValueEntries[i];

                checkBoxValues[entry.key] = entry.value;
                chartDateValuePairsBlock[entry.key] =
                    chartDateValuePairs[entry.key] ?? [];
              }
            } else {
              MapEntry<String, CheckBoxValue> entry =
                  selectedCheckBoxValueEntries[index];

              checkBoxValues[entry.key] = entry.value;
              chartDateValuePairsBlock[entry.key] =
                  chartDateValuePairs[entry.key] ?? [];
            }

            return MultipleAxisChartPage(
              chartDateValuePairs: Map<String, List<ChartDateValuePair>>.from(
                  chartDateValuePairsBlock),
              index: 0,
              nodeId: nodeId,
              startDate: startDate,
              endDate: endDate,
              selectedCheckBoxValues:
                  Map<String, CheckBoxValue>.from(checkBoxValues),
            );
          });
    } else {
      return ListView.builder(
        cacheExtent: 10000.0,
        itemCount: selectedCheckBoxValues.length,
        itemBuilder: (context, index) {
          MapEntry<String, CheckBoxValue> entry =
              selectedCheckBoxValues.entries.toList()[index];
          return SingleAxisChartForm(
            nodeName: nodeName,
            chartDateValuePairs: chartDateValuePairs[entry.key] ?? [],
            name: entry.value.name,
            majorH: entry.value.majorH,
            majorL: entry.value.majorL,
            majorHAnnotationColor: Colors.red,
            majorLAnnotationColor: Colors.red,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
        builder: (context, state) {
      if (state.chartDataStatus == FormStatus.requestSuccess) {
        return _buildChart(
          startDate: state.startDate,
          endDate: state.endDate,
          selectedCheckBoxValues: state.selectedCheckBoxValues,
          chartDateValuePairs: state.chartDateValuePairsMap,
          isMultipleAxis: state.isSelectMultipleYAxis,
        );
      } else if (state.chartDataStatus == FormStatus.requestFailure) {
        return Center(
          child: Text(
            AppLocalizations.of(context)!.dialogMessage_NoChartData,
          ),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}
