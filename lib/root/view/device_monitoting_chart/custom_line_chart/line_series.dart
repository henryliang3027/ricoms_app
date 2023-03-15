import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/device_repository.dart';

class LineSeries {
  const LineSeries({
    required this.name,
    required this.dataList,
    required this.dataMap,
    required this.startIndexes,
    required this.color,
  });

  final String name;
  final List<ChartDateValuePair> dataList;
  final Map<DateTime, double?> dataMap;
  final List<int> startIndexes;
  final Color color;
}
