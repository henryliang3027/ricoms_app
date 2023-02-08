import 'package:flutter/material.dart';
import 'package:ricoms_app/advanced/bloc/batch_setting/device_setting_result/device_setting_result_bloc.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/display_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeviceSettingResultDetailPage extends StatelessWidget {
  const DeviceSettingResultDetailPage({Key? key, required this.deviceParamItem})
      : super(key: key);

  static Route route(DeviceParamItem deviceParamItem) {
    return MaterialPageRoute(
      builder: (_) =>
          DeviceSettingResultDetailPage(deviceParamItem: deviceParamItem),
    );
  }

  final DeviceParamItem deviceParamItem;

  String _getDisplayName(DeviceParamItem device) {
    if (device.deviceName.isNotEmpty) {
      //a8k slot
      if (device.shelf == 0 && device.slot == 1) {
        return '${device.moduleName} [ ${device.deviceName} / PCM2 (L) ]';
      } else if (device.shelf != 0 && device.slot == 0) {
        return '${device.moduleName} [ ${device.deviceName} / Shelf ${device.shelf} / FAN ]';
      } else {
        return '${device.moduleName} [ ${device.deviceName} / Shelf ${device.shelf} / Slot ${device.slot} ]';
      }
    } else {
      return device.moduleName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.detail,
        ),
        elevation: 0.0,
      ),
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.ip,
                initialValue: deviceParamItem.ip,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.group,
                initialValue: deviceParamItem.group,
              ),
              // _DescriptionItem(
              //   labelText: AppLocalizations.of(context)!.description,
              //   initialValue: log.description,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DescriptionItem extends StatelessWidget {
  const _DescriptionItem({
    Key? key,
    required this.labelText,
    required this.initialValue,
  }) : super(key: key);

  final String labelText;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(CommonStyle.lineSpacing),
      child: SizedBox(
        width: 230,
        child: TextFormField(
          readOnly: true,
          maxLines: 6,
          initialValue: initialValue,
          textInputAction: TextInputAction.done,
          style: const TextStyle(
            fontSize: CommonStyle.sizeL,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            isDense: true,
            filled: true,
            fillColor: Colors.grey.shade100,
            labelText: labelText,
            labelStyle: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    Key? key,
    required this.labelText,
    required this.initialValue,
    this.fontColor = Colors.black,
  }) : super(key: key);

  final Color fontColor;
  final String labelText;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(CommonStyle.lineSpacing),
      child: SizedBox(
        width: 230,
        child: TextFormField(
          readOnly: true,
          // enabled: false,
          initialValue: initialValue,
          textInputAction: TextInputAction.done,
          style: TextStyle(
            fontSize: CommonStyle.sizeL,
            color: fontColor,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            isDense: true,
            filled: true,
            fillColor: Colors.grey.shade100,
            labelText: labelText,
            labelStyle: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ),
    );
  }
}
