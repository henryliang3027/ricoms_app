import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/view/monitoring_chart_style.dart';
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
  //late String _unit;

  @override
  void initState() {
    //_unit = getUnit();

    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.longPress,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      //tooltipSettings: InteractiveTooltip(format: 'point.y ($_unit)'),
    );
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      enablePinching: true,
      zoomMode: ZoomMode.x,
    );

    super.initState();
  }

  // String getUnit() {
  //   RegExp unitRegex = RegExp(r'^.*\((.*)\)$');
  //   _unit = '';
  //   if (unitRegex.hasMatch(widget.name)) {
  //     List<Match> matches = unitRegex.allMatches(widget.name).toList();
  //     _unit = matches[0][1]!;
  //   }
  //   return _unit;
  // }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
      ),
      trackballBehavior: _trackballBehavior,
      zoomPanBehavior: _zoomPanBehavior,
      series: <ChartSeries>[
        for (MapEntry<String, List<ChartDateValuePair>> entry
            in widget.chartDateValues.entries) ...[
          LineSeries<ChartDateValuePair, DateTime>(
            //color: Colors.blue,
            animationDuration: 0.0,
            name: widget.checkBoxValues[entry.key]?.name,
            dataSource: entry.value,
            xValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
                chartDateValuePair.dateTime,
            yValueMapper: (ChartDateValuePair chartDateValuePair, index) =>
                chartDateValuePair.value,
          ),
        ]
      ],
    );
    ;
  }
}
