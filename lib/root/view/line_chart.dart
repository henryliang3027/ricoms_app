import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonitoringLineChart extends StatefulWidget {
  const MonitoringLineChart({
    Key? key,
    required this.chartDateValuePairs,
    required this.name,
    required this.majorH,
    required this.majorL,
  }) : super(key: key);

  final List<ChartDateValuePair> chartDateValuePairs;
  final String name;
  final double majorH;
  final double majorL;

  @override
  State<MonitoringLineChart> createState() => _MonitoringLineChartState();
}

class _MonitoringLineChartState extends State<MonitoringLineChart> {
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  late String _unit;

  late List<ChartDateValuePair> _majorHDateValuePairs;
  late List<ChartDateValuePair> _majorLDateValuePairs;

  @override
  void initState() {
    _unit = getUnit();
    _majorHDateValuePairs = getmajorHDateValuePairs();
    _majorLDateValuePairs = getmajorLDateValuePairs();
    _trackballBehavior = TrackballBehavior(
      enable: true,
      tooltipSettings: InteractiveTooltip(format: 'point.x : point.y ($_unit)'),
    );
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      enablePinching: true,
      zoomMode: ZoomMode.x,
    );

    super.initState();
  }

  String getUnit() {
    RegExp unitRegex = RegExp(r'^.*\((.*)\)$');
    _unit = '';
    if (unitRegex.hasMatch(widget.name)) {
      List<Match> matches = unitRegex.allMatches(widget.name).toList();
      _unit = matches[0][1]!;
    }
    return _unit;
  }

  List<ChartDateValuePair> getmajorHDateValuePairs() {
    List<ChartDateValuePair> _majorHDateValuePairs = [];

    _majorHDateValuePairs.add(ChartDateValuePair(
      dateTime: widget.chartDateValuePairs.first.dateTime,
      value: widget.majorH,
    ));

    _majorHDateValuePairs.add(ChartDateValuePair(
      dateTime: widget.chartDateValuePairs.last.dateTime,
      value: widget.majorH,
    ));

    return _majorHDateValuePairs;
  }

  List<ChartDateValuePair> getmajorLDateValuePairs() {
    List<ChartDateValuePair> _majorLDateValuePairs = [];

    _majorLDateValuePairs.add(ChartDateValuePair(
      dateTime: widget.chartDateValuePairs.first.dateTime,
      value: widget.majorL,
    ));

    _majorLDateValuePairs.add(ChartDateValuePair(
      dateTime: widget.chartDateValuePairs.last.dateTime,
      value: widget.majorL,
    ));

    return _majorLDateValuePairs;
  }

  double getMaximumYAxisValue() {
    double majorH = widget.majorH;
    double maximumChartValue = widget.chartDateValuePairs
        .reduce((current, next) => current.value > next.value ? current : next)
        .value;
    double maximum = majorH >= maximumChartValue ? majorH : maximumChartValue;
    if (maximum > 0.0) {
      maximum = maximum * 1.5;
    } else if (maximum < 0.0) {
      maximum = maximum * 0.5;
    } else {
      maximum = (maximum + 1) * 1.5;
    }
    return maximum;
  }

  double getMinimumYAxisValue() {
    double majorL = widget.majorL;
    double minimumChartValue = widget.chartDateValuePairs
        .reduce((current, next) => current.value < next.value ? current : next)
        .value;
    double minimum = majorL <= minimumChartValue ? majorL : minimumChartValue;
    if (minimum > 0.0) {
      minimum = minimum * 0.5;
    } else if (minimum < 0.0) {
      minimum = minimum * 1.5;
    } else {
      minimum = (minimum - 1) * 1.5;
    }
    return minimum;
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(
        text: widget.name,
      ),
      // legend: Legend(
      //   isVisible: true,
      //   position: LegendPosition.bottom,
      // ),
      primaryXAxis: DateTimeAxis(
        name: 'primaryX',
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        name: 'primaryY',
        maximum: getMaximumYAxisValue(),
        minimum: getMinimumYAxisValue(),
      ),
      // annotations: <CartesianChartAnnotation>[
      //   CartesianChartAnnotation(
      //     yAxisName: 'primaryY',
      //     widget: Container(
      //       child: const Text(
      //         'major',
      //       ),
      //     ),
      //     coordinateUnit: CoordinateUnit.point,
      //     region: AnnotationRegion.chart,
      //     x: widget.chartDateValuePairs.last.dateTime.microsecondsSinceEpoch
      //         .toDouble(),
      //     y: 38,
      //   )
      // ],

      trackballBehavior: _trackballBehavior,
      zoomPanBehavior: _zoomPanBehavior,
      series: <ChartSeries>[
        LineSeries<ChartDateValuePair, DateTime>(
          yAxisName: 'primaryY',
          color: Colors.red,
          width: 1.0,
          dataSource: _majorHDateValuePairs,
          xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.dateTime,
          yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.value,
          dataLabelSettings:
              DataLabelSettings(isVisible: true, useSeriesColor: true),
        ),
        LineSeries<ChartDateValuePair, DateTime>(
          color: Colors.red,
          width: 1.0,
          dataSource: _majorLDateValuePairs,
          xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.dateTime,
          yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.value,
          dataLabelSettings:
              DataLabelSettings(isVisible: true, useSeriesColor: true),
        ),
        LineSeries<ChartDateValuePair, DateTime>(
          color: Colors.blue,
          dataSource: widget.chartDateValuePairs,
          xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.dateTime,
          yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.value,
        ),
      ],
    );
  }
}
