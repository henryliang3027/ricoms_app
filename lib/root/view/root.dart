import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/view/device_setting_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    RootRepository rootRepository = RepositoryProvider.of<RootRepository>(
      context,
    );

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
              onPressed: () {
                print('textfield text : ${_controller.text}');
                rootRepository.deviceNodeId = _controller.text;
                Navigator.push(
                    context, DeviceSettingPage.route(rootRepository));
              },
              child: Text('test A8K')),
        ],
      ),
    );
  }
}
