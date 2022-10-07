import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonitoringLineChart extends StatefulWidget {
  const MonitoringLineChart({
    Key? key,
    required this.chartDateValuePairs,
    required this.name,
    this.majorH,
    this.majorL,
    this.majorHAnnotationColor = Colors.red,
    this.majorLAnnotationColor = Colors.red,
  }) : super(key: key);

  final List<ChartDateValuePair> chartDateValuePairs;
  final String name;
  final double? majorH;
  final double? majorL;
  final Color? majorHAnnotationColor;
  final Color? majorLAnnotationColor;

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
      activationMode: ActivationMode.longPress,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      tooltipSettings: InteractiveTooltip(format: 'point.y ($_unit)'),
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

    if (widget.majorH != null) {
      _majorHDateValuePairs.add(ChartDateValuePair(
        dateTime: widget.chartDateValuePairs.first.dateTime,
        value: widget.majorH!,
      ));

      _majorHDateValuePairs.add(ChartDateValuePair(
        dateTime: widget.chartDateValuePairs.last.dateTime,
        value: widget.majorH!,
      ));
    }

    return _majorHDateValuePairs;
  }

  List<ChartDateValuePair> getmajorLDateValuePairs() {
    List<ChartDateValuePair> _majorLDateValuePairs = [];

    if (widget.majorL != null) {
      _majorLDateValuePairs.add(ChartDateValuePair(
        dateTime: widget.chartDateValuePairs.first.dateTime,
        value: widget.majorL!,
      ));

      _majorLDateValuePairs.add(ChartDateValuePair(
        dateTime: widget.chartDateValuePairs.last.dateTime,
        value: widget.majorL!,
      ));
    }

    return _majorLDateValuePairs;
  }

  double getMaximumYAxisValue() {
    double? majorH = widget.majorH;
    double maximumChartValue = widget.chartDateValuePairs
        .reduce((current, next) => current.value > next.value ? current : next)
        .value;
    double maximum = 0.0;

    if (majorH != null) {
      maximum = majorH >= maximumChartValue ? majorH : maximumChartValue;
    } else {
      maximum = maximumChartValue;
    }

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
    double? majorL = widget.majorL;
    double minimumChartValue = widget.chartDateValuePairs
        .reduce((current, next) => current.value < next.value ? current : next)
        .value;
    double minimum = 0.0;

    if (majorL != null) {
      minimum = majorL <= minimumChartValue ? majorL : minimumChartValue;
    } else {
      minimum = minimumChartValue;
    }

    if (minimum > 0.0) {
      minimum = minimum * 0.5;
    } else if (minimum < 0.0) {
      minimum = minimum * 1.5;
    } else {
      minimum = (minimum - 1) * 1.5;
    }
    return minimum;
  }

  List<ChartSeries> _buildChartSeries() {
    // because traceball is disable when assigning a empty majorH or majorL series
    // only assign series containing data
    // *important: assign data series first to fixed the problem that traceball sometimes does not display.
    if (widget.majorH == null && widget.majorL == null) {
      // only draw data series
      return <ChartSeries>[
        LineSeries<ChartDateValuePair, DateTime>(
          color: Colors.blue,
          dataSource: widget.chartDateValuePairs,
          xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.dateTime,
          yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.value,
        ),
      ];
    } else if (widget.majorH == null) {
      // only draw majorL and data series
      return <ChartSeries>[
        LineSeries<ChartDateValuePair, DateTime>(
          color: Colors.blue,
          dataSource: widget.chartDateValuePairs,
          xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.dateTime,
          yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.value,
        ),
        LineSeries<ChartDateValuePair, DateTime>(
          color: widget.majorLAnnotationColor,
          width: 1.0,
          dataSource: _majorLDateValuePairs,
          xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.dateTime,
          yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.value,
        ),
      ];
    } else if (widget.majorL == null) {
      // only draw majorH and data series
      return <ChartSeries>[
        LineSeries<ChartDateValuePair, DateTime>(
          color: Colors.blue,
          dataSource: widget.chartDateValuePairs,
          xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.dateTime,
          yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.value,
        ),
        LineSeries<ChartDateValuePair, DateTime>(
          color: widget.majorHAnnotationColor,
          width: 1.0,
          dataSource: _majorHDateValuePairs,
          xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.dateTime,
          yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.value,
        ),
      ];
    } else {
      //all series
      return <ChartSeries>[
        LineSeries<ChartDateValuePair, DateTime>(
          color: Colors.blue,
          dataSource: widget.chartDateValuePairs,
          xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.dateTime,
          yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.value,
        ),
        LineSeries<ChartDateValuePair, DateTime>(
          color: widget.majorHAnnotationColor,
          width: 1.0,
          dataSource: _majorHDateValuePairs,
          xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.dateTime,
          yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.value,
        ),
        LineSeries<ChartDateValuePair, DateTime>(
          color: widget.majorLAnnotationColor,
          width: 1.0,
          dataSource: _majorLDateValuePairs,
          xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.dateTime,
          yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
              chartDateValuePair.value,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
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
      trackballBehavior: _trackballBehavior,
      zoomPanBehavior: _zoomPanBehavior,
      series: _buildChartSeries(),
    );
  }
}
