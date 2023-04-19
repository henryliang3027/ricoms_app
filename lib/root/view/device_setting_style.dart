import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ricoms_app/root/models/custom_input.dart';
import 'package:ricoms_app/utils/custom_style.dart';

class DeviceSettingStyle {
  Color _getStatusColor({
    required int status,
    required Color defaultColor,
  }) {
    if (status == 1) {
      return defaultColor;
    } else {
      return CustomStyle.statusColor[status] ?? defaultColor;
    }
  }

  static void getSettingData({
    required dynamic e,
    required List<ControllerProperty> controllerProperties,
    required Map<String, dynamic> controllerValues,
    required Map<String, dynamic> controllerInitialValues,
  }) {
    int style = e['style'] ?? -1;
    int length = e['length'] ?? 1;
    int height = e['height'] ?? 15;
    String value = e['value'] ?? '';
    double font = e['font'] != null ? (e['font'] as int).toDouble() : 14.0;
    int status = e['status'] ?? 0;
    int? format = e['format'];
    String rawParameter = (e['parameter'] ?? '').toString();
    int rawReadOnly = e['readonly'] ?? 0;
    String id = e['id'] != null ? e['id'].toString() : '-1';

    bool readOnly = rawReadOnly == 0 ? false : true;

    switch (style) {
      case 0: //文字輸入方塊
        int? maxLength;
        CustomInput customInput;
        if (format == 1) {
          maxLength = 6;
          customInput = Input6.dirty(value);
        } else if (format == 2) {
          maxLength = 7;
          customInput = Input7.dirty(value);
        } else if (format == 3) {
          maxLength = 8;
          customInput = Input8.dirty(value);
        } else if (format == 4) {
          maxLength = 32;
          customInput = Input31.dirty(value);
        } else if (format == 5) {
          maxLength = 64;
          customInput = Input63.dirty(value);
        } else if (format == 6) {
          maxLength = 1024;
          customInput = InputInfinity.dirty(value);
        } else if (format == 11) {
          maxLength = 15;
          customInput = IPv4.dirty(value);
        } else if (format == 12) {
          maxLength = 23;
          customInput = IPv6.dirty(value);
        } else {
          maxLength = null;
          customInput = InputInfinity.dirty(value);
        }

        TextFieldProperty textFieldProperty = TextFieldProperty(
          oid: id,
          initValue: value,
          readOnly: readOnly,
          boxLength: length,
          fontSize: font,
          maxLength: maxLength,
        );
        controllerProperties.add(textFieldProperty);

        controllerValues[id] = customInput;
        controllerInitialValues[id] = customInput;

        break;
      case 1: //下拉式功能表
        List parameter = jsonDecode(rawParameter.replaceAll('\'', '\"'));
        Map<String, String> items = <String, String>{};
        items = {for (var e in parameter) e['value']: e['text']};
        DropDownMenuProperty dropDownMenuProperty = DropDownMenuProperty(
          oid: id,
          initValue: value,
          items: items,
          readOnly: readOnly,
          boxLength: length,
          fontSize: font,
        );

        controllerProperties.add(dropDownMenuProperty);
        controllerValues[id] = value;
        controllerInitialValues[id] = value;
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
          initValue: value,
          min: min,
          max: max,
          interval: interval,
          readOnly: readOnly,
          boxLength: length,
          fontSize: font,
        );

        controllerProperties.add(sliderProperty);
        controllerValues[id] = value;
        controllerInitialValues[id] = value;
        break;

      case 3: //單選按鈕組(radio button list)

        List parameter = jsonDecode(rawParameter.replaceAll('\'', '\"'));
        Map<String, String> items = <String, String>{};
        items = {for (var e in parameter) e['value']: e['text']};

        RadioButtonProperty radioButtonProperty = RadioButtonProperty(
          oid: id,
          initValue: value,
          items: items,
          readOnly: readOnly,
          boxLength: length,
          fontSize: font,
        );

        controllerProperties.add(radioButtonProperty);
        controllerValues[id] = value;
        controllerInitialValues[id] = value;
        break;

      case 98: //區塊型欄位表單 (TextArea)
        TextFieldProperty textFieldProperty = TextFieldProperty(
          oid: id,
          initValue: value,
          readOnly: readOnly,
          boxLength: length,
          fontSize: font,
          maxLine: height,
          textAlign: TextAlign.left,
        );
        controllerProperties.add(textFieldProperty);

        controllerValues[id] = value;
        controllerInitialValues[id] = value;

        break;

      case 99: //勾選方塊
        bool? initValue = value == ""
            ? null
            : value == '0'
                ? false
                : true;
        CheckBoxProperty checkBoxProperty = CheckBoxProperty(
          oid: id,
          initValue: initValue,
          readOnly: readOnly,
          boxLength: length,
        );
        controllerProperties.add(checkBoxProperty);
        controllerValues[id] = value;
        controllerInitialValues[id] = value;
        break;

      case 100: //文字標籤 - 白底黑字
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.black
              : CustomStyle.statusFontColor[status] ?? Colors.black,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          borderColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 101: //文字標籤 - 灰底白字
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.white
              : CustomStyle.statusFontColor[status] ?? Colors.white,
          boxColor: status == 1
              ? Colors.grey
              : CustomStyle.statusColor[status] ?? Colors.grey,
          borderColor: status == 1
              ? Colors.grey
              : CustomStyle.statusColor[status] ?? Colors.grey,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 102: //文字標籤 - 白底藍字
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.blue
              : CustomStyle.statusFontColor[status] ?? Colors.blue,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          borderColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 103: //文字標籤 - 藍底白字
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.white
              : CustomStyle.statusFontColor[status] ?? Colors.white,
          boxColor: status == 1
              ? Colors.blue
              : CustomStyle.statusColor[status] ?? Colors.blue,
          borderColor: status == 1
              ? Colors.blue
              : CustomStyle.statusColor[status] ?? Colors.blue,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 104: //文字標籤 - 綠底白字
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.white
              : CustomStyle.statusFontColor[status] ?? Colors.white,
          boxColor: status == 1
              ? Colors.green
              : CustomStyle.statusColor[status] ?? Colors.green,
          borderColor: status == 1
              ? Colors.green
              : CustomStyle.statusColor[status] ?? Colors.green,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 105: //文字標籤 - 白底綠字
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.green
              : CustomStyle.statusFontColor[status] ?? Colors.green,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          borderColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 106: //文字標籤 - 白底黑字 (有邊框)
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.black
              : CustomStyle.statusFontColor[status] ?? Colors.black,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          borderColor: Colors.black,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 107: //文字標籤 - 白底藍字 (有邊框)
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.blue
              : CustomStyle.statusFontColor[status] ?? Colors.blue,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          borderColor: Colors.black,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 108: //文字標籤 - 白底綠字 (有邊框)
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.green
              : CustomStyle.statusFontColor[status] ?? Colors.green,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          borderColor: Colors.black,
          fontSize: font,
          boxLength: length,
        );

        controllerProperties.add(textProperty);
        break;

      case 110: //文字標籤 - 白底黑字, 文字置中
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.black
              : CustomStyle.statusFontColor[status] ?? Colors.black,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          borderColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.center,
        );

        controllerProperties.add(textProperty);
        break;

      case 111: //文字標籤 - 灰底白字, 文字置中
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.white
              : CustomStyle.statusFontColor[status] ?? Colors.white,
          boxColor: status == 1
              ? Colors.grey
              : CustomStyle.statusColor[status] ?? Colors.grey,
          borderColor: status == 1
              ? Colors.grey
              : CustomStyle.statusColor[status] ?? Colors.grey,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.center,
        );

        controllerProperties.add(textProperty);
        break;
      case 112: //文字標籤 - 白底藍字, 文字置中
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.blue
              : CustomStyle.statusFontColor[status] ?? Colors.blue,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          borderColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.center,
        );

        controllerProperties.add(textProperty);
        break;

      case 113: //文字標籤 - 藍底白字, 文字置中
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.white
              : CustomStyle.statusFontColor[status] ?? Colors.white,
          boxColor: status == 1
              ? Colors.blue
              : CustomStyle.statusColor[status] ?? Colors.blue,
          borderColor: status == 1
              ? Colors.blue
              : CustomStyle.statusColor[status] ?? Colors.blue,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.center,
        );

        controllerProperties.add(textProperty);
        break;

      case 114: //文字標籤 - 綠底白字, 文字置中
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.white
              : CustomStyle.statusFontColor[status] ?? Colors.white,
          boxColor: status == 1
              ? Colors.green
              : CustomStyle.statusColor[status] ?? Colors.green,
          borderColor: status == 1
              ? Colors.green
              : CustomStyle.statusColor[status] ?? Colors.green,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.center,
        );

        controllerProperties.add(textProperty);
        break;

      case 115: //文字標籤 - 白底綠字, 文字置中
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.green
              : CustomStyle.statusFontColor[status] ?? Colors.green,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          borderColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.center,
        );

        controllerProperties.add(textProperty);
        break;

      case 116: //文字標籤 - 白底黑字, 文字置中 (有邊框)
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.black
              : CustomStyle.statusFontColor[status] ?? Colors.black,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
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
          textColor: status == 1
              ? Colors.blue
              : CustomStyle.statusFontColor[status] ?? Colors.blue,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
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
          textColor: status == 1
              ? Colors.green
              : CustomStyle.statusFontColor[status] ?? Colors.green,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
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
          textColor: status == 1
              ? Colors.black
              : CustomStyle.statusFontColor[status] ?? Colors.black,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          borderColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.centerRight,
        );

        controllerProperties.add(textProperty);
        break;

      case 121: //文字標籤 - 灰底白字, 文字靠右
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.white
              : CustomStyle.statusFontColor[status] ?? Colors.white,
          boxColor: status == 1
              ? Colors.grey
              : CustomStyle.statusColor[status] ?? Colors.grey,
          borderColor: status == 1
              ? Colors.grey
              : CustomStyle.statusColor[status] ?? Colors.grey,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.centerRight,
        );

        controllerProperties.add(textProperty);
        break;

      case 122: //文字標籤 - 白底藍字, 文字靠右
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.blue
              : CustomStyle.statusFontColor[status] ?? Colors.blue,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          borderColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.centerRight,
        );

        controllerProperties.add(textProperty);
        break;

      case 123: //文字標籤 - 藍底白字, 文字靠右

        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.white
              : CustomStyle.statusFontColor[status] ?? Colors.white,
          boxColor: status == 1
              ? Colors.blue
              : CustomStyle.statusColor[status] ?? Colors.blue,
          borderColor: status == 1
              ? Colors.blue
              : CustomStyle.statusColor[status] ?? Colors.blue,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.centerRight,
        );

        controllerProperties.add(textProperty);
        break;

      case 124: //文字標籤 - 綠底白字, 文字靠右
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.white
              : CustomStyle.statusFontColor[status] ?? Colors.white,
          boxColor: status == 1
              ? Colors.green
              : CustomStyle.statusColor[status] ?? Colors.green,
          borderColor: status == 1
              ? Colors.green
              : CustomStyle.statusColor[status] ?? Colors.green,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.centerRight,
        );

        controllerProperties.add(textProperty);
        break;

      case 125: //文字標籤 - 白底綠字, 文字靠右
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.green
              : CustomStyle.statusFontColor[status] ?? Colors.green,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          borderColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
          fontSize: font,
          boxLength: length,
          alignment: Alignment.centerRight,
        );

        controllerProperties.add(textProperty);
        break;
      case 126: //文字標籤 - 白底黑字, 文字靠右 (有邊框)
        TextProperty textProperty = TextProperty(
          text: value,
          textColor: status == 1
              ? Colors.black
              : CustomStyle.statusFontColor[status] ?? Colors.black,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
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
          textColor: status == 1
              ? Colors.blue
              : CustomStyle.statusFontColor[status] ?? Colors.blue,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
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
          textColor: status == 1
              ? Colors.green
              : CustomStyle.statusFontColor[status] ?? Colors.green,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
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
          textColor: status == 1
              ? Colors.black
              : CustomStyle.statusFontColor[status] ?? Colors.black,
          boxColor: status == 1
              ? Colors.white
              : CustomStyle.statusColor[status] ?? Colors.white,
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
    required this.initValue,
    this.readOnly = false,
    this.maxLine = 1,
    this.boxLength = 1,
    this.maxLength,
    this.fontSize = 14.0,
    this.textAlign = TextAlign.center,
  });

  final String oid;
  final String initValue;
  final bool readOnly;
  final int maxLine;
  final int? maxLength;
  final int boxLength;
  final double fontSize;
  final TextAlign textAlign;
}

class DropDownMenuProperty extends ControllerProperty {
  const DropDownMenuProperty({
    required this.oid,
    required this.initValue,
    required this.items,
    this.readOnly = false,
    this.boxLength = 1,
    this.fontSize = 14.0,
  });

  final String oid;
  final String initValue;
  final Map<String, String> items;
  final bool readOnly;
  final int boxLength;
  final double fontSize;
}

class SliderProperty extends ControllerProperty {
  const SliderProperty({
    required this.oid,
    required this.initValue,
    required this.min,
    required this.max,
    required this.interval,
    this.readOnly = false,
    this.boxLength = 1,
    this.fontSize = 14.0,
  });

  final String oid;
  final String initValue;
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
    required this.initValue,
    required this.items,
    this.readOnly = false,
    this.boxLength = 1,
    this.fontSize = 14.0,
  });

  final String oid;
  final String initValue;
  final Map<String, String> items;
  final bool readOnly;
  final int boxLength;
  final double fontSize;
}

class CheckBoxProperty extends ControllerProperty {
  const CheckBoxProperty({
    required this.oid,
    required this.initValue,
    this.readOnly = false,
    this.boxLength = 1,
  });

  final String oid;
  final bool? initValue;
  final bool readOnly;
  final int boxLength;
}
