import 'package:flutter/material.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/line_chart_painter.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/line_series.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/marker.dart';

class LineChart extends StatefulWidget {
  final List<LineSeries> lineSeriesCollection;
  final List<Marker> makrers;

  const LineChart(
      {Key? key, required this.lineSeriesCollection, this.makrers = const []})
      : super(key: key);

  @override
  LineChartState createState() => LineChartState();
}

class LineChartState extends State<LineChart> {
  bool _showTooltip = false;

  double _longPressX = 0.0;
  final double _leftOffset = 40;
  final double _rightOffset = 60;

  double _offset = 0.0;
  double _scale = 1.0;
  double _lastScaleValue = 1.0;

  double _minValue = 0.0;
  double _maxValue = 0.0;
  DateTime _minDate = DateTime.now();
  DateTime _maxDate = DateTime.now();
  double _xRange = 0.0;
  double _yRange = 0.0;

  double _focalPointX = 0.0;
  double _lastUpdateFocalPointX = 0.0;
  double _deltaFocalPointX = 0.0;
  late final LineSeries _longestLineSeries;

  @override
  void initState() {
    super.initState();
    List<LineSeries> lineSeriesCollection = widget.lineSeriesCollection;

    List<double?> allValues = lineSeriesCollection
        .expand((lineSeries) => lineSeries.dataMap.values)
        .toList();

    allValues.removeWhere((element) => element == null);

    List<double?> allNonNullValues = [];
    allNonNullValues.addAll(allValues);

    List<DateTime> allDateTimes = lineSeriesCollection
        .expand((lineSeries) => lineSeries.dataMap.keys)
        .toList();

    double tempMinValue = 0.0;
    double tempMaxValue = 0.0;

    tempMinValue = allNonNullValues
        .map((value) => value)
        .reduce((value, element) => value! < element! ? value : element)!;

    tempMaxValue = allNonNullValues
        .map((value) => value)
        .reduce((value, element) => value! > element! ? value : element)!;

    if (widget.makrers.isNotEmpty) {
      List<double> markerValues = [];

      for (Marker marker in widget.makrers) {
        markerValues.add(marker.value);
      }

      tempMinValue = [tempMinValue, ...markerValues]
          .map((value) => value)
          .reduce((value, element) => value < element ? value : element);

      tempMaxValue = [tempMaxValue, ...markerValues]
          .map((value) => value)
          .reduce((value, element) => value > element ? value : element);
    }

    _minValue = getMinimumYAxisValue(
      tempMaxValue: tempMaxValue,
      tempMinValue: tempMinValue,
    );
    _maxValue = getMaximumYAxisValue(
      tempMaxValue: tempMaxValue,
      tempMinValue: tempMinValue,
    );

    _minDate = allDateTimes
        .map((dateTime) => dateTime)
        .reduce((value, element) => value.isBefore(element) ? value : element);
    _maxDate = allDateTimes
        .map((dateTime) => dateTime)
        .reduce((value, element) => value.isAfter(element) ? value : element);

    _xRange = _maxDate.difference(_minDate).inSeconds.toDouble();
    _yRange = _maxValue - _minValue;

    _longestLineSeries = lineSeriesCollection
        .map((lineSeries) => lineSeries)
        .reduce((value, element) =>
            value.dataMap.length > element.dataMap.length ? value : element);
  }

  double getMaximumYAxisValue(
      {required double tempMaxValue, required double tempMinValue}) {
    double maximumYAxisValue = 0.0;

    // in case of negative value
    // -2 is to remove decimal point and any following digit
    int factor = tempMaxValue.toString().replaceFirst('-', '').length - 2;

    if ((tempMaxValue - tempMinValue).abs() >= 1000) {
      maximumYAxisValue = tempMaxValue + 100 * (factor + 10);
    } else if ((tempMaxValue - tempMinValue).abs() >= 100) {
      maximumYAxisValue = tempMaxValue + 100 * (factor + 2);
    } else if ((tempMaxValue - tempMinValue).abs() >= 10) {
      maximumYAxisValue = tempMaxValue + 10 * factor;
    } else {
      maximumYAxisValue = tempMaxValue + (factor + 1);
    }

    return maximumYAxisValue;
  }

  double getMinimumYAxisValue(
      {required double tempMaxValue, required double tempMinValue}) {
    double minimumYAxisValue = 0.0;

    // in case of negative values
    // -2 is to remove decimal point and any following digit
    int factor = tempMinValue.toString().replaceFirst('-', '').length - 2;

    if ((tempMaxValue - tempMinValue).abs() >= 1000) {
      minimumYAxisValue = tempMinValue - 100 * (factor + 10);
    } else if ((tempMaxValue - tempMinValue).abs() >= 100) {
      minimumYAxisValue = tempMinValue - 100 * (factor + 2);
    } else if ((tempMaxValue - tempMinValue).abs() >= 10) {
      minimumYAxisValue = tempMinValue - 10 * factor;
    } else {
      minimumYAxisValue = tempMinValue - (factor + 1);
    }

    return minimumYAxisValue;
  }

  @override
  Widget build(BuildContext context) {
    double widgetWidth = MediaQuery.of(context).size.width;
    double widgetHeight = 200;

    double calculateOffsetX(
      double newScale,
      double focusOnScreen,
    ) {
      double ratioInGraph =
          (_offset.abs() + focusOnScreen) / (_scale * widgetWidth);

      double newTotalWidth = newScale * widgetWidth;

      double newLocationInGraph = ratioInGraph * newTotalWidth;

      return focusOnScreen - newLocationInGraph;
    }

    updateScaleAndScrolling(double newScale, double focusX,
        {double extraX = 0.0}) {
      var widgetWidth = context.size!.width;

      newScale = newScale.clamp(1.0, 100.0);

      // 根据缩放焦点计算出left
      double left = calculateOffsetX(newScale, focusX);

      // 加上额外的水平偏移量
      left += extraX;

      // 将x范围限制图表宽度内
      double newOffsetX = left.clamp((newScale - 1) * -widgetWidth, 0.0);

      setState(() {
        _scale = newScale;
        _offset = newOffsetX;
      });
    }

    return GestureDetector(
      onScaleStart: (details) {
        _focalPointX = details.focalPoint.dx;
        _lastScaleValue = _scale;
        _lastUpdateFocalPointX = details.focalPoint.dx;
      },
      onScaleUpdate: (details) {
        double newScale = (_lastScaleValue * details.scale);

        _deltaFocalPointX = (details.focalPoint.dx - _lastUpdateFocalPointX);
        _lastUpdateFocalPointX = details.focalPoint.dx;

        updateScaleAndScrolling(newScale, _focalPointX,
            extraX: _deltaFocalPointX);
      },
      onScaleEnd: (details) {},
      onLongPressMoveUpdate: (details) {
        setState(() {
          _longPressX = details.localPosition.dx - _leftOffset;
        });
      },
      onLongPressEnd: (details) {
        setState(() {
          _showTooltip = false;
        });
      },
      onLongPressStart: (details) {
        setState(() {
          _showTooltip = true;
          _longPressX = details.localPosition.dx - _leftOffset;
        });
      },
      onVerticalDragStart: (_) {
        // Disable the scrolling of the ListView
        PrimaryScrollController.of(context)?.position.hold(() {});
      },
      child: CustomPaint(
        size: Size(
          widgetWidth,
          widgetHeight,
        ),
        painter: LineChartPainter(
          lineSeriesCollection: widget.lineSeriesCollection,
          longestLineSeries: _longestLineSeries,
          showTooltip: _showTooltip,
          longPressX: _longPressX,
          leftOffset: _leftOffset,
          rightOffset: _rightOffset,
          offset: _offset,
          scale: _scale,
          minValue: _minValue,
          maxValue: _maxValue,
          minDate: _minDate,
          maxDate: _maxDate,
          xRange: _xRange,
          yRange: _yRange,
          markers: widget.makrers,
        ),
      ),
    );
  }
}
