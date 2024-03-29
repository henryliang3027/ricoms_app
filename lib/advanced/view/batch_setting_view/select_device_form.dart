import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/advanced/bloc/batch_setting/select_device/select_device_bloc.dart';
import 'package:ricoms_app/advanced/view/batch_setting_view/config_device_page.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/repository/advanced_repository/batch_setting_repository/batch_setting_device.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class SelectDeviceForm extends StatelessWidget {
  const SelectDeviceForm({
    Key? key,
    required this.moduleId,
  }) : super(key: key);

  final int moduleId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectDeviceBloc, SelectDeviceState>(
      listener: (context, state) {},
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.selectDevice,
          ),
          elevation: 0.0,
          actions: const [
            _PopupMenu(),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _KeywordInput(),
            const Expanded(
              child: _DeviceListView(),
            ),
          ],
        ),
        floatingActionButton: _DeviceSelectionEditFloatingActionButton(
          moduleId: moduleId,
        ),
      ),
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
    return BlocBuilder<SelectDeviceBloc, SelectDeviceState>(
        builder: (context, state) {
      if (state.status.isRequestSuccess) {
        return PopupMenuButton<Menu>(
          icon: const Icon(
            Icons.more_vert_outlined,
            color: Colors.white,
          ),
          tooltip: '',
          onSelected: (Menu item) async {
            switch (item) {
              case Menu.selectAll:
                context
                    .read<SelectDeviceBloc>()
                    .add(const AllDeviceItemsSelected());
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

class _KeywordInput extends StatelessWidget {
  _KeywordInput({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectDeviceBloc, SelectDeviceState>(
        buildWhen: (previous, current) => previous.keyword != current.keyword,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (String? keyword) {
                if (keyword != null) {
                  context
                      .read<SelectDeviceBloc>()
                      .add(KeywordSearched(keyword));
                }
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(6),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0),
                ),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                labelText: AppLocalizations.of(context)!.searchHint,
                labelStyle: const TextStyle(
                  fontSize: CommonStyle.sizeL,
                ),
                floatingLabelStyle: const TextStyle(
                  color: Colors.black,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
                suffixIconConstraints: state.keyword.isNotEmpty
                    ? const BoxConstraints(
                        maxHeight: 34,
                        maxWidth: 34,
                        minHeight: 34,
                        minWidth: 34)
                    : null,
                suffixIcon: state.keyword.isNotEmpty
                    ? Material(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(4.0),
                          bottomRight: Radius.circular(4.0),
                        ),
                        color: Colors.grey,
                        child: IconButton(
                          color: Colors.white,
                          splashColor: Colors.blue.shade100,
                          icon: const Icon(
                            CustomIcons.cancel,
                          ),
                          onPressed: () {
                            _controller.clear();
                            context
                                .read<SelectDeviceBloc>()
                                .add(const KeywordCleared());
                          },
                        ),
                      )
                    : null,
              ),
            ),
          );
        });
  }
}

class _DeviceListView extends StatelessWidget {
  const _DeviceListView({Key? key}) : super(key: key);

  String _getDisplayName(BatchSettingDevice device) {
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
    required List<BatchSettingDevice> data,
    required Map<BatchSettingDevice, bool> selectedDevices,
  }) {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        BatchSettingDevice device = data[index];
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Material(
            color: index.isEven ? Colors.grey.shade100 : Colors.white,
            child: InkWell(
              onTap: () {
                context.read<SelectDeviceBloc>().add(DeviceItemToggled(
                      device,
                      !selectedDevices[device]!,
                    ));
              },
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
                          )
                        ],
                      ),
                    ),
                    Checkbox(
                      visualDensity: const VisualDensity(vertical: -4.0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: selectedDevices[device],
                      onChanged: (value) => context
                          .read<SelectDeviceBloc>()
                          .add(DeviceItemToggled(
                            device,
                            value ?? false,
                          )),
                    ),
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
    return BlocBuilder<SelectDeviceBloc, SelectDeviceState>(
      builder: (context, state) {
        if (state.status.isRequestSuccess) {
          return Container(
            color: Colors.grey.shade300,
            child: Scrollbar(
              thickness: 8.0,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: _deviceSliverChildBuilderDelegate(
                    data: state.devices,
                    selectedDevices: state.selectedDevices,
                  )),
                ],
              ),
            ),
          );
        } else if (state.status.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Text(getMessageLocalization(
              msg: state.requestErrorMsg,
              context: context,
            )),
          );
        }
      },
    );
  }
}

class _DeviceSelectionEditFloatingActionButton extends StatelessWidget {
  const _DeviceSelectionEditFloatingActionButton({
    Key? key,
    required this.moduleId,
  }) : super(key: key);

  final int moduleId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectDeviceBloc, SelectDeviceState>(
      builder: (context, state) {
        return state.selectedDevices.values.contains(true)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: null,
                    elevation: 0.0,
                    backgroundColor: const Color(0x742195F3),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          ConfigDevicePage.route(
                            moduleId: moduleId,
                            devices: [
                              for (MapEntry entry
                                  in state.selectedDevices.entries)
                                if (entry.value == true) ...[entry.key]
                            ],
                          ));
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
                            .read<SelectDeviceBloc>()
                            .add(const AllDeviceItemsDeselected());
                      },
                      child: const Icon(CustomIcons.cancel)),
                ],
              )
            : Container();
      },
    );
  }
}
