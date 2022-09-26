import 'package:flutter/material.dart';
import 'dart:math';
import 'package:ricoms_app/root/view/device_monitoring_chart_form.dart';

class DeviceMonitoringChartPage extends StatelessWidget {
  const DeviceMonitoringChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlotData plotData = PlotData(
      maxY: 100,
      minY: 0,
      result: [
        for (int i = 0; i < 2; i++) ...[Random().nextDouble() * 256]
      ],
    );

    return Container(
      child: LinePlot(
        plotData: plotData,
      ),
    );
  }
}
