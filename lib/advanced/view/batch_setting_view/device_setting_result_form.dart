import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/advanced/bloc/batch_setting/device_setting_result/device_setting_result_bloc.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeviceSettingResultForm extends StatelessWidget {
  const DeviceSettingResultForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.batchSettingResult,
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: const [
          Expanded(
            child: _DeviceListView(),
          ),
        ],
      ),
    );
  }
}

class _DeviceListView extends StatelessWidget {
  const _DeviceListView({
    Key? key,
  }) : super(key: key);

  SliverChildBuilderDelegate _deviceSliverChildBuilderDelegate({
    required List<List<DeviceParamItem>> deviceParamItemsCollection,
    required List<List<ProcessingStatus>> deviceProcessingStatusCollection,
  }) {
    List<DeviceParamItem> flattenDeviceParamItems = [];
    List<ProcessingStatus> flattenDeviceProcessingStatusList = [];
    for (List<DeviceParamItem> deviceParamItems in deviceParamItemsCollection) {
      flattenDeviceParamItems.addAll(deviceParamItems);
    }
    for (List<ProcessingStatus> deviceProcessingStatusList
        in deviceProcessingStatusCollection) {
      flattenDeviceProcessingStatusList.addAll(deviceProcessingStatusList);
    }

    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        DeviceParamItem device = flattenDeviceParamItems[index];
        ProcessingStatus processingStatus =
            flattenDeviceProcessingStatusList[index];
        return _ParameterItem(
          index: index,
          device: device,
          processingStatus: processingStatus,
        );
      },
      childCount: flattenDeviceParamItems.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceSettingResultBloc, DeviceSettingResultState>(
      buildWhen: (previous, current) =>
          previous.deviceProcessingStatusCollection !=
          current.deviceProcessingStatusCollection,
      builder: (context, state) => Container(
        color: Colors.grey.shade300,
        child: Scrollbar(
          thickness: 8.0,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: _deviceSliverChildBuilderDelegate(
                  deviceParamItemsCollection: state.deviceParamItemsCollection,
                  deviceProcessingStatusCollection:
                      state.deviceProcessingStatusCollection,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ParameterItem extends StatelessWidget {
  const _ParameterItem({
    Key? key,
    required this.index,
    required this.device,
    required this.processingStatus,
  }) : super(key: key);

  final int index;
  final DeviceParamItem device;
  final ProcessingStatus processingStatus;

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

  @override
  Widget build(BuildContext context) {
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
                        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 6.0),
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
                        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 4.0),
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
                if (processingStatus == ProcessingStatus.success) ...[
                  const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                ] else if (processingStatus == ProcessingStatus.failure) ...[
                  const Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                  ),
                ] else ...[
                  const CircularProgressIndicator(),
                ]
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
  }
}
