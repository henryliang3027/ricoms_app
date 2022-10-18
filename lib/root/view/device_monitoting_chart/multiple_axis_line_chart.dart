import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/monitoring_chart_style.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MultipleAxisLineChart extends StatefulWidget {
  const MultipleAxisLineChart({
    Key? key,
    required this.chartDateValues,
    required this.checkBoxValues,
  }) : super(key: key);

  final Map<String, List<ChartDateValuePair>> chartDateValues;
  final Map<String, CheckBoxValue> checkBoxValues;

  @override
  State<MultipleAxisLineChart> createState() => _MultipleAxisLineChartState();
}

class _MultipleAxisLineChartState extends State<MultipleAxisLineChart> {
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.longPress,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
    );
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      enablePinching: true,
      zoomMode: ZoomMode.x,
    );

    super.initState();
  }

  List<ChartSeries> _buildSeries() {
    List<ChartSeries> series = [];
    List<MapEntry<String, List<ChartDateValuePair>>> chartDateValueEntries =
        widget.chartDateValues.entries.toList();
    for (int i = 0; i < chartDateValueEntries.length; i++) {
      MapEntry<String, List<ChartDateValuePair>> entry =
          chartDateValueEntries[i];

      series.add(LineSeries<ChartDateValuePair, DateTime>(
        color: CustomStyle.multiAxisLineChartSeriesColors[i],
        animationDuration: 0.0,
        name: widget.checkBoxValues[entry.key]?.name,
        dataSource: entry.value,
        xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
            chartDateValuePair.dateTime,
        yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
            chartDateValuePair.value,
      ));
    }

    return series;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          primaryYAxis: NumericAxis(),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          trackballBehavior: _trackballBehavior,
          zoomPanBehavior: _zoomPanBehavior,
          series: _buildSeries(),
        ),
      ],
    );
  }
}
