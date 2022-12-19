import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/monitoring_chart_style.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MultipleAxisLineChart extends StatefulWidget {
  const MultipleAxisLineChart({
    Key? key,
    required this.nodeName,
    required this.chartDateValues,
    required this.checkBoxValues,
  }) : super(key: key);

  final String nodeName;
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

  double getMaximumYAxisValue() {
    double maximum = -double.maxFinite;

    for (List<ChartDateValuePair> chartDateValuePairs
        in widget.chartDateValues.values) {
      double max = chartDateValuePairs
          .reduce(
              (current, next) => current.value > next.value ? current : next)
          .value;

      maximum = maximum < max ? max : maximum;
    }

    if (maximum > 0.0) {
      maximum = maximum * 1.5;
    } else if (maximum < 0.0) {
      maximum = maximum / 1.5;
    } else {
      maximum = (maximum + 10) * 1.5;
    }
    return maximum;
  }

  double getMinimumYAxisValue() {
    double minimum = double.maxFinite;

    for (List<ChartDateValuePair> chartDateValuePairs
        in widget.chartDateValues.values) {
      double min = chartDateValuePairs
          .reduce(
              (current, next) => current.value < next.value ? current : next)
          .value;

      minimum = minimum > min ? min : minimum;
    }

    if (minimum > 0.0) {
      minimum = minimum * 0.5;
    } else if (minimum < 0.0) {
      minimum = minimum / 0.5;
    } else {
      minimum = (minimum - 10) / 0.5;
    }
    return minimum;
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
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        maximum: getMaximumYAxisValue(),
        minimum: getMinimumYAxisValue(),
      ),
      legend: Legend(
        isVisible: true,
        width: '10000%', // take all screen width
        position: LegendPosition.bottom,
      ),
      trackballBehavior: _trackballBehavior,
      zoomPanBehavior: _zoomPanBehavior,
      onTrackballPositionChanging: (args) {
        String dateString = DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(args.chartPointInfo.chartDataPoint!.x);

        args.chartPointInfo.header = dateString;
      },
      series: _buildSeries(),
    );
  }
}
