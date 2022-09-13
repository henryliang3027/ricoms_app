import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/history_repository.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/display_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryDetailPage extends StatelessWidget {
  const HistoryDetailPage({Key? key, required this.record}) : super(key: key);

  static Route route(Record record) {
    return MaterialPageRoute(
      builder: (_) => HistoryDetailPage(record: record),
    );
  }

  final Record record;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                padding: EdgeInsets.symmetric(vertical: 30.0),
              ),
              _SevrtityItem(
                labelText: AppLocalizations.of(context)!.severity,
                initialValue: record.severity,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.timeReceived,
                initialValue: record.receivedTime,
              ),
              _Item(
                labelText: 'IP',
                initialValue: record.ip,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.group,
                initialValue: record.group,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.model,
                initialValue: record.model,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.name,
                initialValue: DisplayStyle.getDeviceDisplayName(record),
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.event,
                initialValue: record.event,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.value,
                initialValue: record.value,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.clearTime,
                initialValue: record.clearTime,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.alarmDuration,
                initialValue: record.alarmDuration,
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
