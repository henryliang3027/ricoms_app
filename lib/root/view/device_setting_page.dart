import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/view/custom_style.dart';

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
    //print('123123');

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
      body: FutureBuilder<List>(
        future: widget.rootRepository.getDeviceStatus(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return TabBarView(
              children: [
                StatusForm(
                  items: snapshot.data as List,
                ),
                ThresholdForm(),
                Icon(Icons.directions_bike),
                Icon(Icons.directions_boat),
              ],
              controller: tabController,
            );
          }
        },
      ),
    );
  }
}

class StatusForm extends StatelessWidget {
  const StatusForm({Key? key, required this.items}) : super(key: key);

  final List items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var item in items)
            if (item.length == 3) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 6.0),
                      child: CustomStyle.getBox(
                          item[0]['style'], item[0]['value']),
                    ),
                  ),
                  //CustomStyle.getBox(item[1]['style'], item[1]['value']),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CustomStyle.getBox(
                          item[2]['style'], item[2]['value']),
                    ),
                  ),
                ],
              )
            ] else if (item.length == 1) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CustomStyle.getBox(
                          item[0]['style'], item[0]['value']),
                    ),
                  ),
                ],
              ),
            ]
        ],
      ),
    );
  }
}

class ThresholdForm extends StatefulWidget {
  const ThresholdForm({Key? key}) : super(key: key);

  @override
  State<ThresholdForm> createState() => _ThresholdFormState();
}

class _ThresholdFormState extends State<ThresholdForm>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    print('build Threshold');
    return const Center(
      child: Icon(Icons.directions_transit),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
