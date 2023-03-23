import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/line_series.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/marker.dart';

class MultipleYAxisLineChartPainter extends CustomPainter {
  MultipleYAxisLineChartPainter({
    required this.lineSeriesCollection,
    required this.longestLineSeries,
    required this.showTooltip,
    required this.longPressX,
    required this.leftOffset,
    required this.rightOffset,
    required this.offset,
    required this.scale,
    required this.minDate,
    required this.maxDate,
    required this.xRange,
    required this.minValues,
    required this.maxValues,
    required this.yRanges,
    required this.markers,
  });

  final List<LineSeries> lineSeriesCollection;
  final LineSeries longestLineSeries;
  final bool showTooltip;
  final double longPressX;
  double leftOffset;
  double rightOffset;
  final double offset;
  final double scale;
  final DateTime minDate;
  final DateTime maxDate;
  final double xRange;
  final List<double> minValues;
  final List<double> maxValues;
  final List<double> yRanges;
  final List<Marker> markers;

  final TextPainter _axisLabelPainter = TextPainter(
    textAlign: TextAlign.left,
    textDirection: ui.TextDirection.ltr,
  );

  final TextPainter _tipTextPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: ui.TextDirection.ltr,
  );

  final Paint _gridPaint = Paint()
    ..color = Colors.grey.withOpacity(0.4)
    ..strokeWidth = 1;

  final Paint _axisPaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 1;

  final Paint _verticalLinePaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 1.0
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  final Paint _dividerPaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 1.0
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  DateTime _findClosestPoint({
    required double x,
    required double offsetX,
    required double xStep,
  }) {
    double closestDistance = double.infinity;
    DateTime closestDateTime = DateTime.now();

    for (DateTime dateTime in longestLineSeries.dataMap.keys) {
      // because sthe start point of line series is in canvas.translate(leftOffset + offset, 0);
      // add offsetX to adjust the difference between target datetime and min datetime
      double distance =
          (dateTime.difference(minDate).inSeconds.toDouble() * xStep +
                  offsetX -
                  x)
              .abs();

      if (distance < closestDistance) {
        closestDistance = distance;
        closestDateTime = dateTime;
      }
    }

    return closestDateTime;
  }

  List<Map<String, double?>> _getValueByDateTime(DateTime dateTime) {
    List<Map<String, double?>> valueMapList = [];
    for (LineSeries lineSeries in lineSeriesCollection) {
      Map<String, double?> valueMap = {};
      valueMap[lineSeries.name] = lineSeries.dataMap[dateTime];
      valueMapList.add(valueMap);
    }
    // valueMapList = [{'name': value},{'name': value}]
    return valueMapList;
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date).toString();
  }

  // Draw X-Axis
  void _drawXAxis({
    required Canvas canvas,
    required Size size,
  }) {
    canvas.drawLine(Offset(leftOffset, size.height),
        Offset(size.width + leftOffset - rightOffset, size.height), _axisPaint);
  }

  // Draw vertical grid line and X-Axis scale points
  void _drawXAxisLabelAndVerticalGridLine({
    required Canvas canvas,
    required Size size,
    required double xStep,
  }) {
    int xScalePoints = size.width * scale ~/ 80;
    double xInterval = (longestLineSeries.dataList.length - 1) / xScalePoints;
    for (int i = 0; i < xScalePoints; i++) {
      double scaleX = (longestLineSeries
              .dataList[(i * xInterval).round()].dateTime
              .difference(minDate)
              .inSeconds
              .toDouble() *
          xStep);

      // Draw vertical grid line
      canvas.drawLine(
          Offset(scaleX, 0), Offset(scaleX, size.height), _gridPaint);

      // Draw X-Axis scale points
      DateTime dateTime =
          longestLineSeries.dataList[(i * xInterval).round()].dateTime;
      String date = DateFormat('MM/dd').format(dateTime);

      String time = DateFormat('HH:mm:ss').format(dateTime);

      _axisLabelPainter.text = TextSpan(
        text: '$date\n$time',
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      );
      _axisLabelPainter.layout();
      _axisLabelPainter.paint(canvas, Offset(scaleX, size.height));
    }
  }

  // Draw horizontal grid line and Y-axis scale points
  void _drawYAxisLabelAndHorizontalGridLine({
    required Canvas canvas,
    required Size size,
  }) {
    for (int i = 0; i < lineSeriesCollection.length; i++) {
      LineSeries lineSeries = lineSeriesCollection[i];
      leftOffset = leftOffset + 40 * i;

      // Draw Y-Axis
      canvas.drawLine(
          Offset(leftOffset, 0), Offset(leftOffset, size.height), _axisPaint);

      int yScalePoints = 5;
      double yInterval = yRanges[i] / yScalePoints;
      double yStep = size.height / yRanges[i];
      for (int j = 0; j < yScalePoints; j++) {
        double scaleY = size.height - j * yInterval * yStep;

        // Draw horizontal grid line
        if (i == lineSeriesCollection.length - 1) {
          canvas.drawLine(
              Offset(leftOffset, scaleY),
              Offset(size.width - rightOffset + leftOffset, scaleY),
              _gridPaint);
        }

        // Draw Y-axis scale points
        String label = (j * yInterval + minValues[i]).toStringAsFixed(1);
        _axisLabelPainter.text = TextSpan(
          text: label,
          style: TextStyle(
            fontSize: 12,
            color: lineSeries.color,
          ),
        );
        _axisLabelPainter.layout();
        _axisLabelPainter.paint(
            canvas,
            Offset(leftOffset - _axisLabelPainter.width - 2,
                scaleY - _axisLabelPainter.height / 2));
      }
    }
  }

  // Draw vertical track line and tip
  void _drawTrackBall({
    required Canvas canvas,
    required Size size,
    required double xStep,
  }) {
    int nonNullValueIndex = longestLineSeries.dataList
        .indexWhere((element) => element.value != null);
    // 如果 line series value 全部都是 null,就不用畫 track ball
    // 如果 至少有 value 不是 null, 就要畫
    if (nonNullValueIndex != -1) {
      double adjustedLongPressX = longPressX - leftOffset;
      longPressX.clamp(0.0, size.width - rightOffset);
      DateTime closestDateTime = _findClosestPoint(
        x: adjustedLongPressX,
        offsetX: offset,
        xStep: xStep,
      );

      // Draw vertical line at the closest point
      canvas.drawLine(
        Offset(
            (closestDateTime.difference(minDate).inSeconds.toDouble() * xStep),
            0),
        Offset(
            (closestDateTime.difference(minDate).inSeconds.toDouble() * xStep),
            size.height),
        _verticalLinePaint,
      );

      String formatDateTime = _formatDate(closestDateTime);
      List<Map<String, double?>> valueMapList =
          _getValueByDateTime(closestDateTime);

      List<String> tips = [formatDateTime];

      for (Map<String, double?> valueMap in valueMapList) {
        MapEntry nameValueEntry = valueMap.entries.toList()[0];
        if (nameValueEntry.value != null) {
          tips.add('${nameValueEntry.key} : ${nameValueEntry.value}');
        }
      }

      String longestTip = tips.reduce(
          (value, element) => value.length > element.length ? value : element);

      _tipTextPainter.text = TextSpan(
        text: longestTip,
        style: const TextStyle(
          color: Colors.black,
        ),
      );

      _tipTextPainter.layout();

      double rectWidth = _tipTextPainter.width;

      double textX =
          (closestDateTime.difference(minDate).inSeconds.toDouble() * xStep) +
              10;
      double textY = size.height / 2 - (14.0 * (tips.length + 1) + 4) / 2;

      double outOfBoundWidth =
          (textX - 4) + (rectWidth + 16) - (size.width - rightOffset) + offset;
      double adjustedTextX = outOfBoundWidth > 0 ? outOfBoundWidth : 0;
      Rect rect1 = Rect.fromLTWH(
        textX - 4 - adjustedTextX,
        textY,
        rectWidth + 16,
        12.0 * (tips.length + 1) +
            4, // +1 for the date time string at the first row
      );
      Paint rectPaint = Paint()..color = Colors.white;
      RRect rRect = RRect.fromRectAndRadius(rect1, const Radius.circular(4));
      canvas.drawRRect(rRect, rectPaint);

      _tipTextPainter.text = TextSpan(
        text: tips[0],
        style: const TextStyle(
          color: Colors.black,
        ),
      );
      _tipTextPainter.layout();

      _tipTextPainter.paint(canvas, Offset(textX - adjustedTextX, textY));

      canvas.drawLine(
          Offset(textX - adjustedTextX, textY + 18),
          Offset(textX - adjustedTextX - 8 + rectWidth + 16, textY + 18),
          _dividerPaint);

      textY = textY + 2;

      for (int i = 1; i < tips.length; i++) {
        Paint circlePaint = Paint()..color = lineSeriesCollection[i - 1].color;
        Offset center = Offset(textX + 4 - adjustedTextX, textY + 13 * (i + 1));
        double radius = 4;
        canvas.drawCircle(center, radius, circlePaint);

        _tipTextPainter.text = TextSpan(
          text: tips[i],
          style: const TextStyle(
            color: Colors.black,
          ),
        );
        _tipTextPainter.layout();

        _tipTextPainter.paint(
            canvas,
            Offset(textX - adjustedTextX + 10,
                (textY + 13 * (i + 1)) - _tipTextPainter.height / 2));
      }
    }
  }

  void _drawLineSeries({
    required Canvas canvas,
    required Size size,
    required double xStep,
  }) {
    for (int i = 0; i < lineSeriesCollection.length; i++) {
      List<ChartDateValuePair> data = lineSeriesCollection[i].dataList;
      if (data.isNotEmpty) {
        List<int> startIndex = lineSeriesCollection[i].startIndexes;
        double yStep = size.height / yRanges[i];
        Path linePath = Path();

        Paint linePaint = Paint()
          ..color = lineSeriesCollection[i].color
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

        // 找到第一個 value 不是 null 的 index
        int firstIndex = data.indexWhere((element) => element.value != null);
        if (firstIndex != -1) {
          // line series value 不是全部都是 null, 至少有一個 value 不是null
          for (int j = firstIndex; j < data.length - 1; j++) {
            double currentScaleX =
                (data[j].dateTime.difference(minDate).inSeconds * xStep);
            double? currentScaleY = data[j].value == null
                ? null
                : (maxValues[i] - data[j].value!) * yStep;

            if (currentScaleY != null) {
              if (j == firstIndex) {
                linePath.moveTo(currentScaleX, currentScaleY);
              }

              // if previous index of value is null, Do not draw line near the point
              if (startIndex.contains(j)) {
                linePath.moveTo(currentScaleX, currentScaleY);
              } else {
                linePath.lineTo(currentScaleX, currentScaleY);
              }
            }
          }

          canvas.drawPath(linePath, linePaint);
        }
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawYAxisLabelAndHorizontalGridLine(
      canvas: canvas,
      size: size,
    );

    // Draw X-axis line
    _drawXAxis(
      canvas: canvas,
      size: size,
    );

    canvas.clipRect(Rect.fromPoints(Offset(leftOffset, 0),
        Offset(size.width + leftOffset - rightOffset + 1, size.height + 40)));

    canvas.translate(leftOffset + offset, 0);

    double xStep = (size.width * scale - rightOffset) / xRange;

    _drawXAxisLabelAndVerticalGridLine(
      canvas: canvas,
      size: size,
      xStep: xStep,
    );

    _drawLineSeries(
      canvas: canvas,
      size: size,
      xStep: xStep,
    );

    if (showTooltip) {
      _drawTrackBall(
        canvas: canvas,
        size: size,
        xStep: xStep,
      );
    }
  }

  @override
  bool shouldRepaint(MultipleYAxisLineChartPainter oldDelegate) {
    return oldDelegate.showTooltip != showTooltip ||
        oldDelegate.longPressX != longPressX ||
        oldDelegate.scale != scale ||
        oldDelegate.offset != offset;
  }
}
