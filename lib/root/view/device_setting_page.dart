import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/view/device_history_form.dart';
import 'package:ricoms_app/root/view/device_setting_form.dart';
import 'package:ricoms_app/utils/common_style.dart';

class DeviceSettingPage extends StatefulWidget {
  const DeviceSettingPage({
    Key? key,
    required this.user,
    required this.deviceRepository,
    required this.node,
  }) : super(key: key);

  static Route route(
    User user,
    DeviceRepository deviceRepository,
    Node node,
  ) {
    return MaterialPageRoute(
        builder: (_) => DeviceSettingPage(
              user: user,
              deviceRepository: deviceRepository,
              node: node,
            ));
  }

  final User user;
  final DeviceRepository deviceRepository;
  final Node node;

  @override
  State<DeviceSettingPage> createState() => _DeviceSettingPageState();
}

class _DeviceSettingPageState extends State<DeviceSettingPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
  }

  bool isA8KPCM2() {
    if (widget.node.name.startsWith(CommonStyle.a8KPCM2Name)) {
      //some name of pcm2 are 'A8KPCM2(L)' or 'A8KPCM2'
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.deviceRepository.createDeviceBlock(user: widget.user),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List) {
            tabController = TabController(
                length: isA8KPCM2()
                    ? (snapshot.data as List).length
                    : (snapshot.data as List).length + 1,
                vsync: this);
            return Scaffold(
              appBar: AppBar(
                //shape: Border(bottom: BorderSide(color: Colors.black)),
                elevation: 0.0,
                backgroundColor: Colors.white,

                //title: Text(widget.node.name),
                centerTitle: true,
                titleSpacing: 0.0,
                title: TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.blue,
                  isScrollable: true,
                  tabs: [
                    if (isA8KPCM2()) ...[
                      for (var item in snapshot.data) Tab(text: item['name']),
                    ] else ...[
                      for (var item in snapshot.data) Tab(text: item['name']),
                      const Tab(text: 'History')
                    ]
                  ],
                  controller: tabController,
                ),
              ),
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  if (isA8KPCM2()) ...[
                    for (var item in snapshot.data) ...[
                      DeviceSettingForm(
                        user: widget.user,
                        deviceRepository: widget.deviceRepository,
                        pageName: item['name'],
                      )
                    ],
                  ] else ...[
                    for (var item in snapshot.data) ...[
                      DeviceSettingForm(
                        user: widget.user,
                        deviceRepository: widget.deviceRepository,
                        pageName: item['name'],
                      )
                    ],
                    DeviceHistoryForm(
                      user: widget.user,
                      deviceRepository: widget.deviceRepository,
                    ),
                  ],
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
                child: Text(snapshot.data),
              ),
            );
          }
        } else {
          //wait for data
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
