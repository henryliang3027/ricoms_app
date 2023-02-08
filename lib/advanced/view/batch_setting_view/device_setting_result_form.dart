import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/advanced/bloc/batch_setting/device_setting_result/device_setting_result_bloc.dart';
import 'package:ricoms_app/advanced/view/batch_setting_view/device_setting_result_detail_page.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
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
        actions: const [
          _PopupMenu(),
        ],
      ),
      body: Column(
        children: const [
          Expanded(
            child: _DeviceListView(),
          ),
        ],
      ),
      floatingActionButton: const _RetryFloatingActionButton(),
    );
  }
}

enum Menu {
  selectAll,
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceSettingResultBloc, DeviceSettingResultState>(
        builder: (context, state) {
      bool isContainFailItem = state.deviceProcessingStatusCollection.any(
          (deviceProcessingStatusList) => deviceProcessingStatusList.any(
              (deviceProcessingStatus) =>
                  deviceProcessingStatus == ProcessingStatus.failure));

      bool isProcessing = state.deviceProcessingStatusCollection.any(
          (deviceProcessingStatusList) => deviceProcessingStatusList.any(
              (deviceProcessingStatus) =>
                  deviceProcessingStatus == ProcessingStatus.processing));

      if (!isProcessing && isContainFailItem) {
        return PopupMenuButton<Menu>(
          tooltip: '',
          onSelected: (Menu item) async {
            switch (item) {
              case Menu.selectAll:
                context
                    .read<DeviceSettingResultBloc>()
                    .add(const AllDeviceParamItemsSelected());
                break;
              default:
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
            PopupMenuItem<Menu>(
              value: Menu.selectAll,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.delete_outline,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(AppLocalizations.of(context)!.selectAll),
                ],
              ),
            ),
          ],
        );
      } else {
        return Container();
      }
    });
  }
}

class _DeviceListView extends StatelessWidget {
  const _DeviceListView({
    Key? key,
  }) : super(key: key);

  SliverChildBuilderDelegate _deviceSliverChildBuilderDelegate({
    required List<List<DeviceParamItem>> deviceParamItemsCollection,
    required List<List<ProcessingStatus>> deviceProcessingStatusCollection,
    required List<List<bool>> isSelectedDevicesCollection,
  }) {
    List<DeviceParamItem> flattenDeviceParamItems = [];
    List<ProcessingStatus> flattenDeviceProcessingStatusList = [];
    List<bool> flattenIsSelectedDevices = [];
    for (List<DeviceParamItem> deviceParamItems in deviceParamItemsCollection) {
      flattenDeviceParamItems.addAll(deviceParamItems);
    }
    for (List<ProcessingStatus> deviceProcessingStatusList
        in deviceProcessingStatusCollection) {
      flattenDeviceProcessingStatusList.addAll(deviceProcessingStatusList);
    }
    for (List<bool> isSelectedDevices in isSelectedDevicesCollection) {
      flattenIsSelectedDevices.addAll(isSelectedDevices);
    }

    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        DeviceParamItem device = flattenDeviceParamItems[index];
        ProcessingStatus processingStatus =
            flattenDeviceProcessingStatusList[index];
        bool isSelected = flattenIsSelectedDevices[index];
        return _ParameterItem(
          index: index,
          device: device,
          processingStatus: processingStatus,
          isSelected: isSelected,
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
              current.deviceProcessingStatusCollection ||
          previous.isSelectedDevicesCollection !=
              current.isSelectedDevicesCollection,
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
                  isSelectedDevicesCollection:
                      state.isSelectedDevicesCollection,
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
    required this.isSelected,
  }) : super(key: key);

  final int index;
  final DeviceParamItem device;
  final ProcessingStatus processingStatus;
  final bool isSelected;

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
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              builder: (_) => _DeviceSettingResultBottomMenu(
                parentContext: context,
                deviceParamItem: device,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  Row(
                    children: [
                      const Icon(
                        CustomIcons.cancel,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Checkbox(
                        visualDensity: const VisualDensity(
                            vertical: -4.0, horizontal: -4.0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: isSelected,
                        onChanged: (value) => context
                            .read<DeviceSettingResultBloc>()
                            .add(
                                DeviceParamItemSelected(index, value ?? false)),
                      ),
                    ],
                  ),
                ] else ...[
                  const CircularProgressIndicator(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RetryFloatingActionButton extends StatelessWidget {
  const _RetryFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceSettingResultBloc, DeviceSettingResultState>(
      builder: (context, state) {
        bool isContainSelectedItem = state.isSelectedDevicesCollection.any(
            (isSelectedDevices) =>
                isSelectedDevices.any((isSelected) => isSelected == true));

        print('isContainSelectedItem: $isContainSelectedItem');
        return isContainSelectedItem
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: null,
                    elevation: 0.0,
                    backgroundColor: const Color(0x742195F3),
                    onPressed: () async {
                      context
                          .read<DeviceSettingResultBloc>()
                          .add(const RetryFailedSettingRequested());
                    },
                    child: const Icon(
                      CustomIcons.check,
                    ),
                    //const Text('Save'),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(6.0),
                  ),
                  FloatingActionButton(
                      heroTag: null,
                      elevation: 0.0,
                      backgroundColor: const Color(0x742195F3),
                      onPressed: () {
                        context
                            .read<DeviceSettingResultBloc>()
                            .add(const AllDeviceParamItemsDeselected());
                      },
                      child: const Icon(CustomIcons.cancel)),
                ],
              )
            : Container();
      },
    );
  }
}

class _DeviceSettingResultBottomMenu extends StatelessWidget {
  const _DeviceSettingResultBottomMenu({
    Key? key,
    required this.parentContext,
    required this.deviceParamItem,
  }) : super(key: key);

  final BuildContext parentContext;
  final DeviceParamItem deviceParamItem;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          dense: true,
          leading: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300, shape: BoxShape.circle),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: Icon(
                  Icons.info_outline,
                ),
              ),
            ),
          ),
          title: Text(
            AppLocalizations.of(context)!.showDetail,
            style: const TextStyle(fontSize: CommonStyle.sizeM),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context, DeviceSettingResultDetailPage.route(deviceParamItem));
          },
        ),
      ],
    );
  }
}
