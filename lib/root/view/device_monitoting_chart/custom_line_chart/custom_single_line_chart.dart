import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/root_repository/device_repository.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/line_chart.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/line_series.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/marker.dart';
import 'package:ricoms_app/utils/custom_style.dart';

class CustomSingleLineChart extends StatelessWidget {
  const CustomSingleLineChart({
    Key? key,
    required this.chartDateValuePairList,
    required this.name,
    this.color = Colors.blue,
    this.majorH,
    this.majorL,
    this.minorH,
    this.minorL,
  }) : super(key: key);

  final List<ChartDateValuePair> chartDateValuePairList;
  final String name;
  final Color color;
  final double? majorH;
  final double? majorL;
  final double? minorH;
  final double? minorL;

  LineSeries getLineSeries() {
    Map<DateTime, double?> dataMap = {};
    List<int> startIndexes = [];
    for (int i = 0; i < chartDateValuePairList.length; i++) {
      var chartDateValuePair = chartDateValuePairList[i];
      DateTime dateTime = chartDateValuePair.dateTime;
      double? value = chartDateValuePair.value;

      dataMap[dateTime] = value;

      if (i > 0) {
        if (value != null && chartDateValuePairList[i - 1].value == null) {
          startIndexes.add(i);
        }
      }
    }

    LineSeries lineSeries = LineSeries(
      name: name,
      dataList: chartDateValuePairList,
      dataMap: dataMap,
      startIndexes: startIndexes,
      color: color,
    );

    return lineSeries;
  }

  List<Marker> _getMarkers() {
    List<Marker> markers = [];
    if (minorH != null) {
      markers.add(Marker(
        value: minorH!,
        prefix: 'MinorHI',
        color: CustomStyle.severityColor[2]!,
      ));
    }

    if (minorL != null) {
      markers.add(Marker(
        value: minorL!,
        prefix: 'MinorLO',
        color: CustomStyle.severityColor[2]!,
      ));
    }

    if (majorH != null) {
      markers.add(Marker(
        value: majorH!,
        prefix: 'MajorHI',
        color: CustomStyle.severityColor[3]!,
      ));
    }

    if (majorL != null) {
      markers.add(Marker(
        value: majorL!,
        prefix: 'MajorLO',
        color: CustomStyle.severityColor[3]!,
      ));
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    List<LineSeries> lineSeriesCollection = [getLineSeries()];
    List<Marker> markers = _getMarkers();

    return Column(
      children: [
        LineChart(
          lineSeriesCollection: lineSeriesCollection,
          makrers: markers,
        ),
        const SizedBox(
          height: 20.0,
        ),
        lineSeriesCollection.length > 1
            ? Legend(
                lineSeriesCollection: lineSeriesCollection,
              )
            : Container(),
      ],
    );
  }
}

class Legend extends StatelessWidget {
  const Legend({Key? key, required this.lineSeriesCollection})
      : super(key: key);

  final List<LineSeries> lineSeriesCollection;

  @override
  Widget build(BuildContext context) {
    Widget buildTile({
      required String name,
      required Color color,
    }) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const SizedBox(
            width: 10.0,
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(
            width: 4.0,
          ),
          Text(
            name,
          ),
        ],
      );
    }

    Widget buildLegend() {
      return Wrap(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (LineSeries lineSeries in lineSeriesCollection) ...[
            buildTile(
              name: lineSeries.name,
              color: lineSeries.color,
            )
          ],
        ],
      );
    }

    return buildLegend();
  }
}
