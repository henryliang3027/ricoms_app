import 'package:flutter/material.dart';
import 'package:ricoms_app/root/view/custom_style.dart';

class ThresholdForm extends StatefulWidget {
  ThresholdForm({Key? key, required this.items}) : super(key: key);

  final List items;
  final Map<String, bool> checkBoxValues = <String, bool>{};
  final Map<String, TextEditingController> textFieldControllers =
      <String, TextEditingController>{};

  bool isEditing = false;
  bool isSaved = false;

  @override
  State<ThresholdForm> createState() => _ThresholdFormState();
}

class _ThresholdFormState extends State<ThresholdForm>
    with AutomaticKeepAliveClientMixin {
  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Setup completed!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // pop dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build Threshold');

    Widget buildController(int style, String oid, String initValue) {
      if (style == 0) {
        if (!widget.textFieldControllers.containsKey(oid)) {
          //avoid assigning initvalue when setstate
          widget.textFieldControllers[oid] = TextEditingController()
            ..text = initValue;
        }
        return TextField(
          key: Key(oid),
          controller: widget.textFieldControllers[oid],
          textAlign: TextAlign.center,
          enabled: widget.isEditing,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.isEditing ? Colors.white : Colors.grey.shade300,
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
        );
      } else if (style == 99) {
        bool _initValue = initValue == '0' || initValue == "" ? false : true;
        if (!widget.checkBoxValues.containsKey(oid)) {
          //avoid assigning initvalue when setstate
          widget.checkBoxValues[oid] = _initValue;
        }

        return Checkbox(
          visualDensity: const VisualDensity(vertical: -4.0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: widget.checkBoxValues[oid],
          onChanged: widget.isEditing
              ? (value) {
                  setState(() {
                    widget.checkBoxValues[oid] = value ?? false;
                  });
                }
              : null,
        );
      } else {
        return Container();
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.isEditing
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ElevatedButton(
                        onPressed: () => setState(() {
                          widget.isEditing = false;
                        }),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white70,
                          elevation: 0,
                          side: const BorderSide(
                            width: 1.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Map<String, String> data = <String, String>{};

                          widget.checkBoxValues.forEach((key, value) {
                            data[key] = value ? '1' : '0';
                          });

                          widget.textFieldControllers.forEach((key, value) {
                            data[key] = value.text;
                          });

                          data.forEach((key, value) {
                            print('${key} : ${value}');
                          });

                          //widget.isEditing = false;
                          //_showSuccessDialog();},
                        },
                        child: const Text('Save'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.textFieldControllers.forEach((key, value) {
                            print('${key} : ${value.text}');
                          });
                          widget.checkBoxValues.forEach((key, value) {
                            print('${key} : ${value.toString()}');
                          });
                        },
                        child: const Text('show data'),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ElevatedButton(
                        onPressed: () => setState(() {
                          widget.isEditing = true;
                        }),
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white70,
                          elevation: 0,
                          side: const BorderSide(
                            width: 1.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          // Center(
          //   child: ElevatedButton(
          //     child: const Text('show value'),
          //     onPressed: () {
          //       print(widget.checkBoxValues);
          //       print('----------------------');
          //       widget.textFieldControllers.forEach((key, value) {
          //         print('$key : ${value.text}');
          //       });
          //     },
          //   ),
          // ),
          for (var item in widget.items)
            if (item.length == 3) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 6.0),
                      child: CustomStyle.getBox(
                          item[0]['style'], item[0]['value']),
                    ),
                  ),
                  //CustomStyle.getBox(item[1]['style'], item[1]['value']),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: buildController(item[2]['style'],
                          item[2]['id'].toString(), item[2]['value']),
                    ),
                  ),
                ],
              )
            ] else if (item.length == 1) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CustomStyle.getBox(
                          item[0]['style'], item[0]['value']),
                    ),
                  ),
                ],
              ),
            ]
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
