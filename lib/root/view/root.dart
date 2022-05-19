import 'package:flutter/material.dart';
import 'package:ricoms_app/root/view/device_setting.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, DeviceSettingPage.route());
            },
            child: Text('test A8KMF3')),
      ),
    );
  }
}
