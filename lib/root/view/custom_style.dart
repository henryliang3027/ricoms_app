import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';

class CustomStyle {
  static Widget getBox(
    int style,
    dynamic e, {
    bool isEditing = false,
    Map<String, bool>? checkBoxValues,
    Map<String, TextEditingController>? textFieldControllers,
    Map<String, String>? radioButtonValues,
    Map<String, String>? sliderValues,
    Map<String, String>? dropDownMenuValues,
    Map<String, String>? controllerInitValues,
  }) {
    int length = e['length'] ?? 1;
    int height = e['height'] ?? 15;
    String value = e['value'] ?? '';
    double font = e['font'] != null ? (e['font'] as int).toDouble() : 14.0;
    int status = e['status'] ?? 0;
    String parameter = e['parameter'] ?? '';
    int readonly = e['readonly'] ?? 0;
    String id = e['id'] != null ? e['id'].toString() : '-1';

    switch (style) {
      case 0: //文字輸入方塊
        if (textFieldControllers != null) {
          if (textFieldControllers[id] == null) {
            //avoid assigning initvalue when setstate
            textFieldControllers[id] = TextEditingController()..text = value;
            if (controllerInitValues != null) {
              controllerInitValues[id] = value;
            }
          }

          bool _enabled = isEditing && readonly == 0;
          return Expanded(
            flex: length,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Container(
                child: TextField(
                  key: Key(id),
                  controller: textFieldControllers[id],
                  textAlign: TextAlign.center,
                  enabled: _enabled,
                  style: TextStyle(fontSize: font),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _enabled ? Colors.white : Colors.grey.shade300,
                    //isDense: true,
                    //contentPadding: EdgeInsets.all(0.0),
                    isCollapsed: true,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.zero,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.zero,
                    ),
                    disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Text("textFieldControllers not provided");
        }

      case 1: //下拉式功能表
        if (dropDownMenuValues != null) {
          //replace ' with " to make json decode work

          List _parameter = jsonDecode(parameter.replaceAll('\'', '\"'));
          Map<String, String> _groupValue = <String, String>{};
          _groupValue = {for (var e in _parameter) e['value']: e['text']};
          //print(_groupValue);

          if (dropDownMenuValues[id] == null) {
            //avoid assigning initvalue when setstate
            dropDownMenuValues[id] = value;
            if (controllerInitValues != null) {
              controllerInitValues[id] = value;
            }
          }

          return Expanded(
            flex: length,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: CustomDropDownMenu(
                font: font,
                isEditing: isEditing,
                readonly: readonly,
                oid: id,
                dropDownMenuValues: dropDownMenuValues,
                groupValue: _groupValue,
              ),
            ),
          );
        } else {
          return const Text("dropDownMenuValues not provided");
        }

      case 2: //±值功能表
        if (sliderValues != null) {
          //replace ' with " to make json decode work
          List _parameter = jsonDecode(parameter.replaceAll('\'', '\"'));
          Map<String, dynamic> _sliderParams = <String, dynamic>{};

          for (var items in _parameter) {
            double _min = double.parse(items['min']!);
            double _max = double.parse(items['max']!);
            num _interval = (items['interval']! as List)
                .reduce((current, next) => current < next ? current : next);

            _sliderParams['min'] = _min;
            _sliderParams['max'] = _max;
            _sliderParams['interval'] = _interval;
          }

          if (sliderValues[id] == null) {
            //avoid assigning initvalue when setstate
            sliderValues[id] = value;
            if (controllerInitValues != null) {
              controllerInitValues[id] = sliderValues[id]!;
            }
          }

          return Expanded(
            flex: length,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: CustomSlider(
                font: font,
                isEditing: isEditing,
                readonly: readonly,
                oid: id,
                sliderValues: sliderValues,
                sliderParams: _sliderParams,
              ),
            ),
          );
        } else {
          return const Text("sliderValues not provided");
        }

      case 3: //單選按鈕組(radio button list)
        if (radioButtonValues != null) {
          //replace ' with " to make json decode work

          List _parameter = jsonDecode(parameter.replaceAll('\'', '\"'));
          Map<String, String> _groupValue = <String, String>{};
          _groupValue = {for (var e in _parameter) e['value']: e['text']};
          //print(_groupValue);

          if (radioButtonValues[id] == null) {
            //avoid assigning initvalue when setstate
            radioButtonValues[id] = value;
            if (controllerInitValues != null) {
              controllerInitValues[id] = value;
            }
          }

          return Expanded(
            flex: length,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: CustomRadiobox(
                font: font,
                isEditing: isEditing,
                readonly: readonly,
                oid: id,
                radioButtonValues: radioButtonValues,
                groupValue: _groupValue,
              ),
            ),
          );
        } else {
          return const Text("radioButtonValues not provided");
        }
      case 98: //區塊型欄位表單 (TextArea)
        if (textFieldControllers != null) {
          if (textFieldControllers[id] == null) {
            //avoid assigning initvalue when setstate
            textFieldControllers[id] = TextEditingController()..text = value;
            if (controllerInitValues != null) {
              controllerInitValues[id] = value;
            }
          }

          bool _enabled = isEditing && readonly == 0;
          return Expanded(
            flex: length,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: SingleChildScrollView(
                child: TextField(
                  key: Key(id),
                  controller: textFieldControllers[id],
                  enabled: _enabled,
                  style: TextStyle(fontSize: font),
                  maxLines: height,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _enabled ? Colors.white : Colors.grey.shade300,
                    //isDense: true,
                    //contentPadding: EdgeInsets.symmetric(vertical: 30.0),
                    isCollapsed: true,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.zero,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.zero,
                    ),
                    disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Text("textFieldControllers not provided");
        }

      case 99: //勾選方塊
        if (checkBoxValues != null) {
          if (checkBoxValues[id] == null) {
            //avoid assigning initvalue when setstate
            bool _initValue = value == '0' || value == "" ? false : true;
            checkBoxValues[id] = _initValue;
            if (controllerInitValues != null) {
              controllerInitValues[id] = value;
            }
          }

          return Expanded(
            flex: length,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: CustomCheckbox(
                  checkBoxValues: checkBoxValues,
                  isEditing: isEditing,
                  readonly: readonly,
                  oid: id),
              // Checkbox(
              //   visualDensity: const VisualDensity(vertical: -4.0),
              //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //   value: checkBoxValues[id],
              //   onChanged: isEditing
              //       ? (value) => checkBoxValues[id] = value ?? false
              //       : null,
              // ),
            ),
          );
        } else {
          return const Text("checkBoxValues not provided");
        }

      case 100: //文字標籤 - 白底黑字
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.black, fontSize: font),
              ),
            ),
          ),
        );

      case 101: //文字標籤 - 灰底白字
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 102: //文字標籤 - 白底藍字
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.blue, fontSize: font),
              ),
            ),
          ),
        );
      case 103: //文字標籤 - 藍底白字
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.blue),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 104: //文字標籤 - 綠底白字
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 105: //文字標籤 - 白底綠字
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.green, fontSize: font),
              ),
            ),
          ),
        );

      case 106: //文字標籤 - 白底黑字 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.black,
                    fontSize: font),
              ),
            ),
          ),
        );

      case 107: //文字標籤 - 白底藍字 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.blue,
                    fontSize: font),
              ),
            ),
          ),
        );

      case 108: //文字標籤 - 白底綠字 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.green,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 110: //文字標籤 - 白底黑字, 文字置中
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.black, fontSize: font),
              ),
            ),
          ),
        );
      case 111: //文字標籤 - 灰底白字, 文字置中
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 112: //文字標籤 - 白底藍字, 文字置中
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.blue, fontSize: font),
              ),
            ),
          ),
        );
      case 113: //文字標籤 - 藍底白字, 文字置中
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.blue),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 114: //文字標籤 - 綠底白字, 文字置中
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 115: //文字標籤 - 白底綠字, 文字置中
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.green, fontSize: font),
              ),
            ),
          ),
        );
      case 116: //文字標籤 - 白底黑字, 文字置中 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.black,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 117: //文字標籤 - 白底藍字, 文字置中 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.blue,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 118: //文字標籤 - 白底綠字, 文字置中 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.green,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 120: //文字標籤 - 白底黑字, 文字靠右
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: statusColor[status],
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.black,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 121: //文字標籤 - 灰底白字, 文字靠右
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 122: //文字標籤 - 白底藍字, 文字靠右
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: statusColor[status],
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.blue,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 123: //文字標籤 - 藍底白字, 文字靠右
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.blue),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 124: //文字標籤 - 綠底白字, 文字靠右
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 125: //文字標籤 - 白底綠字, 文字靠右
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: statusColor[status],
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.green,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 126: //文字標籤 - 白底黑字, 文字靠右 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.black,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 127: //文字標籤 - 白底藍字, 文字靠右 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.blue,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 128: //文字標籤 - 白底綠字, 文字靠右 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.green,
                    fontSize: font),
              ),
            ),
          ),
        );
      default:
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.black, fontSize: font),
              ),
            ),
          ),
        );
    }
  }

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
      CustomIcons.device,
      color: Color(0xff172a88),
    ), //Device
    3: Icon(
      CustomIcons.device,
      color: Color(0xff172a88),
    ), //A8K
    4: null, //shelf
    5: null, //slot
  };
}

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox(
      {Key? key,
      required this.isEditing,
      required this.readonly,
      required this.oid,
      required this.checkBoxValues})
      : super(key: key);

  final Map<String, bool> checkBoxValues;
  final String oid;
  final bool isEditing;
  final int readonly;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  final StreamController<bool> _checkBoxController = StreamController();
  Stream<bool> get _checkBoxStream => _checkBoxController.stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _checkBoxStream,
        initialData: widget.checkBoxValues[widget.oid],
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Checkbox(
            visualDensity: const VisualDensity(vertical: -4.0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: widget.checkBoxValues[widget.oid],
            onChanged: widget.isEditing && widget.readonly == 0
                ? (value) {
                    _checkBoxController.sink.add(value!);
                    widget.checkBoxValues[widget.oid] = value;
                  }
                : null,
          );
        });
  }
}

class CustomRadiobox extends StatefulWidget {
  const CustomRadiobox(
      {Key? key,
      required this.font,
      required this.isEditing,
      required this.readonly,
      required this.oid,
      required this.radioButtonValues,
      required this.groupValue})
      : super(key: key);

  final Map<String, String> groupValue;
  final Map<String, String> radioButtonValues;
  final String oid;
  final bool isEditing;
  final double font;
  final int readonly;

  @override
  State<CustomRadiobox> createState() => _CustomRadioboxState();
}

class _CustomRadioboxState extends State<CustomRadiobox> {
  final StreamController<String> _radioButtonController = StreamController();
  Stream<String> get _radioButtonStream => _radioButtonController.stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _radioButtonStream,
      initialData: widget.radioButtonValues[widget.oid],
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Row(
          children: [
            for (var k in widget.groupValue.keys) ...[
              Expanded(
                child: Row(
                  children: [
                    Radio(
                      visualDensity: const VisualDensity(vertical: -4.0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: k, //selected value
                      groupValue: widget.radioButtonValues[
                          widget.oid], //determine which is selected
                      onChanged: widget.isEditing && widget.readonly == 0
                          ? (String? value) {
                              _radioButtonController.sink.add(value!);
                              widget.radioButtonValues[widget.oid] = value;
                            }
                          : null,
                    ),
                    Expanded(
                      child: Text(
                        widget.groupValue[k]!,
                        style: TextStyle(
                          fontSize: widget.font,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class CustomSlider extends StatefulWidget {
  const CustomSlider({
    Key? key,
    required this.font,
    required this.isEditing,
    required this.readonly,
    required this.oid,
    required this.sliderValues,
    required this.sliderParams,
  }) : super(key: key);

  final Map<String, String> sliderValues;
  final Map<String, dynamic> sliderParams;
  final String oid;
  final bool isEditing;
  final double font;
  final int readonly;

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  final StreamController<double> _sliderController = StreamController();
  Stream<double> get _sliderStream => _sliderController.stream;

  @override
  Widget build(BuildContext context) {
    double truncateDecimal(double value) {
      double fixDecimal = double.parse(value.toStringAsFixed(1));
      return double.parse(fixDecimal.toStringAsFixed(
          fixDecimal.truncateToDouble() == fixDecimal ? 0 : 1));
    }

    bool isInteger(num value) => value is int || value == value.roundToDouble();

    return StreamBuilder(
        stream: _sliderStream,
        initialData: double.parse(widget.sliderValues[widget.oid]!),
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: SliderTheme(
                  data: const SliderThemeData(
                    valueIndicatorColor: Colors.red,
                    showValueIndicator: ShowValueIndicator.always,
                  ),
                  child: Slider(
                    min: widget.sliderParams['min']!,
                    max: widget.sliderParams['max']!,
                    divisions: ((widget.sliderParams['max'] -
                                widget.sliderParams['min']) ~/
                            widget.sliderParams['interval'])
                        .toInt(),
                    value: double.parse(widget.sliderValues[widget.oid]!),
                    onChanged: widget.isEditing && widget.readonly == 0
                        ? (value) {
                            _sliderController.sink.add(value);

                            String strValue =
                                isInteger(widget.sliderParams['interval'])
                                    ? value.toInt().toString()
                                    : truncateDecimal(value).toString();

                            widget.sliderValues[widget.oid] = strValue;

                            if (kDebugMode) {
                              print(
                                  'double value: $value  String value: ${widget.sliderValues[widget.oid]}');
                            }
                          }
                        : null,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Text(
                    widget.sliderValues[widget.oid]!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: widget.font),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 12.0)),
            ],
          );
        });
  }
}

class CustomDropDownMenu extends StatefulWidget {
  const CustomDropDownMenu(
      {Key? key,
      required this.font,
      required this.isEditing,
      required this.readonly,
      required this.oid,
      required this.dropDownMenuValues,
      required this.groupValue})
      : super(key: key);

  final Map<String, String> groupValue;
  final Map<String, String> dropDownMenuValues;
  final String oid;
  final bool isEditing;
  final double font;
  final int readonly;

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  final StreamController<String> _dropDownMenuController = StreamController();
  Stream<String> get _dropDownMenuStream => _dropDownMenuController.stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _dropDownMenuStream,
      initialData: widget.dropDownMenuValues[widget.oid],
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return DecoratedBox(
          decoration: BoxDecoration(
              color: widget.isEditing && widget.readonly == 0
                  ? Colors.white
                  : Colors.grey.shade300),
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(1.0, 0, 0, 0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isDense: true,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                value: widget.dropDownMenuValues[widget.oid],
                items: [
                  for (String k in widget.groupValue.keys)
                    DropdownMenuItem(
                      value: k,
                      child: Center(
                        child: Text(
                          widget.groupValue[k]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: widget.font,
                              color: widget.isEditing && widget.readonly == 0
                                  ? Colors.black
                                  : Colors.black),
                        ),
                      ),
                    )
                ],
                onChanged: widget.isEditing && widget.readonly == 0
                    ? (String? value) {
                        _dropDownMenuController.sink.add(value!);
                        widget.dropDownMenuValues[widget.oid] = value;
                      }
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
