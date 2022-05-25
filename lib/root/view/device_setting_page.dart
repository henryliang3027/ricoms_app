import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/root_repository.dart';

class DeviceSettingPage extends StatefulWidget {
  const DeviceSettingPage({Key? key, required this.rootRepository})
      : super(key: key);

  static Route route(RootRepository rootRepository) {
    return MaterialPageRoute(
        builder: (_) => DeviceSettingPage(rootRepository: rootRepository));
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
    widget.rootRepository.getDeviceStatus();

    return Scaffold(
      appBar: AppBar(
        title: Text('A8K'),
        bottom: TabBar(
          isScrollable: true,
          tabs: const [
            Tab(text: 'Status'),
            Tab(text: 'Threshold'),
            Tab(text: 'Description'),
            Tab(text: 'History'),
          ],
          controller: tabController,
        ),
      ),
      body: TabBarView(
        children: const [
          StatusForm(
            items: [],
          ),
          Icon(Icons.directions_transit),
          Icon(Icons.directions_bike),
          Icon(Icons.directions_boat),
        ],
        controller: tabController,
      ),
    );
  }
}

class StatusForm extends StatelessWidget {
  const StatusForm({Key? key, required List items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
  }
}
