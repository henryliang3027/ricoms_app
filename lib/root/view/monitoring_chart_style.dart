import 'package:flutter/material.dart';

class MonitoringChartStyle {
  static void getChartFilterData({
    required dynamic e,
    required List<ItemProperty> itemProperties,
    required Map<String, CheckBoxValue> checkBoxValues,
  }) {
    int style = e['style'] ?? -1;
    int length = e['length'] ?? 1;
    String value = e['value'].toString();
    double font = e['font'] != null ? (e['font'] as int).toDouble() : 14.0;
    int status = e['status'] ?? 0;
    String id = e['id'] != null ? e['id'].toString() : '-1';
    double? majorH = e['MajorHI'] != null && e['MajorHI'] != 'x'
        ? double.parse(e['MajorHI'])
        : null;
    double? minorH = e['MinorHI'] != null && e['MinorHI'] != 'x'
        ? double.parse(e['MinorHI'])
        : null;
    double? majorL = e['MajorLO'] != null && e['MajorLO'] != 'x'
        ? double.parse(e['MajorLO'])
        : null;
    double? minorL = e['MinorLO'] != null && e['MinorLO'] != 'x'
        ? double.parse(e['MinorLO'])
        : null;

    switch (style) {
      case 99: //勾選方塊
        if (id != '-1') {
          TextProperty textProperty = itemProperties[0] as TextProperty;
          checkBoxValues[id] = CheckBoxValue(
            oid: id,
            name: textProperty.text,
            majorH: majorH,
            minorH: minorH,
            majorL: majorL,
            minorL: minorL,
            value: false,
          );
          CheckBoxProperty checkBoxProperty = CheckBoxProperty(
            oid: id,
            boxLength: length,
          );

          itemProperties.add(checkBoxProperty);
        }
        break;
      case 100: //文字標籤 - 白底黑字
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.black,
          boxColor: Colors.white,
          borderColor: Colors.white,
          boxLength: length,
          fontSize: font,
        );
        itemProperties.add(textProperty);
        break;
      case 103: //文字標籤 - 藍底白字
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.white,
          boxColor: Colors.blue,
          borderColor: Colors.blue,
          boxLength: length,
          fontSize: font,
        );
        itemProperties.add(textProperty);
        break;
      default:
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.black,
          boxColor: Colors.white,
          borderColor: Colors.black,
          boxLength: length,
          fontSize: font,
        );
        itemProperties.add(textProperty);
        break;
    }
  }
}

abstract class ItemProperty {
  const ItemProperty();
}

class TextProperty extends ItemProperty {
  const TextProperty({
    required this.text,
    this.textColor = Colors.black,
    this.boxColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.boxLength = 1,
    this.fontSize = 14.0,
  });

  final String text;
  final Color textColor;
  final Color boxColor;
  final Color borderColor;
  final int boxLength;
  final double fontSize;
}

class CheckBoxProperty extends ItemProperty {
  const CheckBoxProperty({
    required this.oid,
    this.boxLength = 1,
  });

  final String oid;
  final int boxLength;
}

class CheckBoxValue {
  const CheckBoxValue({
    required this.oid,
    required this.name,
    required this.value,
    this.majorH,
    this.minorH,
    this.majorL,
    this.minorL,
  });

  final String oid;
  final String name;
  final bool value;
  final double? majorH;
  final double? minorH;
  final double? majorL;
  final double? minorL;
}
