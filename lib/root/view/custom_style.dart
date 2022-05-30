import 'dart:async';

import 'package:flutter/material.dart';

class CustomStyle {
  static Widget getBox(int style, dynamic e,
      {bool isEditing = false,
      Map<String, bool>? checkBoxValues,
      Map<String, TextEditingController>? textFieldControllers}) {
    int length = e['length'];
    String value = e['value'];
    double font = (e['font'] as int).toDouble();
    int status = e['status'];
    String paraameter = e['parameter'];
    int readonly = e['readonly'];
    String id = e['id'].toString();

    switch (style) {
      case 0:
        if (textFieldControllers != null) {
          if (!textFieldControllers.containsKey(id)) {
            //avoid assigning initvalue when setstate
            textFieldControllers[id] = TextEditingController()..text = value;
          }
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
      case 99:
        if (checkBoxValues != null) {
          bool _initValue = value == '0' || value == "" ? false : true;
          if (!checkBoxValues.containsKey(id)) {
            //avoid assigning initvalue when setstate
            checkBoxValues[id] = _initValue;
          }

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
            child: Text("checkboxes not provided"),
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
