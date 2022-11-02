import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/system_log_repository.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/display_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SystemLogDetailPage extends StatelessWidget {
  const SystemLogDetailPage({Key? key, required this.log}) : super(key: key);

  static Route route(Log log) {
    return MaterialPageRoute(
      builder: (_) => SystemLogDetailPage(log: log),
    );
  }

  final Log log;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                labelText: AppLocalizations.of(context)!.systemLogType,
                initialValue: log.logType,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.account,
                initialValue: log.account,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.permission,
                initialValue: log.permission,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.department,
                initialValue: log.model,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.userIP,
                initialValue: log.userIP,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.timeReceived,
                initialValue: log.startTime,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.deviceIP,
                initialValue: log.deviceIP,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.group,
                initialValue: log.group,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.model,
                initialValue: log.model,
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.name,
                initialValue:
                    DisplayStyle.getSystemLogDeviceTypeDeviceDisplayName(log),
              ),
              _Item(
                labelText: AppLocalizations.of(context)!.event,
                initialValue: log.event,
              ),
              _DescriptionItem(
                labelText: AppLocalizations.of(context)!.description,
                initialValue: log.description,
              ),
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
