import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/single_axis_line_chart.dart';
import 'package:ricoms_app/utils/common_style.dart';

class SingleAxisChartForm extends StatelessWidget {
  const SingleAxisChartForm({
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
  Widget build(BuildContext context) {
    Widget _buildMajorHAnnotation() {
      if (majorH != null) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 0.0),
          child: Container(
            color: majorHAnnotationColor,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: Text(
                'MajorHI : $majorH',
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
      if (majorH != null) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 0.0),
          child: Container(
            color: majorLAnnotationColor,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: Text(
                'MajorLO : $majorL',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: CommonStyle.sizeXXL,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMajorLAnnotation(),
              _buildMajorHAnnotation(),
            ],
          ),
          SingleAxisLineChart(
            chartDateValuePairs: chartDateValuePairs,
            name: name,
            majorH: majorH,
            majorL: majorL,
            majorHAnnotationColor: Colors.red,
            majorLAnnotationColor: Colors.red,
          )
        ],
      ),
    );
  }
}
