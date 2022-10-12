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

  Widget _buildMajorHAnnotation() {
    if (widget.majorH != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 0.0),
        child: Container(
          color: widget.majorHAnnotationColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: Text(
              'MajorHI : ${widget.majorH}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildMajorLAnnotation() {
    if (widget.majorL != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 0.0),
        child: Container(
          color: widget.majorLAnnotationColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: Text(
              'MajorLO : ${widget.majorL}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  SfCartesianChart _buildChart() {
    if (widget.majorH == null && widget.majorL == null) {
      // only draw data series
      return SfCartesianChart(
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
        ),
        primaryYAxis: NumericAxis(
          maximum: getMaximumYAxisValue(),
          minimum: getMinimumYAxisValue(),
        ),
        trackballBehavior: _trackballBehavior,
        zoomPanBehavior: _zoomPanBehavior,
        series: <ChartSeries>[
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
    } else if (widget.majorH == null) {
      // only draw majorL and data series
      return SfCartesianChart(
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
        ),
        primaryYAxis: NumericAxis(
          maximum: getMaximumYAxisValue(),
          minimum: getMinimumYAxisValue(),
          plotBands: <PlotBand>[
            PlotBand(
              start: widget.majorL,
              end: widget.majorL,
              borderWidth: 1,
              borderColor: Colors.red,
            ),
          ],
        ),
        trackballBehavior: _trackballBehavior,
        zoomPanBehavior: _zoomPanBehavior,
        // annotations: <CartesianChartAnnotation>[
        //   CartesianChartAnnotation(
        //     widget: _buildMajorLAnnotation(),
        //     coordinateUnit: CoordinateUnit.point,
        //     x: widget.chartDateValuePairs.last.dateTime,
        //     y: widget.majorL,
        //     horizontalAlignment: ChartAlignment.far,
        //   ),
        // ],
        series: <ChartSeries>[
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
    } else if (widget.majorL == null) {
      // only draw majorH and data series
      return SfCartesianChart(
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
        ),
        primaryYAxis: NumericAxis(
          maximum: getMaximumYAxisValue(),
          minimum: getMinimumYAxisValue(),
          plotBands: <PlotBand>[
            PlotBand(
              start: widget.majorH,
              end: widget.majorH,
              borderWidth: 1,
              borderColor: Colors.red,
            ),
          ],
        ),
        trackballBehavior: _trackballBehavior,
        zoomPanBehavior: _zoomPanBehavior,
        // annotations: <CartesianChartAnnotation>[
        //   CartesianChartAnnotation(
        //     widget: _buildMajorHAnnotation(),
        //     coordinateUnit: CoordinateUnit.point,
        //     x: widget.chartDateValuePairs.last.dateTime,
        //     y: widget.majorH,
        //     horizontalAlignment: ChartAlignment.far,
        //   ),
        // ],
        series: <ChartSeries>[
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
    } else {
      //all series
      return SfCartesianChart(
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
        ),
        primaryYAxis: NumericAxis(
          maximum: getMaximumYAxisValue(),
          minimum: getMinimumYAxisValue(),
          plotBands: <PlotBand>[
            PlotBand(
              start: widget.majorH,
              end: widget.majorH,
              borderWidth: 1,
              borderColor: Colors.red,
            ),
            PlotBand(
              start: widget.majorL,
              end: widget.majorL,
              borderWidth: 1,
              borderColor: Colors.red,
            ),
          ],
        ),
        trackballBehavior: _trackballBehavior,
        zoomPanBehavior: _zoomPanBehavior,
        // annotations: <CartesianChartAnnotation>[
        //   CartesianChartAnnotation(
        //     widget: _buildMajorHAnnotation(),
        //     coordinateUnit: CoordinateUnit.point,
        //     x: widget.chartDateValuePairs.last.dateTime,
        //     y: widget.majorH,
        //     horizontalAlignment: ChartAlignment.far,
        //   ),
        //   CartesianChartAnnotation(
        //     widget: _buildMajorLAnnotation(),
        //     coordinateUnit: CoordinateUnit.point,
        //     x: widget.chartDateValuePairs.last.dateTime,
        //     y: widget.majorL,
        //     horizontalAlignment: ChartAlignment.far,
        //   ),
        // ],
        series: <ChartSeries>[
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

  @override
  Widget build(BuildContext context) {
    return _buildChart();
  }
}
