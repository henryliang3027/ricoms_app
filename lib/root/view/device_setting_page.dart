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
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    // 建立 TabController，vsync 接受的型態是 TickerProvider
    tabController = TabController(length: 4, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('A8K'),
        bottom: TabBar(
          isScrollable: true,
          tabs: const [
            Tab(text: 'Status'),
            //Tab(text: 'Configuration'),
            Tab(text: 'Threshold'),
            Tab(text: 'Description'),
            Tab(text: 'History'),
          ],
          controller: tabController,
        ),
      ),
      body: TabBarView(
        children: [
          StatusForm(rootRepository: widget.rootRepository),
          //ConfigurationForm(rootRepository: widget.rootRepository),
          ThresholdForm(rootRepository: widget.rootRepository),
          DescriptionForm(rootRepository: widget.rootRepository),
          Center(),
        ],
        controller: tabController,
      ),
    );
  }
}
