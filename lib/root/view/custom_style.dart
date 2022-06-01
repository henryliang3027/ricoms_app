import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

class CustomStyle {
  static Widget getBox(
    int style,
    dynamic e, {
    bool isEditing = false,
    Map<String, bool>? checkBoxValues,
    Map<String, TextEditingController>? textFieldControllers,
    Map<String, String>? radioButtonValues,
    Map<String, double>? sliderValues,
  }) {
    int length = e['length'];
    int height = e['height'];
    String value = e['value'];
    double font = (e['font'] as int).toDouble();
    int status = e['status'];
    String parameter = e['parameter'];
    int readonly = e['readonly'];
    String id = e['id'].toString();

    switch (style) {
      case 0:
        if (textFieldControllers != null) {
          textFieldControllers[id] = TextEditingController()..text = value;

          return Expanded(
            flex: length,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Container(
                child: TextField(
                  key: Key(id),
                  controller: textFieldControllers[id],
                  textAlign: TextAlign.center,
                  enabled: isEditing,
                  style: TextStyle(fontSize: font),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isEditing ? Colors.white : Colors.grey.shade300,
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
          return Container(
            child: Text("textFieldControllers not provided"),
          );
        }

      case 2:
        if (sliderValues != null) {
          //replace ' with " to make json decode work
          List _parameter = jsonDecode(parameter.replaceAll('\'', '\"'));
          Map<String, dynamic> _sliderParams = <String, dynamic>{};

          for (var items in _parameter) {
            double _min = double.parse(items['min']!);
            double _max = double.parse(items['max']!);
            var _interval = (items['interval']! as List)
                .reduce((current, next) => current < next ? current : next);

            print(_interval.runtimeType);

            _sliderParams['min'] = _min;
            _sliderParams['max'] = _max;
            _sliderParams['division'] = ((_max - _min) ~/ _interval).toInt();
          }

          print(_sliderParams);
          sliderValues[id] = double.parse(value);

          return Expanded(
            flex: length,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: CustomSlider(
                isEditing: isEditing,
                oid: id,
                sliderValues: sliderValues,
                sliderParams: _sliderParams,
              ),
            ),
          );
        } else {
          return Container(
            child: Text("sliderValues not provided"),
          );
        }

      case 3:
        if (radioButtonValues != null) {
          //replace ' with " to make json decode work
          List _parameter = jsonDecode(parameter.replaceAll('\'', '\"'));
          Map<String, String> _groupValue = <String, String>{};
          _groupValue = {for (var e in _parameter) e['value']: e['text']};
          print(_groupValue);
          radioButtonValues[id] = value;

          return Expanded(
            flex: length,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: CustomRadiobox(
                isEditing: isEditing,
                oid: id,
                radioButtonValues: radioButtonValues,
                groupValue: _groupValue,
              ),
            ),
          );
        } else {
          return Container(
            child: Text("radioButtonValues not provided"),
          );
        }
      case 98:
        if (textFieldControllers != null) {
          textFieldControllers[id] = TextEditingController()..text = value;

          return Expanded(
            flex: length,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: SingleChildScrollView(
                child: TextField(
                  key: Key(id),
                  controller: textFieldControllers[id],
                  enabled: isEditing,
                  style: TextStyle(fontSize: font),
                  maxLines: height,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isEditing ? Colors.white : Colors.grey.shade300,
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
          return Container(
            child: Text("textFieldControllers not provided"),
          );
        }

      case 99:
        if (checkBoxValues != null) {
          bool _initValue = value == '0' || value == "" ? false : true;

          //avoid assigning initvalue when setstate
          checkBoxValues[id] = _initValue;

          return Expanded(
            flex: length,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: CustomCheckbox(
                  checkBoxValues: checkBoxValues,
                  isEditing: isEditing,
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
          return Container(
            child: Text("checkBoxValues not provided"),
          );
        }

      case 100:
        return Expanded(
          flex: length,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.black, fontSize: font),
              ),
            ),
          ),
        );

      case 101:
        return Expanded(
          flex: length,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 102:
        return Expanded(
          flex: length,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.blue, fontSize: font),
              ),
            ),
          ),
        );
      case 103:
        return Expanded(
          flex: length,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
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
      case 104:
        return Expanded(
          flex: length,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 105:
        return Expanded(
          flex: length,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.green, fontSize: font),
              ),
            ),
          ),
        );

      case 106:
        return Expanded(
          flex: length,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.black, fontSize: font),
              ),
            ),
          ),
        );

      case 107:
        return Expanded(
          flex: length,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.blue, fontSize: font),
              ),
            ),
          ),
        );

      case 108:
        return Expanded(
          flex: length,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.green, fontSize: font),
              ),
            ),
          ),
        );
      case 113:
        return Expanded(
          flex: length,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
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
      default:
        return Expanded(
          flex: length,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
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
}

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox(
      {Key? key,
      required this.isEditing,
      required this.oid,
      required this.checkBoxValues})
      : super(key: key);

  final Map<String, bool> checkBoxValues;
  final String oid;
  final bool isEditing;

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
            value: snapshot.data,
            onChanged: widget.isEditing
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
      required this.isEditing,
      required this.oid,
      required this.radioButtonValues,
      required this.groupValue})
      : super(key: key);

  final Map<String, String> groupValue;
  final Map<String, String> radioButtonValues;
  final String oid;
  final bool isEditing;

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
                      value: k,
                      groupValue: snapshot.data,
                      onChanged: widget.isEditing
                          ? (String? value) {
                              _radioButtonController.sink.add(value!);
                              widget.radioButtonValues[widget.oid] = value;
                            }
                          : null,
                    ),
                    Expanded(
                      child: Text(widget.groupValue[k]!),
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
    required this.isEditing,
    required this.oid,
    required this.sliderValues,
    required this.sliderParams,
  }) : super(key: key);

  final Map<String, double> sliderValues;
  final Map<String, dynamic> sliderParams;
  final String oid;
  final bool isEditing;

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  final StreamController<double> _sliderController = StreamController();
  Stream<double> get _sliderStream => _sliderController.stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _sliderStream,
        initialData: widget.sliderValues[widget.oid],
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          return SliderTheme(
            data: SliderThemeData(
              valueIndicatorColor: Colors.red,
              showValueIndicator: ShowValueIndicator.always,
            ),
            child: Slider(
              min: widget.sliderParams['min']!,
              max: widget.sliderParams['max']!,
              divisions: widget.sliderParams['division']!,
              label: snapshot.data!.round().toString(),
              value: snapshot.data!,
              thumbColor: null,
              onChanged: widget.isEditing
                  ? (value) {
                      _sliderController.sink.add(value);
                      widget.sliderValues[widget.oid] = value;
                    }
                  : null,
            ),
          );
        });
  }
}
