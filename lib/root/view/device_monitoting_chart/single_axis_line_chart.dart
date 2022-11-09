import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart_filter/chart_filter_bloc.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SingleAxisLineChart extends StatefulWidget {
  const SingleAxisLineChart({
    Key? key,
    required this.chartDateValuePairs,
    required this.name,
    this.majorH,
    this.majorL,
    this.minorH,
    this.minorL,
  }) : super(key: key);

  final List<ChartDateValuePair> chartDateValuePairs;
  final String name;
  final double? majorH;
  final double? majorL;
  final double? minorH;
  final double? minorL;

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
    double majorH = widget.majorH ?? -double.maxFinite;
    double majorL = widget.majorL ?? -double.maxFinite;
    double minorH = widget.minorH ?? -double.maxFinite;
    double minorL = widget.minorL ?? -double.maxFinite;
    double maximumChartValue = widget.chartDateValuePairs
        .reduce((current, next) => current.value > next.value ? current : next)
        .value;
    double maximum = 0.0;

    maximum = [majorH, majorL, minorH, minorL, maximumChartValue]
        .reduce((current, next) => current > next ? current : next);

    return maximum;
  }

  double getMinimumDataValue() {
    double majorH = widget.majorH ?? double.maxFinite;
    double majorL = widget.majorL ?? double.maxFinite;
    double minorH = widget.minorH ?? double.maxFinite;
    double minorL = widget.minorL ?? double.maxFinite;
    double minimumChartValue = widget.chartDateValuePairs
        .reduce((current, next) => current.value < next.value ? current : next)
        .value;
    double minimum = 0.0;

    minimum = [majorH, majorL, minorH, minorL, minimumChartValue]
        .reduce((current, next) => current < next ? current : next);

    return minimum;
  }

  double getMaximumYAxisValue() {
    double maximumYAxisValue = 0.0;
    int factor = _maximumDataValue.toString().replaceFirst('-', '').length - 2;

    if ((_maximumDataValue - _minimumDataValue).abs() >= 100) {
      if (factor == 1) {
        maximumYAxisValue = _maximumDataValue + 100 * (factor + 2);
      } else {
        maximumYAxisValue = _maximumDataValue + 100 * factor;
      }
    } else {
      maximumYAxisValue = _maximumDataValue + 10 * factor;
    }

    return maximumYAxisValue;
  }

  double getMinimumYAxisValue() {
    double minimumYAxisValue = 0.0;
    int factor = _minimumDataValue.toString().replaceFirst('-', '').length - 2;

    if ((_maximumDataValue - _minimumDataValue).abs() >= 100) {
      if (factor == 1) {
        minimumYAxisValue = _minimumDataValue - 100 * (factor + 2);
      } else {
        minimumYAxisValue = _minimumDataValue - 100 * factor;
      }
    } else {
      minimumYAxisValue = _minimumDataValue - 10 * factor;
    }

    return minimumYAxisValue;
  }

  List<PlotBand> _buildPlotBand() {
    List<PlotBand> plodBands = [];

    if (widget.minorH != null) {
      plodBands.add(PlotBand(
        text: 'MinorHI: ${widget.minorH.toString()}',
        textStyle: TextStyle(
          color: CustomStyle.severityFontColor[2],
          backgroundColor: CustomStyle.severityColor[2]!,
        ),
        horizontalTextAlignment: TextAnchor.end,
        verticalTextAlignment: TextAnchor.start,
        start: widget.minorH,
        end: widget.minorH,
        borderWidth: 1,
        borderColor: CustomStyle.severityColor[2]!,
      ));
    }

    if (widget.minorL != null) {
      plodBands.add(PlotBand(
        text: 'MinorLO: ${widget.minorL.toString()}',
        textStyle: TextStyle(
          color: CustomStyle.severityFontColor[2],
          backgroundColor: CustomStyle.severityColor[2]!,
        ),
        horizontalTextAlignment: TextAnchor.end,
        start: widget.minorL,
        end: widget.minorL,
        borderWidth: 1,
        borderColor: CustomStyle.severityColor[2]!,
      ));
    }

    if (widget.majorH != null) {
      plodBands.add(PlotBand(
        text: 'MajorHI: ${widget.majorH.toString()}',
        textStyle: TextStyle(
          color: CustomStyle.severityFontColor[3],
          backgroundColor: CustomStyle.severityColor[3]!,
        ),
        horizontalTextAlignment: TextAnchor.end,
        start: widget.majorH,
        end: widget.majorH,
        borderWidth: 1,
        borderColor: CustomStyle.severityColor[3]!,
      ));
    }

    if (widget.majorL != null) {
      plodBands.add(PlotBand(
        text: 'MajorLO: ${widget.majorL.toString()}',
        textStyle: TextStyle(
          color: CustomStyle.severityFontColor[3],
          backgroundColor: CustomStyle.severityColor[3]!,
        ),
        horizontalTextAlignment: TextAnchor.end,
        verticalTextAlignment: TextAnchor.start,
        start: widget.majorL,
        end: widget.majorL,
        borderWidth: 1,
        borderColor: CustomStyle.severityColor[3]!,
      ));
    }

    return plodBands;
  }

  SfCartesianChart _buildChart() {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        maximum: _maximumYAxisValue,
        minimum: _minimumYAxisValue,
        plotBands: _buildPlotBand(),
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
