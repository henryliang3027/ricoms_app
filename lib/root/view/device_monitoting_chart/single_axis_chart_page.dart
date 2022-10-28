import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/single_axis_chart_form.dart';

class SingleAxisChartPage extends StatelessWidget {
  const SingleAxisChartPage({
    Key? key,
    required this.chartDateValuePairs,
    required this.name,
    this.majorH,
    this.minorH,
    this.majorL,
    this.minorL,
  }) : super(key: key);

  final List<ChartDateValuePair> chartDateValuePairs;
  final String name;
  final double? majorH;
  final double? minorH;
  final double? majorL;
  final double? minorL;

  @override
  Widget build(BuildContext context) {
    return SingleAxisChartForm(
      chartDateValuePairs: chartDateValuePairs,
      name: name,
      majorH: majorH,
      majorL: majorL,
      majorHAnnotationColor: Colors.red,
      majorLAnnotationColor: Colors.red,
    );
  }
}
