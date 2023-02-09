import 'package:flutter/material.dart';
import 'package:ricoms_app/advanced/bloc/batch_setting/device_setting_result/device_setting_result_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeviceSettingResultDetailPage extends StatelessWidget {
  const DeviceSettingResultDetailPage({
    Key? key,
    required this.deviceParamItem,
    required this.resultDetail,
  }) : super(key: key);

  static Route route(
    DeviceParamItem deviceParamItem,
    ResultDetail resultDetail,
  ) {
    return MaterialPageRoute(
      builder: (_) => DeviceSettingResultDetailPage(
        deviceParamItem: deviceParamItem,
        resultDetail: resultDetail,
      ),
    );
  }

  final DeviceParamItem deviceParamItem;
  final ResultDetail resultDetail;

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

  String _getStatus(BuildContext context, ProcessingStatus processingStatus) {
    if (processingStatus == ProcessingStatus.success) {
      return AppLocalizations.of(context)!.paramSettingSuccessful;
    } else if (processingStatus == ProcessingStatus.failure) {
      return AppLocalizations.of(context)!.paramSettingFailed;
    } else {
      return AppLocalizations.of(context)!.paramSettingProcessing;
    }
  }

  Color _getFontColor(ProcessingStatus processingStatus) {
    if (processingStatus == ProcessingStatus.success) {
      return const Color(0xffffffff);
    } else if (processingStatus == ProcessingStatus.failure) {
      return const Color(0xffffffff);
    } else {
      return const Color(0xff000000);
    }
  }

  Color _getBackgroundColor(ProcessingStatus processingStatus) {
    if (processingStatus == ProcessingStatus.success) {
      return const Color(0xff28a745);
    } else if (processingStatus == ProcessingStatus.failure) {
      return const Color(0xffdc3545);
    } else {
      return const Color(0xFFF5F5F5);
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
              _StatusIcon(
                processingStatus: resultDetail.processingStatus,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.paramSettingStatus,
                initialValue: _getStatus(
                  context,
                  resultDetail.processingStatus,
                ),
                fontColor: _getFontColor(
                  resultDetail.processingStatus,
                ),
                backgroundColor: _getBackgroundColor(
                  resultDetail.processingStatus,
                ),
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.paramSettingEndTime,
                initialValue: resultDetail.endTime,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.ip,
                initialValue: deviceParamItem.ip,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.group,
                initialValue: deviceParamItem.group,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.name,
                initialValue: _getDisplayName(deviceParamItem),
              ),
              _DescriptionItem(
                labelText: AppLocalizations.of(context)!.description,
                initialValue: resultDetail.description,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({
    Key? key,
    required this.processingStatus,
  }) : super(key: key);

  final ProcessingStatus processingStatus;

  @override
  Widget build(BuildContext context) {
    if (processingStatus == ProcessingStatus.success) {
      return const Padding(
        padding: EdgeInsets.all(CommonStyle.lineSpacing),
        child: Center(
          child: Icon(
            CustomIcons.check,
            size: 40.0,
            color: Color(0xff28a745),
          ),
        ),
      );
    } else if (processingStatus == ProcessingStatus.failure) {
      return const Padding(
        padding: EdgeInsets.all(CommonStyle.lineSpacing),
        child: Center(
          child: Icon(
            CustomIcons.cancel,
            size: 40.0,
            color: Color(0xffdc3545),
          ),
        ),
      );
    } else {
      return const SizedBox(
        height: 0.0,
        width: 0.0,
      );
    }
    ;
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
    this.backgroundColor = const Color(0xFFF5F5F5),
  }) : super(key: key);

  final Color fontColor;
  final Color backgroundColor;
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
            fillColor: backgroundColor,
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
