import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/line_chart.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/line_series.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/monitoring_chart_style.dart';

class CustomMultipleLineChart extends StatelessWidget {
  const CustomMultipleLineChart({
    Key? key,
    required this.chartDateValuePairListMap,
    required this.selectedCheckBoxValuesMap,
    this.colors = const [
      Colors.red,
      Colors.orange,
    ],
    this.showMultipleYAxis = false,
  }) : super(key: key);

  final Map<String, List<ChartDateValuePair>> chartDateValuePairListMap;
  final Map<String, CheckBoxValue> selectedCheckBoxValuesMap;
  final List<Color> colors;
  final showMultipleYAxis;

  List<LineSeries> getLineSeriesCollection() {
    List<LineSeries> lineSeriesCollection = [];

    List<List<ChartDateValuePair>> chartDateValuePairListCollection =
        chartDateValuePairListMap.values.toList();
    List<CheckBoxValue> checkBoxValues =
        selectedCheckBoxValuesMap.values.toList();

    for (int i = 0; i < chartDateValuePairListCollection.length; i++) {
      List<ChartDateValuePair> chartDateValuePairList =
          chartDateValuePairListCollection[i];
      Map<DateTime, double?> dataMap = {};
      List<int> startIndexes = [];
      for (int j = 0; j < chartDateValuePairList.length; j++) {
        ChartDateValuePair chartDateValuePair = chartDateValuePairList[j];
        DateTime dateTime = chartDateValuePair.dateTime;
        double? value = chartDateValuePair.value;

        dataMap[dateTime] = value;

        if (j > 0) {
          if (value != null && chartDateValuePairList[j - 1].value == null) {
            startIndexes.add(i);
          }
        }
      }

      LineSeries lineSeries = LineSeries(
        name: checkBoxValues[i].name,
        dataList: chartDateValuePairListCollection[i],
        dataMap: dataMap,
        startIndexes: startIndexes,
        color: colors[i],
        maxYAxisValue: checkBoxValues[i].majorH ?? checkBoxValues[i].minorH,
        minYAxisValue: checkBoxValues[i].majorL ?? checkBoxValues[i].minorL,
      );

      lineSeriesCollection.add(lineSeries);
    }

    return lineSeriesCollection;
  }

  @override
  Widget build(BuildContext context) {
    List<LineSeries> lineSeriesCollection = getLineSeriesCollection();

    return Column(
      children: [
        LineChart(
          lineSeriesCollection: lineSeriesCollection,
          showMultipleYAxis: showMultipleYAxis,
        ),
        const SizedBox(
          height: 40.0,
        ),
        Legend(
          lineSeriesCollection: lineSeriesCollection,
        )
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
