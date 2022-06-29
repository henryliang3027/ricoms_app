import 'package:flutter/material.dart';
import 'package:ricoms_app/app.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';

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
        title: const Text('Detail'),
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
              _Item(
                labelText: 'Severity',
                initialValue:
                    CustomStyle.severityName[deviceHistoryData.severity] ??
                        'Undefined',
                fontColor:
                    CustomStyle.severityColor[deviceHistoryData.severity] ??
                        Colors.black,
              ),
              _Item(
                labelText: 'Event',
                initialValue: deviceHistoryData.event,
              ),
              _Item(
                labelText: 'Time Received',
                initialValue: deviceHistoryData.timeReceived,
              ),
              _Item(
                labelText: 'Clear Time',
                initialValue: deviceHistoryData.clearTime,
              ),
              _Item(
                labelText: 'Alarm Duration',
                initialValue: deviceHistoryData.alarmDuration,
              ),
            ],
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
