import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/monitoring_chart_style.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/multiple_axis_line_chart.dart';

class MultipleAxisChartForm extends StatelessWidget {
  const MultipleAxisChartForm({
    Key? key,
    required this.chartDateValuePairs,
    required this.selectedCheckBoxValues,
  }) : super(key: key);

  final Map<String, List<ChartDateValuePair>> chartDateValuePairs;
  final Map<String, CheckBoxValue> selectedCheckBoxValues;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: SizedBox(
        height: 400,
        child: MultipleAxisLineChart(
          chartDateValues: chartDateValuePairs,
          checkBoxValues: selectedCheckBoxValues,
        ),
      ),
    );
  }
}
