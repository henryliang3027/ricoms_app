import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/root_repository/device_repository.dart';

class LineSeries {
  const LineSeries({
    required this.name,
    required this.dataList,
    required this.dataMap,
    required this.startIndexes,
    required this.color,
    this.maxYAxisValue,
    this.minYAxisValue,
  });

  final String name;
  final List<ChartDateValuePair> dataList;
  final Map<DateTime, double?> dataMap;
  final List<int> startIndexes;
  final Color color;
  final double? maxYAxisValue;
  final double? minYAxisValue;
}
