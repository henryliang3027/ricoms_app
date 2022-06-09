import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/view/device_history_form.dart';
import 'package:ricoms_app/root/view/device_setting_form.dart';

class DeviceSettingPage extends StatefulWidget {
  const DeviceSettingPage({
    Key? key,
    required this.deviceRepository,
    required this.name,
  }) : super(key: key);

  static Route route(DeviceRepository deviceRepository, String name) {
    return MaterialPageRoute(
        builder: (_) => DeviceSettingPage(
              deviceRepository: deviceRepository,
              name: name,
            ));
  }

  final DeviceRepository deviceRepository;
  final String name;

  @override
  State<DeviceSettingPage> createState() => _DeviceSettingPageState();
}

class _DeviceSettingPageState extends State<DeviceSettingPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    // 建立 TabController，vsync 接受的型態是 TickerProvider

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.deviceRepository.createDeviceBlock(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List) {
            tabController = TabController(
                length: (snapshot.data as List).length + 1, vsync: this);
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.name),
                bottom: TabBar(
                  isScrollable: true,
                  tabs: [
                    for (var item in snapshot.data) Tab(text: item['name']),
                    const Tab(text: 'History')
                  ],
                  controller: tabController,
                ),
              ),
              body: TabBarView(
                children: [
                  for (var item in snapshot.data) ...[
                    DeviceSettingForm(
                      deviceRepository: widget.deviceRepository,
                      pageName: item['name'],
                    )
                  ],
                  DeviceHistoryForm(
                    deviceRepository: widget.deviceRepository,
                  ),
                ],
                controller: tabController,
              ),
            );
          } else {
            //String
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
              body: Center(
                child: Text("Error: ${snapshot.data}"),
              ),
            );
          }
        } else {
          //no response
          //catch exception
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }
      },
    );
  }
}
