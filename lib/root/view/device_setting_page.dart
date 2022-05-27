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

class StatusForm extends StatefulWidget {
  const StatusForm({Key? key, required this.items}) : super(key: key);

  final List items;

  @override
  State<StatusForm> createState() => _StatusFormState();
}

class _StatusFormState extends State<StatusForm>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    print('build Status');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var item in widget.items)
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

  @override
  bool get wantKeepAlive => false;
}

class ThresholdForm extends StatefulWidget {
  ThresholdForm({Key? key, required this.items}) : super(key: key);

  final List items;
  late final Map<String, bool> checkBoxValues = <String, bool>{};
  late final Map<String, TextEditingController> TextFieldControllers =
      <String, TextEditingController>{};

  @override
  State<ThresholdForm> createState() => _ThresholdFormState();
}

class _ThresholdFormState extends State<ThresholdForm>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    print('build Threshold');

    Widget buildController(int style, String name) {
      if (style == 0) {
        return TextField();
      } else if (style == 99) {
        return Checkbox(
          value: widget.checkBoxValues[name] ?? true,
          onChanged: (value) {
            setState(() {
              widget.checkBoxValues[name] = value ?? false;
            });
          },
        );
      } else {
        return Container();
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var item in widget.items)
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
                      child:
                          buildController(item[2]['style'], item[0]['value']),
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

  @override
  bool get wantKeepAlive => false;
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
