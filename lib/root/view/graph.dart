import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/view/line_chart.dart';

class Graph extends StatefulWidget {
  const Graph({
    Key? key,
    required this.chartDateValuePairList,
  }) : super(key: key);

  final List<ChartDateValuePair> chartDateValuePairList;

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> with SingleTickerProviderStateMixin {
  double _maxScale = 1.0;
  int dataIndex = 0;
  bool animating = false;
  late AnimationController controller;
  late CurvedAnimation _elasticAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _elasticAnimation =
        CurvedAnimation(parent: controller, curve: const ElasticOutCurve(1.0));

    double miters = widget.chartDateValuePairList.last.point.dx;
    if (miters > 0) {
      _maxScale = max(miters / 50.0, 1.0);
    } else {
      _maxScale = 1.0;
    }

    setState(() {
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.maxFinite,
      child: AltitudeGraphView(
        widget.chartDateValuePairList,
        maxScale: _maxScale,
        animation: _elasticAnimation,
      ),
    );
  }
}
