import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ricoms_app/root/view/custom_style.dart';

class DeviceSettingStyle {
  static void getSettingData({
    bool isEditing = false,
    required dynamic e,
    required List<ControllerProperty> controllerProperties,
    required Map<String, String> controllerValues,
  }) {
    int style = e['style'] ?? -1;
    int length = e['length'] ?? 1;
    int height = e['height'] ?? 15;
    String value = e['value'] ?? '';
    double font = e['font'] != null ? (e['font'] as int).toDouble() : 14.0;
    int status = e['status'] ?? 0;
    String rawParameter = e['parameter'] ?? '';
    int readonly = e['readonly'] ?? 0;
    String id = e['id'] != null ? e['id'].toString() : '-1';

    bool enabled = isEditing && readonly == 0;

    switch (style) {
      case 0: //文字輸入方塊
        TextFieldProperty textFieldProperty = TextFieldProperty(
          oid: id,
          text: value,
          readOnly: enabled,
          boxLength: length,
          fontSize: font,
        );
        controllerProperties.add(textFieldProperty);
        controllerValues[id] = value;
        break;
      case 1: //下拉式功能表
        List parameter = jsonDecode(rawParameter.replaceAll('\'', '\"'));
        Map<String, String> items = <String, String>{};
        items = {for (var e in parameter) e['value']: e['text']};
        DropDownMenuProperty dropDownMenuProperty = DropDownMenuProperty(
          oid: id,
          value: value,
          items: items,
          readOnly: enabled,
          boxLength: length,
          fontSize: font,
        );

        controllerProperties.add(dropDownMenuProperty);
        controllerValues[id] = value;
        break;

      case 2: //±值功能表
        List parameter = jsonDecode(rawParameter.replaceAll('\'', '\"'));
        double max = -1;
        double min = -1;
        num interval = -1;

        for (var items in parameter) {
          min = double.parse(items['min']!);
          max = double.parse(items['max']!);
          interval = (items['interval']! as List)
              .reduce((current, next) => current < next ? current : next);
        }

        SliderProperty sliderProperty = SliderProperty(
          oid: id,
          value: value,
          min: min,
          max: max,
          interval: interval,
          readOnly: enabled,
          boxLength: length,
          fontSize: font,
        );

        controllerProperties.add(sliderProperty);
        controllerValues[id] = value;
        break;

      case 3: //單選按鈕組(radio button list)

        List parameter = jsonDecode(rawParameter.replaceAll('\'', '\"'));
        Map<String, String> items = <String, String>{};
        items = {for (var e in parameter) e['value']: e['text']};

        RadioButtonProperty radioButtonProperty = RadioButtonProperty(
          oid: id,
          value: value,
          items: items,
          readOnly: enabled,
          boxLength: length,
          fontSize: font,
        );

        controllerProperties.add(radioButtonProperty);
        controllerValues[id] = value;
        break;

      case 98: //區塊型欄位表單 (TextArea)
        TextFieldProperty textFieldProperty = TextFieldProperty(
          oid: id,
          text: value,
          readOnly: enabled,
          boxLength: length,
          fontSize: font,
          maxLine: height,
        );
        controllerProperties.add(textFieldProperty);
        controllerValues[id] = value;
        break;

      case 99: //勾選方塊
        bool initValue = value == '0' || value == "" ? false : true;
        CheckBoxProperty checkBoxProperty = CheckBoxProperty(
          oid: id,
          value: initValue,
          readOnly: enabled,
          boxLength: length,
        );
        controllerProperties.add(checkBoxProperty);
        controllerValues[id] = value;
        break;

      case 100: //文字標籤 - 白底黑字
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.black,
          boxColor: Colors.white,
          borderColor: Colors.white,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 101: //文字標籤 - 灰底白字
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.white,
          boxColor: Colors.grey,
          borderColor: Colors.grey,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 102: //文字標籤 - 白底藍字
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.blue,
          boxColor: Colors.white,
          borderColor: Colors.white,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 103: //文字標籤 - 藍底白字
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.white,
          boxColor: Colors.blue,
          borderColor: Colors.blue,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 104: //文字標籤 - 綠底白字
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.white,
          boxColor: Colors.green,
          borderColor: Colors.green,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 105: //文字標籤 - 白底綠字
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.green,
          boxColor: Colors.white,
          borderColor: Colors.white,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 106: //文字標籤 - 白底黑字 (有邊框)
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 3 ? Colors.white : Colors.black,
          boxColor: CustomStyle.statusColor[status]!,
          borderColor: Colors.black,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 107: //文字標籤 - 白底藍字 (有邊框)
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 3 ? Colors.white : Colors.blue,
          boxColor: CustomStyle.statusColor[status]!,
          borderColor: Colors.black,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 108: //文字標籤 - 白底綠字 (有邊框)
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 3 ? Colors.white : Colors.green,
          boxColor: CustomStyle.statusColor[status]!,
          borderColor: Colors.black,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 110: //文字標籤 - 白底黑字, 文字置中
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.black,
          boxColor: Colors.white,
          borderColor: Colors.white,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.center,
        );

        controllerProperties.add(textProperty);
        break;

      case 111: //文字標籤 - 灰底白字, 文字置中
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.white,
          boxColor: Colors.grey,
          borderColor: Colors.grey,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.center,
        );

        controllerProperties.add(textProperty);
        break;
      case 112: //文字標籤 - 白底藍字, 文字置中
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.blue,
          boxColor: Colors.white,
          borderColor: Colors.white,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.center,
        );

        controllerProperties.add(textProperty);
        break;

      case 113: //文字標籤 - 藍底白字, 文字置中
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.white,
          boxColor: Colors.blue,
          borderColor: Colors.blue,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.center,
        );

        controllerProperties.add(textProperty);
        break;

      case 114: //文字標籤 - 綠底白字, 文字置中
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.white,
          boxColor: Colors.green,
          borderColor: Colors.green,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.center,
        );

        controllerProperties.add(textProperty);
        break;

      case 115: //文字標籤 - 白底綠字, 文字置中
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.green,
          boxColor: Colors.white,
          borderColor: Colors.white,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.center,
        );

        controllerProperties.add(textProperty);
        break;

      case 116: //文字標籤 - 白底黑字, 文字置中 (有邊框)
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 3 ? Colors.white : Colors.black,
          boxColor: CustomStyle.statusColor[status]!,
          borderColor: Colors.black,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.center,
        );

        controllerProperties.add(textProperty);
        break;

      case 117: //文字標籤 - 白底藍字, 文字置中 (有邊框)
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 3 ? Colors.white : Colors.blue,
          boxColor: CustomStyle.statusColor[status]!,
          borderColor: Colors.black,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.center,
        );

        controllerProperties.add(textProperty);
        break;

      case 118: //文字標籤 - 白底綠字, 文字置中 (有邊框)
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 3 ? Colors.white : Colors.green,
          boxColor: CustomStyle.statusColor[status]!,
          borderColor: Colors.black,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.center,
        );

        controllerProperties.add(textProperty);
        break;

      case 120: //文字標籤 - 白底黑字, 文字靠右
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 3 ? Colors.white : Colors.black,
          boxColor: CustomStyle.statusColor[status]!,
          borderColor: Colors.white,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.centerRight,
        );

        controllerProperties.add(textProperty);
        break;

      case 121: //文字標籤 - 灰底白字, 文字靠右
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.white,
          boxColor: Colors.grey,
          borderColor: Colors.grey,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.centerRight,
        );

        controllerProperties.add(textProperty);
        break;

      case 122: //文字標籤 - 白底藍字, 文字靠右
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 3 ? Colors.white : Colors.blue,
          boxColor: CustomStyle.statusColor[status]!,
          borderColor: Colors.white,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.centerRight,
        );

        controllerProperties.add(textProperty);
        break;

      case 123: //文字標籤 - 藍底白字, 文字靠右

        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.white,
          boxColor: Colors.blue,
          borderColor: Colors.blue,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.centerRight,
        );

        controllerProperties.add(textProperty);
        break;

      case 124: //文字標籤 - 綠底白字, 文字靠右
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.white,
          boxColor: Colors.green,
          borderColor: Colors.green,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.centerRight,
        );

        controllerProperties.add(textProperty);
        break;

      case 125: //文字標籤 - 白底綠字, 文字靠右
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 3 ? Colors.white : Colors.green,
          boxColor: CustomStyle.statusColor[status]!,
          borderColor: Colors.white,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.centerRight,
        );

        controllerProperties.add(textProperty);
        break;
      case 126: //文字標籤 - 白底黑字, 文字靠右 (有邊框)
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 3 ? Colors.white : Colors.black,
          boxColor: CustomStyle.statusColor[status]!,
          borderColor: Colors.black,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.centerRight,
        );

        controllerProperties.add(textProperty);
        break;

      case 127: //文字標籤 - 白底藍字, 文字靠右 (有邊框)
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 3 ? Colors.white : Colors.blue,
          boxColor: CustomStyle.statusColor[status]!,
          borderColor: Colors.black,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.centerRight,
        );

        controllerProperties.add(textProperty);
        break;

      case 128: //文字標籤 - 白底綠字, 文字靠右 (有邊框)
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 3 ? Colors.white : Colors.green,
          boxColor: CustomStyle.statusColor[status]!,
          borderColor: Colors.black,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.centerRight,
        );

        controllerProperties.add(textProperty);
        break;

      default:
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: Colors.black,
          boxColor: Colors.white,
          borderColor: Colors.black,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.centerRight,
        );

        controllerProperties.add(textProperty);
        break;
    }
  }
}

abstract class ControllerProperty {
  const ControllerProperty();
}

class TextProperty extends ControllerProperty {
  const TextProperty({
    required this.text,
    this.textColor = Colors.black,
    this.boxColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.boxLength = 1,
    this.fontSize = 14.0,
    this.alignment = Alignment.centerLeft,
  });

  final String text;
  final Color textColor;
  final Color boxColor;
  final Color borderColor;
  final int boxLength;
  final double fontSize;
  final Alignment alignment;
}

class TextFieldProperty extends ControllerProperty {
  const TextFieldProperty({
    required this.oid,
    required this.text,
    this.readOnly = false,
    this.maxLine = 1,
    this.boxLength = 1,
    this.fontSize = 14.0,
  });

  final String oid;
  final String text;
  final bool readOnly;
  final int maxLine;
  final int boxLength;
  final double fontSize;
}

class DropDownMenuProperty extends ControllerProperty {
  const DropDownMenuProperty({
    required this.oid,
    required this.value,
    required this.items,
    this.readOnly = false,
    this.boxLength = 1,
    this.fontSize = 14.0,
  });

  final String oid;
  final String value;
  final Map<String, String> items;
  final bool readOnly;
  final int boxLength;
  final double fontSize;
}

class SliderProperty extends ControllerProperty {
  const SliderProperty({
    required this.oid,
    required this.value,
    required this.min,
    required this.max,
    required this.interval,
    this.readOnly = false,
    this.boxLength = 1,
    this.fontSize = 14.0,
  });

  final String oid;
  final String value;
  final double min;
  final double max;
  final num interval;
  final bool readOnly;
  final int boxLength;
  final double fontSize;
}

class RadioButtonProperty extends ControllerProperty {
  const RadioButtonProperty({
    required this.oid,
    required this.value,
    required this.items,
    this.readOnly = false,
    this.boxLength = 1,
    this.fontSize = 14.0,
  });

  final String oid;
  final String value;
  final Map<String, String> items;
  final bool readOnly;
  final int boxLength;
  final double fontSize;
}

class CheckBoxProperty extends ControllerProperty {
  const CheckBoxProperty({
    required this.oid,
    this.readOnly = false,
    this.boxLength = 1,
    this.value = false,
  });

  final String oid;
  final bool readOnly;
  final int boxLength;
  final bool value;
}
