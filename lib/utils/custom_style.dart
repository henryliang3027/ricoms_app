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

  static Map<int, Color> nodeStatusColor = {
    // node status
    0: const Color(0xff000000), //unknown
    1: const Color(0xff28a745), //normal
    2: const Color(0xffffc107), //warning
    3: const Color(0xffdc3545), //critical
    4: const Color(0xff6c757d), //offline
  };

  static Map<int, Color> severityFontColor = {
    // device severity
    0: const Color(0xffffffff), //notice
    1: const Color(0xffffffff), //normal
    2: const Color(0xff000000), //warning
    3: const Color(0xffffffff), //critical
  };

  static Map<int, Color> severityColor = {
    // device severity
    0: const Color(0xff6c757d), //notice
    1: const Color(0xff28a745), //normal
    2: const Color(0xffffc107), //warning
    3: const Color(0xffdc3545), //critical
  };

  static Map<int, Color> statusColor = {
    // for device setting status tabview
    0: const Color(0xffffffff), //notice
    1: const Color(0xffffffff), //normal
    2: const Color(0xffffc107), //warning
    3: const Color(0xffdc3545), //critical
  };

  static Map<int, Color> statusFontColor = {
    // for device setting status tabview
    0: const Color(0xff000000), //notice
    1: const Color(0xff000000), //normal
    2: const Color(0xff000000), //warning
    3: const Color(0xffffffff), //critical
  };

  static const Map<int, Icon?> typeIcon = {
    0: null, //Root
    1: Icon(
      CustomIcons.root,
      color: Color(0xff172a88),
    ), //Group
    2: Icon(
      CustomIcons.deviceSimple,
      color: Color(0xff172a88),
    ), //Device
    3: Icon(
      CustomIcons.deviceSimple,
      color: Color(0xff172a88),
    ), //A8K
    4: null, //shelf
    5: null, //slot
  };

  static List<Color> multiAxisLineChartSeriesColors = [
    const Color(0xffdc3545),
    const Color(0xffffc107),
    const Color(0xff28a745),
    const Color(0xff006cab),
  ];

  static List<Color> multiAxisLineAnnotationColors = [
    const Color(0xffffc107),
    const Color(0xffdc3545),
  ];

  static const Color customRed = Color(0xffdc3545);
  static const Color customGreen = Color(0xff28a745);

  static setSeverityColors(List<int> severityColors) {
    for (int i = 0; i < severityColors.length / 2; i++) {
      severityColor[i] = Color(severityColors[i]);
    }

    for (int i = 4; i < severityColors.length; i++) {
      severityFontColor[i - 4] = Color(severityColors[i]);
    }

    CustomStyle.statusColor[3] = Color(severityColors[3]);
    CustomStyle.statusColor[2] = Color(severityColors[2]);
    CustomStyle.statusFontColor[3] = Color(severityColors[7]);
    CustomStyle.statusFontColor[2] = Color(severityColors[6]);

    CustomStyle.multiAxisLineAnnotationColors[1] = Color(severityColors[3]);
    CustomStyle.multiAxisLineAnnotationColors[0] = Color(severityColors[2]);

    CustomStyle.nodeStatusColor[3] = Color(severityColors[3]);
    CustomStyle.nodeStatusColor[2] = Color(severityColors[2]);
    CustomStyle.nodeStatusColor[1] = Color(severityColors[1]);
  }
}
