import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/root_repository/device_repository.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeviceHistoryDetailPage extends StatelessWidget {
  const DeviceHistoryDetailPage({Key? key, required this.deviceHistoryData})
      : super(key: key);

  static Route route(DeviceHistoryData deviceHistoryData) {
    return MaterialPageRoute(
      builder: (_) =>
          DeviceHistoryDetailPage(deviceHistoryData: deviceHistoryData),
    );
  }

  final DeviceHistoryData deviceHistoryData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          AppLocalizations.of(context)!.detail,
        ),
      ),
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0),
              ),
              _SevrtityItem(
                labelText: AppLocalizations.of(context)!.severity,
                initialValue: deviceHistoryData.severity,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.event,
                initialValue: deviceHistoryData.event,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.timeReceived,
                initialValue: deviceHistoryData.timeReceived,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.clearTime,
                initialValue: deviceHistoryData.clearTime,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.alarmDuration,
                initialValue: deviceHistoryData.alarmDuration,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SevrtityItem extends StatelessWidget {
  const _SevrtityItem({
    Key? key,
    required this.labelText,
    required this.initialValue,
  }) : super(key: key);

  final String labelText;
  final int initialValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(CommonStyle.lineSpacing),
      child: SizedBox(
        width: 230,
        child: TextFormField(
          readOnly: true,
          // enabled: false,
          initialValue: CustomStyle.severityName[initialValue],
          textInputAction: TextInputAction.done,
          style: TextStyle(
            fontSize: CommonStyle.sizeL,
            color: CustomStyle.severityFontColor[initialValue],
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
            fillColor: CustomStyle.severityColor[initialValue],
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
          // enabled: false,
          initialValue: initialValue,
          textInputAction: TextInputAction.done,
          style: const TextStyle(
            fontSize: CommonStyle.sizeL,
            color: Colors.black,
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
