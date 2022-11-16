import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/bloc/device/device_bloc.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/root/view/device_setting_style.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class DeviceSettingForm extends StatefulWidget {
  DeviceSettingForm({
    Key? key,
    required this.nodeId,
    required this.deviceBlock,
  }) : super(key: key);

  final DeviceBlock deviceBlock;
  final int nodeId;
  final Map<String, bool> checkBoxValues = <String, bool>{};
  final Map<String, TextEditingController> textFieldControllers =
      <String, TextEditingController>{};
  final Map<String, String> radioButtonValues = <String, String>{};
  final Map<String, String> sliderValues = <String, String>{};
  final Map<String, String> dropDownMenuValues = <String, String>{};
  final Map<String, String> controllerInitValues = <String, String>{};

  @override
  State<DeviceSettingForm> createState() => _DeviceSettingFormState();
}

class _DeviceSettingFormState extends State<DeviceSettingForm> {
  Future<void> _showInProgressDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitle_settingUp,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: const <Widget>[
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showSuccessDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            getMessageLocalization(
              msg: msg,
              context: context,
            ),
            style: TextStyle(
              color: CustomStyle.severityColor[1],
            ),
          ),
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

  Future<void> _showFailureDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.dialogTitle_error,
            style: TextStyle(
              color: CustomStyle.severityColor[3],
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  getMessageLocalization(
                    msg: msg,
                    context: context,
                  ),
                ),
              ],
            ),
          ),
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
    Map _userFunctionMap =
        context.read<AuthenticationBloc>().state.userFunctionMap;

    Widget _buildBody({
      required List<dynamic> data,
      required bool isEditing,
    }) {
      return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (var item in data) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var e in item) ...[
                              CustomStyle.getBox(
                                e,
                                isEditing: isEditing,
                                checkBoxValues: widget.checkBoxValues,
                                textFieldControllers:
                                    widget.textFieldControllers,
                                radioButtonValues: widget.radioButtonValues,
                                sliderValues: widget.sliderValues,
                                dropDownMenuValues: widget.dropDownMenuValues,
                                controllerInitValues:
                                    widget.controllerInitValues,
                              ),
                            ]
                          ],
                        )
                      ],
                      const SizedBox(
                        height: 120,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget? _buildFloatingActionButton({
      required bool editable,
      required bool isEditing,
    }) {
      return _userFunctionMap[13]
          ? editable
              ? CreateEditingTool(
                  isEditing: isEditing,
                  pageName: widget.deviceBlock.name,
                  checkBoxValues: widget.checkBoxValues,
                  textFieldControllers: widget.textFieldControllers,
                  radioButtonValues: widget.radioButtonValues,
                  sliderValues: widget.sliderValues,
                  dropDownMenuValues: widget.dropDownMenuValues,
                  controllerInitValues: widget.controllerInitValues,
                )
              : null
          : null;
    }

    return BlocListener<DeviceBloc, DeviceState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress) {
          await _showInProgressDialog();
        } else if (state.submissionStatus.isSubmissionSuccess) {
          Navigator.of(context).pop();
          _showSuccessDialog(state.saveResultMsg);
          context.read<DeviceBloc>().add(const DeviceDataUpdateRequested());
        } else if (state.submissionStatus.isSubmissionFailure) {
          Navigator.of(context).pop();
          _showFailureDialog(state.saveResultMsg);
          context.read<DeviceBloc>().add(const DeviceDataUpdateRequested());
        }
      },
      child: BlocBuilder<DeviceBloc, DeviceState>(
        builder: (BuildContext context, state) {
          if (state.formStatus.isRequestInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.formStatus.isUpdating) {
            // fetch new values and reset the values in all controllers and init value map
            // ex: set the value from 1 to 2
            // if you don't update init value map, the value is still 1
            // when you set to 1 again, the value will be consider as not change and will not be write to the device
            widget.controllerInitValues.clear();
            widget.sliderValues.clear();
            widget.textFieldControllers.clear();
            widget.radioButtonValues.clear();
            widget.checkBoxValues.clear();
            widget.dropDownMenuValues.clear();

            return Scaffold(
                body: _buildBody(
                  data: state.data,
                  isEditing: state.isEditing,
                ),
                floatingActionButton: _buildFloatingActionButton(
                  editable: state.editable,
                  isEditing: state.isEditing,
                ));
          } else if (state.formStatus.isRequestSuccess) {
            return Scaffold(
                body: _buildBody(
                  data: state.controllerPropertiesCollection,
                  isEditing: state.isEditing,
                ),
                floatingActionButton: _buildFloatingActionButton(
                  editable: state.editable,
                  isEditing: state.isEditing,
                ));
          } else {
            return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_rounded,
                    size: 200,
                    color: Color(0xffffc107),
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .dialogMessage_DeviceDoesNotRespond,
                  ),
                  const SizedBox(height: 40.0),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class CreateEditingTool extends StatelessWidget {
  const CreateEditingTool({
    Key? key,
    required this.isEditing,
    required this.pageName,
    required this.checkBoxValues,
    required this.textFieldControllers,
    required this.radioButtonValues,
    required this.sliderValues,
    required this.dropDownMenuValues,
    required this.controllerInitValues,
  }) : super(key: key);

  final bool isEditing;
  final String pageName;
  final Map<String, bool> checkBoxValues;
  final Map<String, TextEditingController> textFieldControllers;
  final Map<String, String> radioButtonValues;
  final Map<String, String> sliderValues;
  final Map<String, String> dropDownMenuValues;
  final Map<String, String> controllerInitValues;

  @override
  Widget build(BuildContext context) {
    return isEditing
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: null,
                elevation: 0.0,
                backgroundColor: const Color(0x742195F3),
                onPressed: () {
                  List<Map<String, String>> dataList = [];

                  if (checkBoxValues.isNotEmpty) {
                    checkBoxValues.forEach((key, value) {
                      String _binValue = value ? '1' : '0';
                      if (controllerInitValues[key] != _binValue) {
                        dataList.add({'oid_id': key, 'value': _binValue});
                      }
                    });
                  }

                  if (textFieldControllers.isNotEmpty) {
                    if (pageName == 'Description') {
                      String nameId = '9998';
                      String descriptionId = '9999';
                      dataList.add({
                        'oid_id': nameId,
                        'value': textFieldControllers[nameId]!.text
                      });
                      dataList.add({
                        'oid_id': descriptionId,
                        'value': textFieldControllers[descriptionId]!.text
                      });
                    } else {
                      textFieldControllers.forEach((key, value) {
                        if (controllerInitValues[key] != value.text) {
                          dataList.add({'oid_id': key, 'value': value.text});
                        }
                      });
                    }
                  }

                  if (radioButtonValues.isNotEmpty) {
                    radioButtonValues.forEach((key, value) {
                      if (controllerInitValues[key] != value) {
                        dataList.add({'oid_id': key, 'value': value});
                      }
                    });
                  }

                  if (sliderValues.isNotEmpty) {
                    sliderValues.forEach((key, value) {
                      if (controllerInitValues[key] != value) {
                        dataList
                            .add({'oid_id': key, 'value': value.toString()});
                      }
                    });
                  }

                  if (dropDownMenuValues.isNotEmpty) {
                    dropDownMenuValues.forEach((key, value) {
                      if (controllerInitValues[key] != value) {
                        dataList.add({'oid_id': key, 'value': value});
                      }
                    });
                  }

                  if (kDebugMode) {
                    for (var element in dataList) {
                      element.forEach((key, value) => print('$key : $value'));
                    }
                  }
                  context.read<DeviceBloc>().add(DeviceParamSaved(dataList));

                  //widget.isEditing = false;
                  //_showSuccessDialog();},
                },
                child: const Icon(CustomIcons.check),
                //const Text('Save'),
              ),
              const Padding(
                padding: EdgeInsets.all(6.0),
              ),
              FloatingActionButton(
                  heroTag: null,
                  elevation: 0.0,
                  backgroundColor: const Color(0x742195F3),
                  onPressed: () {
                    context
                        .read<DeviceBloc>()
                        .add(const FormStatusChanged(false));
                  },
                  child: const Icon(CustomIcons.cancel)),
            ],
          )
        : FloatingActionButton(
            elevation: 0.0,
            backgroundColor: const Color(0x742195F3),
            onPressed: () {
              context.read<DeviceBloc>().add(const FormStatusChanged(true));
            },
            child: const Icon(Icons.edit),
          );
  }
}

class _DeviceText extends StatelessWidget {
  const _DeviceText({
    Key? key,
    required this.textProperty,
    required this.isEditing,
  }) : super(key: key);

  final TextProperty textProperty;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceBloc, DeviceState>(
        buildWhen: (previous, current) =>
            previous.controllerPropertiesCollection !=
            current.controllerPropertiesCollection,
        builder: (context, state) {
          return Expanded(
            flex: textProperty.boxLength,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: textProperty.boxColor,
                  border: Border.all(color: textProperty.borderColor),
                ),
                child: Text(
                  textProperty.text,
                  style: TextStyle(
                      color: textProperty.textColor,
                      fontSize: textProperty.fontSize),
                ),
              ),
            ),
          );
        });
  }
}

class _DeviceTextField extends StatelessWidget {
  const _DeviceTextField({
    Key? key,
    required this.textFieldProperty,
    required this.textEditingController,
    required this.isEditing,
  }) : super(key: key);

  final TextFieldProperty textFieldProperty;
  final TextEditingController textEditingController;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceBloc, DeviceState>(
        buildWhen: (previous, current) =>
            previous.controllerValues[textFieldProperty.oid] !=
            current.controllerValues[textFieldProperty.oid],
        builder: (context, state) {
          return Expanded(
            flex: textFieldProperty.boxLength,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: TextField(
                key: Key(textFieldProperty.oid),
                controller: textEditingController
                  ..text = textFieldProperty.text,
                textAlign: TextAlign.center,
                enabled: isEditing && !textFieldProperty.readOnly,
                style: TextStyle(fontSize: textFieldProperty.fontSize),
                onChanged: (text) {
                  context
                      .read<DeviceBloc>()
                      .add(ControllerValueChanged(textFieldProperty.oid, text));
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isEditing && !textFieldProperty.readOnly
                      ? Colors.white
                      : Colors.grey.shade300,
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
          );
        });
  }
}

class _DeviceCheckBox extends StatelessWidget {
  const _DeviceCheckBox({
    Key? key,
    required this.checkBoxProperty,
    required this.isEditing,
  }) : super(key: key);

  final CheckBoxProperty checkBoxProperty;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceBloc, DeviceState>(
      buildWhen: (previous, current) =>
          previous.controllerValues[checkBoxProperty.oid] !=
          current.controllerValues[checkBoxProperty.oid],
      builder: (context, state) {
        return Checkbox(
          visualDensity: const VisualDensity(vertical: -4.0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: state.controllerValues[checkBoxProperty.oid] == '1'
              ? true
              : false,
          onChanged: isEditing && !checkBoxProperty.readOnly
              ? (value) {
                  if (value != null) {
                    context.read<DeviceBloc>().add(ControllerValueChanged(
                        checkBoxProperty.oid, value ? '1' : '0'));
                  }
                }
              : null,
        );
      },
    );
  }
}

class _DeviceRadioButton extends StatelessWidget {
  const _DeviceRadioButton({
    Key? key,
    required this.radioButtonProperty,
    required this.isEditing,
  }) : super(key: key);

  final RadioButtonProperty radioButtonProperty;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceBloc, DeviceState>(
      buildWhen: (previous, current) =>
          previous.controllerValues[radioButtonProperty.oid] !=
          current.controllerValues[radioButtonProperty.oid],
      builder: (context, state) {
        return Row(
          children: [
            for (MapEntry<String, String> entry
                in radioButtonProperty.items.entries) ...[
              Expanded(
                child: Row(
                  children: [
                    Radio(
                      visualDensity: const VisualDensity(vertical: -4.0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: entry.key, //selected value
                      groupValue: radioButtonProperty
                          .value, //determine which is selected
                      onChanged: isEditing && !radioButtonProperty.readOnly
                          ? (String? value) {
                              context.read<DeviceBloc>().add(
                                  ControllerValueChanged(
                                      radioButtonProperty.oid, value!));
                            }
                          : null,
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style:
                            TextStyle(fontSize: radioButtonProperty.fontSize),
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

class _DeviceSlider extends StatelessWidget {
  const _DeviceSlider({
    Key? key,
    required this.sliderProperty,
    required this.isEditing,
  }) : super(key: key);

  final SliderProperty sliderProperty;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    double truncateDecimal(double value) {
      double fixDecimal = double.parse(value.toStringAsFixed(1));
      return double.parse(fixDecimal.toStringAsFixed(
          fixDecimal.truncateToDouble() == fixDecimal ? 0 : 1));
    }

    bool isInteger(num value) => value is int || value == value.roundToDouble();

    return BlocBuilder<DeviceBloc, DeviceState>(
      buildWhen: (previous, current) =>
          previous.controllerValues[sliderProperty.oid] !=
          current.controllerValues[sliderProperty.oid],
      builder: (context, state) {
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
                  min: sliderProperty.min,
                  max: sliderProperty.max,
                  divisions: ((sliderProperty.max - sliderProperty.min) ~/
                          sliderProperty.interval)
                      .toInt(),
                  value: double.parse(sliderProperty.value),
                  onChanged: isEditing && !sliderProperty.readOnly
                      ? (value) {
                          String strValue = isInteger(sliderProperty.interval)
                              ? value.toInt().toString()
                              : truncateDecimal(value).toString();

                          context.read<DeviceBloc>().add(ControllerValueChanged(
                              sliderProperty.oid, strValue));
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
                  sliderProperty.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: sliderProperty.fontSize),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 12.0)),
          ],
        );
      },
    );
  }
}

class _DeviceDropDownMenu extends StatelessWidget {
  const _DeviceDropDownMenu({
    Key? key,
    required this.dropDownMenuProperty,
    required this.isEditing,
  }) : super(key: key);

  final DropDownMenuProperty dropDownMenuProperty;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceBloc, DeviceState>(
      buildWhen: (previous, current) =>
          previous.controllerValues[dropDownMenuProperty.oid] !=
          current.controllerValues[dropDownMenuProperty.oid],
      builder: (context, state) {
        return DecoratedBox(
          decoration: BoxDecoration(
              color: isEditing && !dropDownMenuProperty.readOnly
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
                value: state.controllerValues[dropDownMenuProperty.oid],
                items: [
                  for (MapEntry<String, String> entry
                      in dropDownMenuProperty.items.entries)
                    DropdownMenuItem(
                      value: entry.key,
                      child: Center(
                        child: Text(
                          entry.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: dropDownMenuProperty.fontSize,
                              color: isEditing && !dropDownMenuProperty.readOnly
                                  ? Colors.black
                                  : Colors.black),
                        ),
                      ),
                    )
                ],
                onChanged: isEditing && !dropDownMenuProperty.readOnly
                    ? (String? value) {
                        context.read<DeviceBloc>().add(ControllerValueChanged(
                            dropDownMenuProperty.oid, value!));
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
