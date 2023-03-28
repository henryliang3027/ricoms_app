import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/repository/root_repository/device_repository.dart';
import 'package:ricoms_app/root/bloc/device/device_bloc.dart';
import 'package:ricoms_app/root/models/custom_input.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/root/view/device_setting_style.dart';
import 'package:ricoms_app/utils/common_request.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class DeviceSettingForm extends StatelessWidget {
  const DeviceSettingForm({
    Key? key,
    required this.nodeId,
    required this.deviceBlock,
  }) : super(key: key);

  final DeviceBlock deviceBlock;
  final int nodeId;

  @override
  Widget build(BuildContext context) {
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
              style: const TextStyle(
                color: CustomStyle.customGreen,
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
              style: const TextStyle(
                color: CustomStyle.customRed,
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

    return BlocListener<DeviceBloc, DeviceState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress) {
          await _showInProgressDialog();
        } else if (state.submissionStatus.isSubmissionSuccess) {
          Navigator.of(context).pop();
          _showSuccessDialog(state.saveResultMsg);
          context
              .read<DeviceBloc>()
              .add(const DeviceDataRequested(RequestMode.update));
        } else if (state.submissionStatus.isSubmissionFailure) {
          Navigator.of(context).pop();
          _showFailureDialog(state.saveResultMsg);
          context
              .read<DeviceBloc>()
              .add(const DeviceDataRequested(RequestMode.update));
        }
      },
      child: _DeviceContent(
        deviceBlock: deviceBlock,
      ),
    );
  }
}

class _DeviceContent extends StatelessWidget {
  const _DeviceContent({
    Key? key,
    required this.deviceBlock,
  }) : super(key: key);

  final DeviceBlock deviceBlock;

  @override
  Widget build(BuildContext context) {
    Map _userFunctionMap =
        context.read<AuthenticationBloc>().state.userFunctionMap;

    Widget _buildItem({
      required ControllerProperty controllerProperty,
      required bool isEditing,
    }) {
      if (controllerProperty.runtimeType == TextFieldProperty) {
        TextFieldProperty textFieldProperty =
            controllerProperty as TextFieldProperty;

        return _DeviceTextField(
          textFieldProperty: textFieldProperty,
          textEditingController: TextEditingController()
            ..text = textFieldProperty.initValue,
          isEditing: isEditing,
        );
      } else if (controllerProperty.runtimeType == DropDownMenuProperty) {
        return _DeviceDropDownMenu(
          dropDownMenuProperty: controllerProperty as DropDownMenuProperty,
          isEditing: isEditing,
        );
      } else if (controllerProperty.runtimeType == SliderProperty) {
        return _DeviceSlider(
          sliderProperty: controllerProperty as SliderProperty,
          isEditing: isEditing,
        );
      } else if (controllerProperty.runtimeType == RadioButtonProperty) {
        return _DeviceRadioButton(
          radioButtonProperty: controllerProperty as RadioButtonProperty,
          isEditing: isEditing,
        );
      } else if (controllerProperty.runtimeType == CheckBoxProperty) {
        return _DeviceCheckBox(
          checkBoxProperty: controllerProperty as CheckBoxProperty,
          isEditing: isEditing,
        );
      } else if (controllerProperty.runtimeType == TextProperty) {
        return _DeviceText(
          textProperty: controllerProperty as TextProperty,
        );
      } else {
        return Container(
          color: Colors.grey,
          child: const Text('----'),
        );
      }
    }

    Widget _buildRaw({
      required List<ControllerProperty> controllerProperties,
      required bool isEditing,
    }) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (ControllerProperty controllerProperty
              in controllerProperties) ...[
            _buildItem(
              controllerProperty: controllerProperty,
              isEditing: isEditing,
            ),
          ]
        ],
      );
    }

    Widget _buildBody({
      required List<List<ControllerProperty>> controllerPropertiesCollection,
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
                      for (List<ControllerProperty> controllerProperties
                          in controllerPropertiesCollection) ...[
                        _buildRaw(
                          controllerProperties: controllerProperties,
                          isEditing: isEditing,
                        ),
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
      required Map<String, dynamic> controllerValues,
    }) {
      return _userFunctionMap[13]
          ? editable
              ? CreateEditingTool(
                  isEditing: isEditing,
                  pageName: deviceBlock.name,
                )
              : null
          : null;
    }

    return BlocBuilder<DeviceBloc, DeviceState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.controllerPropertiesCollection !=
              current.controllerPropertiesCollection,
      builder: (context, state) {
        if (state.formStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.formStatus.isRequestSuccess) {
          return Scaffold(
              body: _buildBody(
                controllerPropertiesCollection:
                    state.controllerPropertiesCollection,
                isEditing: state.isEditing,
              ),
              floatingActionButton: _buildFloatingActionButton(
                editable: state.editable,
                isEditing: state.isEditing,
                controllerValues: state.controllerValues,
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
    );
  }
}

class CreateEditingTool extends StatelessWidget {
  const CreateEditingTool({
    Key? key,
    required this.isEditing,
    required this.pageName,
  }) : super(key: key);

  final bool isEditing;
  final String pageName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceBloc, DeviceState>(
      builder: (context, state) {
        return state.isEditing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: null,
                    elevation: 0.0,
                    backgroundColor: const Color(0x742195F3),
                    onPressed: () {
                      context.read<DeviceBloc>().add(const DeviceParamSaved());
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
      },
    );
  }
}

class _DeviceText extends StatelessWidget {
  const _DeviceText({
    Key? key,
    required this.textProperty,
  }) : super(key: key);

  final TextProperty textProperty;

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
                alignment: textProperty.alignment,
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
            previous.isEditing != current.isEditing ||
            previous.controllerValues[textFieldProperty.oid] !=
                current.controllerValues[textFieldProperty.oid],
        builder: (context, state) {
          // print(state.controllerValues[textFieldProperty.oid]!.runtimeType);
          // print((state.controllerValues[textFieldProperty.oid]! as CustomInput)
          //     .invalid);
          return Expanded(
            flex: textFieldProperty.boxLength,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: TextField(
                key: Key(textFieldProperty.oid),
                controller: textEditingController,
                textAlign: textFieldProperty.textAlign,
                maxLines: textFieldProperty.maxLine,
                maxLength: textFieldProperty.maxLength,
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
                  counterText: '',
                  errorMaxLines: 2,
                  errorStyle: const TextStyle(
                    fontSize: CommonStyle.sizeS,
                  ),
                  errorText: state.controllerValues[textFieldProperty.oid]!
                          is CustomInput
                      ? (state.controllerValues[textFieldProperty.oid]!
                                  as CustomInput)
                              .invalid
                          ? AppLocalizations.of(context)!.ipErrorText
                          : null
                      : null,
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
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.zero,
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
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
          previous.isEditing != current.isEditing ||
          previous.controllerValues[checkBoxProperty.oid] !=
              current.controllerValues[checkBoxProperty.oid],
      builder: (context, state) {
        return Expanded(
          flex: checkBoxProperty.boxLength,
          child: Checkbox(
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
          ),
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
          previous.isEditing != current.isEditing ||
          previous.controllerValues[radioButtonProperty.oid] !=
              current.controllerValues[radioButtonProperty.oid],
      builder: (context, state) {
        return Expanded(
          flex: radioButtonProperty.boxLength,
          child: Row(
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
                        groupValue: state
                            .controllerValues[radioButtonProperty.oid]
                            .toString(), //determine which is selected
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
          ),
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
          previous.isEditing != current.isEditing ||
          previous.controllerValues[sliderProperty.oid] !=
              current.controllerValues[sliderProperty.oid],
      builder: (context, state) {
        return Expanded(
          flex: sliderProperty.boxLength,
          child: Row(
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
                    value: state.controllerValues[sliderProperty.oid] != null
                        ? double.parse(
                            state.controllerValues[sliderProperty.oid]!)
                        : sliderProperty.min,
                    onChanged: isEditing && !sliderProperty.readOnly
                        ? (value) {
                            String strValue = isInteger(sliderProperty.interval)
                                ? value.toInt().toString()
                                : truncateDecimal(value).toString();

                            context.read<DeviceBloc>().add(
                                ControllerValueChanged(
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
                    state.controllerValues[sliderProperty.oid]!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: sliderProperty.fontSize),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 12.0)),
            ],
          ),
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
          previous.isEditing != current.isEditing ||
          previous.controllerValues[dropDownMenuProperty.oid] !=
              current.controllerValues[dropDownMenuProperty.oid],
      builder: (context, state) {
        return Expanded(
          flex: dropDownMenuProperty.boxLength,
          child: DecoratedBox(
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
                  value: state.controllerValues[dropDownMenuProperty.oid]
                      .toString(),
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
                                color:
                                    isEditing && !dropDownMenuProperty.readOnly
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
          ),
        );
      },
    );
  }
}
