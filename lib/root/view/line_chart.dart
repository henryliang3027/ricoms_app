import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonitoringLineChart extends StatefulWidget {
  const MonitoringLineChart({
    Key? key,
    required this.chartDateValuePairs,
    required this.name,
  }) : super(key: key);

  final List<ChartDateValuePair> chartDateValuePairs;
  final String name;

  @override
  State<MonitoringLineChart> createState() => _MonitoringLineChartState();
}

class _MonitoringLineChartState extends State<MonitoringLineChart> {
  late List<ChartDateValuePair> _chartData;
  late TooltipBehavior _tooltipBehavior;
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _trackballBehavior = TrackballBehavior(enable: true);
    _zoomPanBehavior =
        ZoomPanBehavior(enablePanning: true, enablePinching: true);
    super.initState();
  }

  List<ChartDateValuePair> getChartData() {
    List<ChartDateValuePair> chartData = [];

    for (ChartDateValuePair chartDateValuePair in widget.chartDateValuePairs) {
      chartData.add(ChartDateValuePair(
          dateTime: chartDateValuePair.dateTime,
          value: chartDateValuePair.value + 20));
    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(
        text: widget.name,
      ),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
      ),
      //tooltipBehavior: _tooltipBehavior,
      trackballBehavior: _trackballBehavior,
      zoomPanBehavior: _zoomPanBehavior,
      series: <ChartSeries>[
        LineSeries<ChartDateValuePair, DateTime>(
          //name: 'Sales',
          dataSource: widget.chartDateValuePairs,
          xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.dateTime,
          yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.value,
          //dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      // primaryYAxis: NumericAxis(
      //   labelFormat: '{value}dBm',
      // ),
    );
  }
}

class SalesData {
  const SalesData(this.year, this.sales);

  final double year;
  final double sales;
}
