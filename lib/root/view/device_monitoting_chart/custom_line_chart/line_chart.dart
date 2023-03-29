import 'package:flutter/material.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/single_y_axis_line_chart_painter.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/line_series.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/marker.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/multiple_y_axis_line_chart_painter.dart';

class LineChart extends StatefulWidget {
  final List<LineSeries> lineSeriesCollection;
  final List<Marker> makrers;
  final bool showMultipleYAxis;

  const LineChart({
    Key? key,
    required this.lineSeriesCollection,
    this.makrers = const [],
    this.showMultipleYAxis = false,
  }) : super(key: key);

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

  // multiple Y-axis
  final List<double> _yRanges = [];
  final List<double> _minValues = [];
  final List<double> _maxValues = [];

  double _focalPointX = 0.0;
  double _lastUpdateFocalPointX = 0.0;
  double _deltaFocalPointX = 0.0;
  late final LineSeries _longestLineSeries;

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

  void setMinValueAndMaxValue() {
    List<LineSeries> lineSeriesCollection = widget.lineSeriesCollection;

    List<double?> allValues = lineSeriesCollection
        .expand((lineSeries) => lineSeries.dataMap.values)
        .toList();

    allValues.removeWhere((element) => element == null);

    List<double?> allNonNullValues = [];
    allNonNullValues.addAll(allValues);

    double tempMinValue = 0.0;
    double tempMaxValue = 0.0;

    if (allNonNullValues.isNotEmpty) {
      tempMinValue = allNonNullValues
          .map((value) => value)
          .reduce((value, element) => value! < element! ? value : element)!;

      tempMaxValue = allNonNullValues
          .map((value) => value)
          .reduce((value, element) => value! > element! ? value : element)!;
    }

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
  }

  void setMinValueAndMaxValueForMultipleYAxis() {
    List<LineSeries> lineSeriesCollection = widget.lineSeriesCollection;
    for (LineSeries lineSeries in lineSeriesCollection) {
      List<double?> allValues = lineSeries.dataMap.values.toList();

      allValues.removeWhere((element) => element == null);

      double tempMinValue = 0.0;
      double tempMaxValue = 0.0;

      tempMinValue = allValues
          .map((value) => value)
          .reduce((value, element) => value! < element! ? value : element)!;

      tempMaxValue = allValues
          .map((value) => value)
          .reduce((value, element) => value! > element! ? value : element)!;

      if (lineSeries.minYAxisValue != null) {
        tempMinValue = tempMinValue < lineSeries.minYAxisValue!
            ? tempMinValue
            : lineSeries.minYAxisValue!;
      }

      if (lineSeries.maxYAxisValue != null) {
        tempMaxValue = tempMaxValue > lineSeries.maxYAxisValue!
            ? tempMaxValue
            : lineSeries.maxYAxisValue!;
      }

      double minValue = getMinimumYAxisValue(
        tempMaxValue: tempMaxValue,
        tempMinValue: tempMinValue,
      );
      double maxValue = getMaximumYAxisValue(
        tempMaxValue: tempMaxValue,
        tempMinValue: tempMinValue,
      );

      _minValues.add(minValue);
      _maxValues.add(maxValue);
    }
  }

  void setMinDateAndMaxDate() {
    List<LineSeries> lineSeriesCollection = widget.lineSeriesCollection;
    List<DateTime> allDateTimes = lineSeriesCollection
        .expand((lineSeries) => lineSeries.dataMap.keys)
        .toList();
    _minDate = allDateTimes
        .map((dateTime) => dateTime)
        .reduce((value, element) => value.isBefore(element) ? value : element);
    _maxDate = allDateTimes
        .map((dateTime) => dateTime)
        .reduce((value, element) => value.isAfter(element) ? value : element);
  }

  void setXRangeAndYRange() {
    _xRange = _maxDate.difference(_minDate).inSeconds.toDouble();
    _yRange = _maxValue - _minValue;
  }

  void setXRangeAndYRangeForMultipleYAxis() {
    _xRange = _maxDate.difference(_minDate).inSeconds.toDouble();

    for (int i = 0; i < widget.lineSeriesCollection.length; i++) {
      double yRanges = _maxValues[i] - _minValues[i];
      _yRanges.add(yRanges);
    }
  }

  @override
  void initState() {
    super.initState();
    List<LineSeries> lineSeriesCollection = widget.lineSeriesCollection;
    _longestLineSeries = lineSeriesCollection
        .map((lineSeries) => lineSeries)
        .reduce((value, element) =>
            value.dataMap.length > element.dataMap.length ? value : element);

    if (widget.showMultipleYAxis) {
      setMinValueAndMaxValueForMultipleYAxis();
      setMinDateAndMaxDate();
      setXRangeAndYRangeForMultipleYAxis();
    } else {
      setMinValueAndMaxValue();
      setMinDateAndMaxDate();
      setXRangeAndYRange();
    }
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
          _longPressX = details.localPosition.dx;
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
          _longPressX = details.localPosition.dx;
        });
      },
      onVerticalDragStart: (_) {
        // Disable the scrolling if parent widget has ListView

        bool? hasClient = PrimaryScrollController.of(context)?.hasClients;

        if (hasClient != null) {
          if (hasClient) {
            PrimaryScrollController.of(context)!.position.hold(() {});
          }
        }
      },
      child: CustomPaint(
        size: Size(
          widgetWidth,
          widgetHeight,
        ),
        painter: widget.showMultipleYAxis
            ? MultipleYAxisLineChartPainter(
                lineSeriesCollection: widget.lineSeriesCollection,
                longestLineSeries: _longestLineSeries,
                showTooltip: _showTooltip,
                longPressX: _longPressX,
                leftOffset: _leftOffset,
                rightOffset: _rightOffset +
                    (widget.lineSeriesCollection.length - 1) *
                        40, //根據y-axis軸的數量調整右邊的邊界
                offset: _offset,
                scale: _scale,
                minDate: _minDate,
                maxDate: _maxDate,
                xRange: _xRange,
                minValues: _minValues,
                maxValues: _maxValues,
                yRanges: _yRanges,
                markers: widget.makrers,
              )
            : SingleYAxisLineChartPainter(
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
                yRanges: _yRanges,
                markers: widget.makrers,
                showMultipleYAxis: widget.showMultipleYAxis,
              ),
      ),
    );
  }
}
