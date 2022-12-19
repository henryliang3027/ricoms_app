import 'package:flutter/material.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';

class CustomStyle {
  static const Map<int, String> severityName = {
    // device severity
    0: 'Notice', //notice
    1: 'Normal', //normal
    2: 'Warning', //warning
    3: 'Critical', //critical
  };

  static const Map<int, Color> severityFontColor = {
    // device severity
    0: Colors.white, //notice
    1: Colors.white, //normal
    2: Colors.black, //warning
    3: Colors.white, //critical
  };

  static const Map<int, Color> severityColor = {
    // device severity
    0: Color(0xff6c757d), //notice
    1: Color(0xff28a745), //normal
    2: Color(0xffffc107), //warning
    3: Color(0xffdc3545), //critical
  };

  static const Map<int, Color> statusColor = {
    // for device setting status tabview
    0: Colors.white, //notice
    1: Colors.white, //normal
    2: Color(0xffffc107), //warning
    3: Color(0xffdc3545), //critical
  };

  static const Map<int, Icon?> typeIcon = {
    0: null, //Root
    1: Icon(
      CustomIcons.root,
      color: Color(0xff172a88),
    ), //Group
    2: Icon(
      CustomIcons.device_simple,
      color: Color(0xff172a88),
    ), //Device
    3: Icon(
      CustomIcons.device_simple,
      color: Color(0xff172a88),
    ), //A8K
    4: null, //shelf
    5: null, //slot
  };

  static const List<Color> multiAxisLineChartSeriesColors = [
    Color(0xffdc3545),
    Color(0xffffc107),
    Color(0xff28a745),
    Color(0xff006cab),
  ];
}
