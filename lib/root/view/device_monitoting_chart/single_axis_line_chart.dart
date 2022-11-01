import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart_filter/chart_filter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SingleAxisLineChart extends StatefulWidget {
  const SingleAxisLineChart({
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
  State<SingleAxisLineChart> createState() => _SingleAxisLineChartState();
}

class _SingleAxisLineChartState extends State<SingleAxisLineChart> {
  // late ChartSeriesController _chartSeriesController;
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  late String _unit;

  bool isLoadTime = true;
  Offset? pointLocationL = Offset.zero;
  Offset? pointLocationH = Offset.zero;
  double _maximumYAxisValue = 0.0;
  double _minimumYAxisValue = 0.0;
  double _maximumDataValue = 0.0;
  double _minimumDataValue = 0.0;

  @override
  void initState() {
    _unit = getUnit();
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

    _maximumDataValue = getMaximumDataValue();
    _minimumDataValue = getMinimumDataValue();
    _maximumYAxisValue = getMaximumYAxisValue();
    _minimumYAxisValue = getMinimumYAxisValue();

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

  double getMaximumDataValue() {
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

    return maximum;
  }

  double getMinimumDataValue() {
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

    return minimum;
  }

  double getMaximumYAxisValue() {
    double maximumYAxisValue = 0.0;
    int factor = _maximumDataValue.toString().replaceFirst('-', '').length - 2;

    if ((_maximumDataValue - _minimumDataValue).abs() >= 100) {
      maximumYAxisValue = _maximumDataValue + 100 * factor;
    } else {
      maximumYAxisValue = _maximumDataValue + 10 * factor;
    }

    return maximumYAxisValue;
  }

  double getMinimumYAxisValue() {
    double minimumYAxisValue = 0.0;
    int factor = _minimumDataValue.toString().replaceFirst('-', '').length - 2;

    if ((_maximumDataValue - _minimumDataValue).abs() >= 100) {
      minimumYAxisValue = _minimumDataValue - 100 * factor;
    } else {
      minimumYAxisValue = _minimumDataValue - 10 * factor;
    }

    return minimumYAxisValue;
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
              '${widget.majorH}',
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
              '${widget.majorL}',
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
          maximum: _maximumYAxisValue,
          minimum: _minimumYAxisValue,
        ),
        trackballBehavior: _trackballBehavior,
        zoomPanBehavior: _zoomPanBehavior,
        series: <ChartSeries>[
          LineSeries<ChartDateValuePair, DateTime>(
            color: Colors.blue,
            animationDuration: 0.0,
            dataSource: widget.chartDateValuePairs,
            xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
                chartDateValuePair.dateTime,
            yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
                chartDateValuePair.value,
          ),
        ],
        onTrackballPositionChanging: (args) {
          String dateString = DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(args.chartPointInfo.chartDataPoint!.x);

          args.chartPointInfo.header = dateString;
        },
      );
    } else if (widget.majorH == null) {
      // only draw majorL and data series

      // SchedulerBinding.instance.addPostFrameCallback((_) {
      //   if (isLoadTime) {
      //     final CartesianChartPoint<dynamic> chartPointL =
      //         CartesianChartPoint<dynamic>(
      //       widget.chartDateValuePairs.last.dateTime.millisecondsSinceEpoch,
      //       widget.majorL,
      //     );
      //     // Calculated the pixel values of chartPoint
      //     pointLocationL = _chartSeriesController?.pointToPixel(chartPointL);

      //     setState(() {
      //       isLoadTime = false;
      //     });
      //   }
      // });

      return SfCartesianChart(
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
        ),
        primaryYAxis: NumericAxis(
          maximum: _maximumYAxisValue,
          minimum: _minimumYAxisValue,
          plotBands: <PlotBand>[
            PlotBand(
              text: 'MajorLO: ${widget.majorL.toString()} ',
              textStyle: const TextStyle(
                color: Colors.white,
                backgroundColor: Colors.red,
              ),
              horizontalTextAlignment: TextAnchor.end,
              verticalTextAlignment: TextAnchor.start,
              start: widget.majorL,
              end: widget.majorL,
              borderWidth: 1,
              borderColor: Colors.red,
            ),
          ],
        ),
        trackballBehavior: _trackballBehavior,
        zoomPanBehavior: _zoomPanBehavior,
        annotations: <CartesianChartAnnotation>[
          CartesianChartAnnotation(
            widget: _buildMajorLAnnotation(),
            coordinateUnit: CoordinateUnit.logicalPixel,
            x: pointLocationL!.dx,
            y: pointLocationL!.dy,
            horizontalAlignment: ChartAlignment.far,
          ),
        ],
        series: <ChartSeries>[
          LineSeries<ChartDateValuePair, DateTime>(
            color: Colors.blue,
            animationDuration: 0.0,
            dataSource: widget.chartDateValuePairs,
            xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
                chartDateValuePair.dateTime,
            yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
                chartDateValuePair.value,
            // onRendererCreated: (ChartSeriesController controller) {
            //   _chartSeriesController = controller;
            // },
          ),
        ],
        onTrackballPositionChanging: (args) {
          String dateString = DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(args.chartPointInfo.chartDataPoint!.x);

          args.chartPointInfo.header = dateString;
        },
      );
    } else if (widget.majorL == null) {
      // only draw majorH and data series

      // SchedulerBinding.instance.addPostFrameCallback((_) {
      //   if (isLoadTime) {
      //     final CartesianChartPoint<dynamic> chartPointH =
      //         CartesianChartPoint<dynamic>(
      //       widget.chartDateValuePairs.last.dateTime.millisecondsSinceEpoch,
      //       widget.majorH,
      //     );
      //     // Calculated the pixel values of chartPoint
      //     pointLocationH = _chartSeriesController?.pointToPixel(chartPointH);

      //     setState(() {
      //       isLoadTime = false;
      //     });
      //   }
      // });

      return SfCartesianChart(
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
        ),
        primaryYAxis: NumericAxis(
          maximum: _maximumYAxisValue,
          minimum: _minimumYAxisValue,
          plotBands: <PlotBand>[
            PlotBand(
              text: 'MajorHI: ${widget.majorH.toString()} ',
              textStyle: const TextStyle(
                color: Colors.white,
                backgroundColor: Colors.red,
              ),
              horizontalTextAlignment: TextAnchor.end,
              start: widget.majorH,
              end: widget.majorH,
              borderWidth: 1,
              borderColor: Colors.red,
            ),
          ],
        ),
        trackballBehavior: _trackballBehavior,
        zoomPanBehavior: _zoomPanBehavior,
        annotations: <CartesianChartAnnotation>[
          CartesianChartAnnotation(
            widget: _buildMajorHAnnotation(),
            coordinateUnit: CoordinateUnit.point,
            x: pointLocationH!.dx,
            y: pointLocationH!.dy,
            horizontalAlignment: ChartAlignment.far,
          ),
        ],
        series: <ChartSeries>[
          LineSeries<ChartDateValuePair, DateTime>(
            color: Colors.blue,
            animationDuration: 0.0,
            dataSource: widget.chartDateValuePairs,
            xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
                chartDateValuePair.dateTime,
            yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
                chartDateValuePair.value,
            // onRendererCreated: (ChartSeriesController controller) {
            //   _chartSeriesController = controller;
            // },
          ),
        ],
        onTrackballPositionChanging: (args) {
          String dateString = DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(args.chartPointInfo.chartDataPoint!.x);

          args.chartPointInfo.header = dateString;
        },
      );
    } else {
      //all series

      // SchedulerBinding.instance.addPostFrameCallback((_) {
      //   if (isLoadTime) {
      //     final CartesianChartPoint<dynamic> chartPointL =
      //         CartesianChartPoint<dynamic>(
      //       widget.chartDateValuePairs.last.dateTime.millisecondsSinceEpoch,
      //       widget.majorL,
      //     );
      //     // Calculated the pixel values of chartPoint
      //     pointLocationL = _chartSeriesController?.pointToPixel(chartPointL);

      //     final CartesianChartPoint<dynamic> chartPointH =
      //         CartesianChartPoint<dynamic>(
      //       widget.chartDateValuePairs.last.dateTime.millisecondsSinceEpoch,
      //       widget.majorH,
      //     );
      //     // Calculated the pixel values of chartPoint
      //     pointLocationH = _chartSeriesController?.pointToPixel(chartPointH);

      //     setState(() {
      //       isLoadTime = false;
      //     });
      //   }
      // });

      return SfCartesianChart(
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
        ),
        primaryYAxis: NumericAxis(
          maximum: _maximumYAxisValue,
          minimum: _minimumYAxisValue,
          plotBands: <PlotBand>[
            PlotBand(
              text: 'MajorHI: ${widget.majorH.toString()}',
              textStyle: const TextStyle(
                color: Colors.white,
                backgroundColor: Colors.red,
              ),
              horizontalTextAlignment: TextAnchor.end,
              start: widget.majorH,
              end: widget.majorH,
              borderWidth: 1,
              borderColor: Colors.red,
            ),
            PlotBand(
              text: 'MajorLO: ${widget.majorL.toString()}',
              textStyle: const TextStyle(
                color: Colors.white,
                backgroundColor: Colors.red,
              ),
              horizontalTextAlignment: TextAnchor.end,
              verticalTextAlignment: TextAnchor.start,
              start: widget.majorL,
              end: widget.majorL,
              borderWidth: 1,
              borderColor: Colors.red,
            ),
          ],
        ),
        trackballBehavior: _trackballBehavior,
        zoomPanBehavior: _zoomPanBehavior,
        annotations: <CartesianChartAnnotation>[
          CartesianChartAnnotation(
            widget: _buildMajorHAnnotation(),
            coordinateUnit: CoordinateUnit.logicalPixel,
            x: pointLocationH!.dx,
            y: pointLocationH!.dy - 15,
            horizontalAlignment: ChartAlignment.far,
          ),
          CartesianChartAnnotation(
            widget: _buildMajorLAnnotation(),
            coordinateUnit: CoordinateUnit.logicalPixel,
            x: pointLocationL!.dx,
            y: pointLocationL!.dy + 8,
            horizontalAlignment: ChartAlignment.far,
          ),
        ],
        series: <ChartSeries>[
          LineSeries<ChartDateValuePair, DateTime>(
            color: Colors.blue,
            animationDuration: 0.0,
            dataSource: widget.chartDateValuePairs,
            xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
                chartDateValuePair.dateTime,
            yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
                chartDateValuePair.value,
            // onRendererCreated: (ChartSeriesController controller) {
            //   _chartSeriesController = controller;
            // },
          ),
        ],
        onTrackballPositionChanging: (args) {
          String dateString = DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(args.chartPointInfo.chartDataPoint!.x);

          args.chartPointInfo.header = dateString;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
        buildWhen: (previous, current) =>
            previous.checkBoxValues != current.checkBoxValues,
        builder: (context, state) {
          return _buildChart();
        });
  }
}
