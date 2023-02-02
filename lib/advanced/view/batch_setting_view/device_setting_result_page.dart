import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/batch_setting_device.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeviceSettingResultPage extends StatelessWidget {
  const DeviceSettingResultPage({
    Key? key,
    required this.devices,
    required this.devicesParamMap,
  }) : super(key: key);

  static Route route({
    required List<BatchSettingDevice> devices,
    required Map<String, String> devicesParamMap,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          DeviceSettingResultPage(
        devices: devices,
        devicesParamMap: devicesParamMap,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  final List<BatchSettingDevice> devices;
  final Map<String, String> devicesParamMap;

  @override
  Widget build(BuildContext context) {
    List<DeviceParamItem> _getDeviceParamItems() {
      List<DeviceParamItem> deviceParamItems = [];
      for (BatchSettingDevice device in devices) {
        for (MapEntry entry in devicesParamMap.entries) {
          deviceParamItems.add(DeviceParamItem(
            id: device.id,
            ip: device.ip,
            deviceName: device.deviceName,
            group: device.group,
            moduleName: device.moduleName,
            shelf: device.shelf,
            slot: device.slot,
            oid: entry.key,
            param: entry.value,
          ));
        }
      }

      return deviceParamItems;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.selectDevice,
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _DeviceListView(
              deviceParamItem: _getDeviceParamItems(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceListView extends StatelessWidget {
  const _DeviceListView({
    Key? key,
    required this.deviceParamItem,
  }) : super(key: key);

  final List<DeviceParamItem> deviceParamItem;

  String _getDisplayName(DeviceParamItem device) {
    if (device.deviceName.isNotEmpty) {
      //a8k slot
      if (device.shelf == 0 && device.slot == 1) {
        return '${device.moduleName} [ ${device.deviceName} / PCM2 (L) ]';
      } else if (device.shelf != 0 && device.slot == 0) {
        return '${device.moduleName} [ ${device.deviceName} / Shelf ${device.shelf} / FAN ]';
      } else {
        return '${device.moduleName} [ ${device.deviceName} / Shelf ${device.shelf} / Slot ${device.slot} ]';
      }
    } else {
      return device.moduleName;
    }
  }

  SliverChildBuilderDelegate _deviceSliverChildBuilderDelegate({
    required List<DeviceParamItem> data,
  }) {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        DeviceParamItem device = data[index];
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Material(
            color: index.isEven ? Colors.grey.shade100 : Colors.white,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 6.0),
                            child: Text(
                              device.ip,
                              //maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: CommonStyle.sizeL,
                                // fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 4.0),
                            child: Text(
                              device.group,
                              //maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: CommonStyle.sizeM,
                                color: Colors.grey.shade700,
                                // fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 0.0, 6.0, 0.0),
                                  child: Text(
                                    _getDisplayName(device),
                                    //maxLines: 2,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                      fontSize: CommonStyle.sizeM,
                                      color: Colors.grey.shade700,
                                      // fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 0.0, 6.0, 0.0),
                                  child: Text(
                                    '${device.id}  ${device.oid}  ${device.param}',
                                    //maxLines: 2,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                      fontSize: CommonStyle.sizeM,
                                      color: Colors.grey.shade700,
                                      // fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    // Checkbox(
                    //   visualDensity: const VisualDensity(vertical: -4.0),
                    //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //   value: selectedDevices[device],
                    //   onChanged: (value) => context
                    //       .read<SelectDeviceBloc>()
                    //       .add(DeviceItemToggled(
                    //         device,
                    //         value ?? false,
                    //       )),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      childCount: data.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: Scrollbar(
        thickness: 8.0,
        child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: _deviceSliverChildBuilderDelegate(
              data: deviceParamItem,
            )),
          ],
        ),
      ),
    );
  }
}

class DeviceParamItem {
  const DeviceParamItem({
    required this.id,
    required this.ip,
    required this.deviceName,
    required this.group,
    required this.moduleName,
    required this.shelf,
    required this.slot,
    required this.oid,
    required this.param,
  });

  final int id;
  final String ip;
  final String deviceName;
  final String group;
  final String moduleName;
  final int shelf;
  final int slot;
  final String oid;
  final String param;
}
