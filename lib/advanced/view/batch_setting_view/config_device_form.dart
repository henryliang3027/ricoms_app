import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/advanced/bloc/batch_setting/config_device/config_device_bloc.dart';
import 'package:ricoms_app/advanced/view/batch_setting_view/device_setting_result_page.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/repository/batch_setting_device.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/view/device_setting_style.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class ConfigDeviceForm extends StatelessWidget {
  const ConfigDeviceForm({
    Key? key,
    required this.devices,
  }) : super(key: key);

  final List<BatchSettingDevice> devices;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfigDeviceBloc, ConfigDeviceState>(
      listener: (context, state) {},
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.deviceSetting,
          ),
          elevation: 0.0,
        ),
        body: _DeviceSettingTabView(devices: devices),
      ),
    );
  }
}

class _DeviceSettingTabView extends StatelessWidget {
  const _DeviceSettingTabView({Key? key, required this.devices})
      : super(key: key);

  final List<BatchSettingDevice> devices;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigDeviceBloc, ConfigDeviceState>(
      buildWhen: (previous, current) =>
          previous.isInitialController == true &&
          current.isInitialController == true,
      builder: (context, state) {
        if (state.status.isRequestSuccess) {
          print('isRequestSuccess');
          return DefaultTabController(
            length: state.deviceBlocks.length,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.maxFinite,
                  color: Colors.blue,
                  child: Center(
                    child: TabBar(
                      unselectedLabelColor: Colors.white,
                      labelColor: Colors.blue,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.white,
                      ),
                      labelPadding:
                          const EdgeInsets.symmetric(horizontal: 24.0),
                      tabs: [
                        for (DeviceBlock deviceBlock in state.deviceBlocks)
                          Tab(
                            child: SizedBox(
                              width: 130,
                              child: Center(
                                child: Text(
                                  getMessageLocalization(
                                    msg: deviceBlock.name,
                                    context: context,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (DeviceBlock deviceBlock in state.deviceBlocks) ...[
                        _DeviceSettingSubPage(
                          pageId: deviceBlock.id,
                          controllerPropertiesCollection:
                              state.controllerPropertiesCollectionMap[
                                  deviceBlock.id]!,
                          devices: devices,
                        )
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state.status.isRequestFailure) {
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
                  getMessageLocalization(
                    msg: state.requestErrorMsg,
                    context: context,
                  ),
                ),
                const SizedBox(height: 40.0),
              ],
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

// Using AutomaticKeepAliveClientMixin to keep the widget state so it will not be disppose
class _DeviceSettingSubPage extends StatefulWidget {
  const _DeviceSettingSubPage({
    Key? key,
    required this.pageId,
    required this.controllerPropertiesCollection,
    required this.devices,
  }) : super(key: key);

  final int pageId;
  final List<List<ControllerProperty>> controllerPropertiesCollection;
  final List<BatchSettingDevice> devices;

  @override
  State<_DeviceSettingSubPage> createState() => __DeviceSettingSubPageState();
}

class __DeviceSettingSubPageState extends State<_DeviceSettingSubPage>
    with AutomaticKeepAliveClientMixin {
  Widget _buildItem({
    required int pageId,
    required ControllerProperty controllerProperty,
  }) {
    if (controllerProperty.runtimeType == TextFieldProperty) {
      TextFieldProperty textFieldProperty =
          controllerProperty as TextFieldProperty;

      return _DeviceTextField(
        pageId: pageId,
        textFieldProperty: textFieldProperty,
        textEditingController: TextEditingController()
          ..text = textFieldProperty.initValue,
      );
    } else if (controllerProperty.runtimeType == DropDownMenuProperty) {
      return _DeviceDropDownMenu(
        pageId: pageId,
        dropDownMenuProperty: controllerProperty as DropDownMenuProperty,
      );
    } else if (controllerProperty.runtimeType == SliderProperty) {
      return _DeviceSlider(
        pageId: pageId,
        sliderProperty: controllerProperty as SliderProperty,
      );
    } else if (controllerProperty.runtimeType == RadioButtonProperty) {
      return _DeviceRadioButton(
        pageId: pageId,
        radioButtonProperty: controllerProperty as RadioButtonProperty,
      );
    } else if (controllerProperty.runtimeType == CheckBoxProperty) {
      return _DeviceCheckBox(
        pageId: pageId,
        checkBoxProperty: controllerProperty as CheckBoxProperty,
      );
    } else if (controllerProperty.runtimeType == TextProperty) {
      return _DeviceText(
        pageId: pageId,
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
    required int pageId,
    required List<ControllerProperty> controllerProperties,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (ControllerProperty controllerProperty in controllerProperties) ...[
          _buildItem(
            pageId: pageId,
            controllerProperty: controllerProperty,
          ),
        ]
      ],
    );
  }

  Widget _buildBody() {
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
                        in widget.controllerPropertiesCollection) ...[
                      _buildRaw(
                        pageId: widget.pageId,
                        controllerProperties: controllerProperties,
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: BlocBuilder<ConfigDeviceBloc, ConfigDeviceState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              state.isControllerContainValue.values.contains(true)
                  ? FloatingActionButton(
                      heroTag: null,
                      elevation: 0.0,
                      backgroundColor: const Color(0x742195F3),
                      onPressed: () async {
                        List<Map<String, String>> values =
                            state.controllerValuesMap.values.toList();

                        Map<String, String> deviceParamMap = {};
                        for (Map<String, String> map in values) {
                          deviceParamMap.addAll(map);
                        }

                        deviceParamMap.removeWhere((key, value) => value == '');
                        ;

                        Navigator.push(
                            context,
                            DeviceSettingResultPage.route(
                              devices: widget.devices,
                              devicesParamMap: deviceParamMap,
                            ));
                      },
                      child: const Icon(
                        CustomIcons.check,
                      ),
                      //const Text('Save'),
                    )
                  : const SizedBox(
                      height: 0.0,
                      width: 0.0,
                    ),
              state.isControllerContainValue[widget.pageId]!
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: FloatingActionButton(
                        heroTag: null,
                        elevation: 0.0,
                        backgroundColor: const Color(0x742195F3),
                        onPressed: () {
                          context
                              .read<ConfigDeviceBloc>()
                              .add(ControllerValueCleared(widget.pageId));
                        },
                        child: const Icon(CustomIcons.cancel),
                      ),
                    )
                  : const SizedBox(
                      height: 0.0,
                      width: 0.0,
                    ),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _DeviceText extends StatelessWidget {
  const _DeviceText({
    Key? key,
    required this.pageId,
    required this.textProperty,
  }) : super(key: key);

  final int pageId;
  final TextProperty textProperty;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigDeviceBloc, ConfigDeviceState>(
        buildWhen: (previous, current) =>
            previous.controllerPropertiesCollectionMap[pageId] !=
            current.controllerPropertiesCollectionMap[pageId],
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
    required this.pageId,
    required this.textFieldProperty,
    required this.textEditingController,
  }) : super(key: key);

  final int pageId;
  final TextFieldProperty textFieldProperty;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    print('build _DeviceTextField');
    return BlocBuilder<ConfigDeviceBloc, ConfigDeviceState>(
        buildWhen: (previous, current) =>
            previous.controllerValuesMap[pageId]![textFieldProperty.oid] !=
            current.controllerValuesMap[pageId]![textFieldProperty.oid],
        builder: (context, state) {
          if (state
              .controllerValuesMap[pageId]![textFieldProperty.oid]!.isEmpty) {
            textEditingController.clear();
          }
          return Expanded(
            flex: textFieldProperty.boxLength,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: TextField(
                key: Key(textFieldProperty.oid),
                controller: textEditingController,
                textAlign: textFieldProperty.textAlign,
                maxLines: textFieldProperty.maxLine,
                enabled: !textFieldProperty.readOnly,
                style: TextStyle(fontSize: textFieldProperty.fontSize),
                onChanged: (text) {
                  context.read<ConfigDeviceBloc>().add(ControllerValueChanged(
                        pageId,
                        textFieldProperty.oid,
                        text,
                      ));
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: !textFieldProperty.readOnly
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
    required this.pageId,
    required this.checkBoxProperty,
  }) : super(key: key);

  final int pageId;
  final CheckBoxProperty checkBoxProperty;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigDeviceBloc, ConfigDeviceState>(
      buildWhen: (previous, current) =>
          previous.controllerValuesMap[pageId]![checkBoxProperty.oid] !=
          current.controllerValuesMap[pageId]![checkBoxProperty.oid],
      builder: (context, state) {
        return Expanded(
          flex: checkBoxProperty.boxLength,
          child: Checkbox(
            visualDensity: const VisualDensity(vertical: -4.0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value:
                state.controllerValuesMap[pageId]![checkBoxProperty.oid] == '1'
                    ? true
                    : false,
            onChanged: !checkBoxProperty.readOnly
                ? (value) {
                    if (value != null) {
                      context.read<ConfigDeviceBloc>().add(
                          ControllerValueChanged(
                              pageId, checkBoxProperty.oid, value ? '1' : '0'));
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
    required this.pageId,
    required this.radioButtonProperty,
  }) : super(key: key);

  final int pageId;
  final RadioButtonProperty radioButtonProperty;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigDeviceBloc, ConfigDeviceState>(
      buildWhen: (previous, current) =>
          previous.controllerValuesMap[pageId]![radioButtonProperty.oid] !=
          current.controllerValuesMap[pageId]![radioButtonProperty.oid],
      builder: (context, state) {
        print('build radio button');
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
                        groupValue: state.controllerValuesMap[pageId]![
                            radioButtonProperty
                                .oid], //determine which is selected
                        onChanged: !radioButtonProperty.readOnly
                            ? (String? value) {
                                context.read<ConfigDeviceBloc>().add(
                                    ControllerValueChanged(pageId,
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
    required this.pageId,
    required this.sliderProperty,
  }) : super(key: key);

  final int pageId;
  final SliderProperty sliderProperty;

  @override
  Widget build(BuildContext context) {
    double truncateDecimal(double value) {
      double fixDecimal = double.parse(value.toStringAsFixed(1));
      return double.parse(fixDecimal.toStringAsFixed(
          fixDecimal.truncateToDouble() == fixDecimal ? 0 : 1));
    }

    bool isInteger(num value) => value is int || value == value.roundToDouble();

    return BlocBuilder<ConfigDeviceBloc, ConfigDeviceState>(
      buildWhen: (previous, current) =>
          previous.controllerValuesMap[pageId]![sliderProperty.oid] !=
          current.controllerValuesMap[pageId]![sliderProperty.oid],
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
                    value: state.controllerValuesMap[pageId]![
                                sliderProperty.oid] !=
                            ''
                        ? double.parse(state
                            .controllerValuesMap[pageId]![sliderProperty.oid]!)
                        : sliderProperty.min,
                    onChanged: !sliderProperty.readOnly
                        ? (value) {
                            String strValue = isInteger(sliderProperty.interval)
                                ? value.toInt().toString()
                                : truncateDecimal(value).toString();

                            context.read<ConfigDeviceBloc>().add(
                                ControllerValueChanged(
                                    pageId, sliderProperty.oid, strValue));
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
                    state.controllerValuesMap[pageId]![sliderProperty.oid]!,
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
    required this.pageId,
    required this.dropDownMenuProperty,
  }) : super(key: key);

  final int pageId;
  final DropDownMenuProperty dropDownMenuProperty;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigDeviceBloc, ConfigDeviceState>(
      buildWhen: (previous, current) =>
          previous.controllerValuesMap[pageId]![dropDownMenuProperty.oid] !=
          current.controllerValuesMap[pageId]![dropDownMenuProperty.oid],
      builder: (context, state) {
        return Expanded(
          flex: dropDownMenuProperty.boxLength,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: dropDownMenuProperty.readOnly
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
                  value: state
                      .controllerValuesMap[pageId]![dropDownMenuProperty.oid],
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
                                color: dropDownMenuProperty.readOnly
                                    ? Colors.black
                                    : Colors.black),
                          ),
                        ),
                      )
                  ],
                  onChanged: dropDownMenuProperty.readOnly
                      ? (String? value) {
                          context.read<ConfigDeviceBloc>().add(
                              ControllerValueChanged(
                                  pageId, dropDownMenuProperty.oid, value!));
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
