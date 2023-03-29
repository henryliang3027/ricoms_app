import 'package:flutter/material.dart';

class Marker {
  const Marker({
    required this.value,
    required this.prefix,
    required this.color,
  });

  final double value;
  final String prefix;
  final Color color;
}
