import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PlotData {
  List<double> result;
  double maxY;
  double minY;
  PlotData({
    required this.result,
    required this.maxY,
    required this.minY,
  });
}

class LinePlot extends StatefulWidget {
  final PlotData plotData;
  const LinePlot({
    required this.plotData,
    Key? key,
  }) : super(key: key);

  @override
  _LinePlotState createState() => _LinePlotState();
}

class _LinePlotState extends State<LinePlot> {
  late double minX;
  late double maxX;
  late double scaleFactor = 1.0;
  late double baseScaleFactor = 1.0;

  @override
  void initState() {
    super.initState();
    minX = 0;
    maxX = widget.plotData.result.length.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (signal) {
        if (signal is PointerScrollEvent) {
          setState(() {
            if (signal.scrollDelta.dy.isNegative) {
              minX += maxX * 0.05;
              maxX -= maxX * 0.05;
            } else {
              minX -= maxX * 0.05;
              maxX += maxX * 0.05;
            }
          });
        }
      },
      child: GestureDetector(
        onDoubleTap: () {
          setState(() {
            minX = 0;
            maxX = widget.plotData.result.length.toDouble();
          });
        },
        onScaleStart: (details) {
          baseScaleFactor = scaleFactor;
        },
        onScaleUpdate: (details) {
          scaleFactor = baseScaleFactor * details.scale;
          setState(() {
            print(
                'minX: ' + minX.toString() + ' ' + 'maxX: ' + maxX.toString());
            print(details.verticalScale);
            // if (details.verticalScale.isNegative) {
            //   minX += maxX * scaleFactor;
            //   maxX -= maxX * scaleFactor;
            // } else {
            //   minX -= maxX * scaleFactor;
            //   maxX += maxX * scaleFactor;
            // }
          });
        },
        // onHorizontalDragUpdate: (dragUpdDet) {
        //   setState(() {
        //     print(dragUpdDet.primaryDelta);
        //     double primDelta = dragUpdDet.primaryDelta ?? 0.0;
        //     if (primDelta != 0) {
        //       if (primDelta.isNegative) {
        //         minX += maxX * 0.005;
        //         maxX += maxX * 0.005;
        //       } else {
        //         minX -= maxX * 0.005;
        //         maxX -= maxX * 0.005;
        //       }
        //     }
        //   });
        // },
        child: LineChart(
          LineChartData(
            minX: minX,
            maxX: maxX,
            maxY: widget.plotData.maxY + widget.plotData.maxY * 0.1,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: widget.plotData.result.length / 10,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  //margin: 5,
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  //margin: 5,
                ),
              ),
            ),
            gridData: FlGridData(
              drawHorizontalLine: false,
            ),
            clipData: FlClipData.all(),
            lineBarsData: [
              LineChartBarData(
                barWidth: 1,
                dotData: FlDotData(
                  show: false,
                ),
                spots: widget.plotData.result
                    .asMap()
                    .entries
                    .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
