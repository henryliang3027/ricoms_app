import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/root/view/status_form.dart';
import 'package:ricoms_app/root/view/threshold_form.dart';

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
      body: TabBarView(
        children: [
          FutureBuilder<dynamic>(
            future: widget.rootRepository.getDeviceStatus(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.data is List) {
                  return StatusForm(
                    items: snapshot.data as List,
                  );
                } else {
                  String errnsg = snapshot.data;
                  return Center(
                    child: Text(errnsg),
                  );
                }
              }
            },
          ),
          FutureBuilder<dynamic>(
            future: widget.rootRepository.getDeviceThreshold(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.data is List) {
                  return ThresholdForm(
                    items: snapshot.data as List,
                  );
                } else {
                  String errnsg = snapshot.data;
                  return Center(
                    child: Text(errnsg),
                  );
                }
              }
            },
          ),
          DescriptionForm(),
          HistoryForm(),
        ],
        controller: tabController,
      ),
    );
  }
}

class DescriptionForm extends StatefulWidget {
  const DescriptionForm({Key? key}) : super(key: key);

  @override
  State<DescriptionForm> createState() => _DescriptionFormState();
}

class _DescriptionFormState extends State<DescriptionForm>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  bool get wantKeepAlive => false;
}

class HistoryForm extends StatefulWidget {
  const HistoryForm({Key? key}) : super(key: key);

  @override
  State<HistoryForm> createState() => _HistoryFormState();
}

class _HistoryFormState extends State<HistoryForm>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  bool get wantKeepAlive => false;
}
