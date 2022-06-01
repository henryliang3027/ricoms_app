import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/threshold/threshold_bloc.dart';
import 'package:ricoms_app/root/view/configuration_form.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/root/view/description_form.dart';
import 'package:ricoms_app/root/view/status_form.dart';
import 'package:ricoms_app/root/view/threshold_form.dart';

class DeviceSettingPage extends StatefulWidget {
  const DeviceSettingPage({
    Key? key,
    required this.rootRepository,
  }) : super(key: key);

  static Route route(RootRepository rootRepository) {
    return MaterialPageRoute(
        builder: (_) => DeviceSettingPage(
              rootRepository: rootRepository,
            ));
  }

  final RootRepository rootRepository;

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
      future: widget.rootRepository.createDeviceBlock(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List) {
            tabController = TabController(
                length: (snapshot.data as List).length, vsync: this);
            return Scaffold(
              appBar: AppBar(
                title: Text('A8K'),
                bottom: TabBar(
                  isScrollable: true,
                  tabs: [
                    for (var item in snapshot.data) Tab(text: item['name']),
                  ],
                  controller: tabController,
                ),
              ),
              body: TabBarView(
                children: [
                  for (var item in snapshot.data)
                    if (item['name'] == 'Status') ...[
                      StatusForm(rootRepository: widget.rootRepository)
                    ] else if (item['name'] == 'Threshold') ...[
                      ThresholdForm(rootRepository: widget.rootRepository),
                    ] else if (item['name'] == 'Configuration') ...[
                      ConfigurationForm(rootRepository: widget.rootRepository),
                    ] else if (item['name'] == 'Description') ...[
                      DescriptionForm(rootRepository: widget.rootRepository),
                    ] else ...[
                      const Center(
                        child: Text('Comming soon!'),
                      )
                    ]
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
