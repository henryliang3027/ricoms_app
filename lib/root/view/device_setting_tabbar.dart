import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/device/device_bloc.dart';
import 'package:ricoms_app/root/view/device_history_page.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/device_monitoring_chart_page.dart';
import 'package:ricoms_app/root/view/device_setting_form.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class DeviceSettingTabBar extends StatelessWidget {
  const DeviceSettingTabBar({
    Key? key,
    required this.node,
  }) : super(key: key);

  final Node node;

  @override
  Widget build(BuildContext context) {
    DeviceRepository deviceRepository =
        RepositoryProvider.of<DeviceRepository>(context);

    bool isA8KPCM2() {
      if (node.name.startsWith(CommonStyle.a8KPCM2Name)) {
        //some name of pcm2 are 'A8KPCM2(L)' or 'A8KPCM2'
        return true;
      } else {
        return false;
      }
    }

    return FutureBuilder(
      future: deviceRepository.createDeviceBlock(
        user: context.read<AuthenticationBloc>().state.user,
        nodeId: node.id,
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List<DeviceBlock>) {
            List<DeviceBlock> deviceBlocks = snapshot.data;
            return DefaultTabController(
              length:
                  isA8KPCM2() ? deviceBlocks.length : deviceBlocks.length + 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.blue,
                    child: TabBar(
                      unselectedLabelColor: Colors.white,
                      labelColor: Colors.blue,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.white,
                      ),
                      labelPadding:
                          const EdgeInsets.symmetric(horizontal: 24.0),
                      tabs: [
                        if (isA8KPCM2()) ...[
                          for (DeviceBlock deviceBlock in deviceBlocks)
                            Tab(
                              child: SizedBox(
                                width: 130,
                                child: Center(
                                  child: Text(
                                    getMessageLocalization(
                                      msg: deviceBlock.name,
                                      context: context,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ] else ...[
                          for (DeviceBlock deviceBlock in deviceBlocks)
                            Tab(
                              child: SizedBox(
                                width: 130,
                                child: Center(
                                  child: Text(
                                    getMessageLocalization(
                                      msg: deviceBlock.name,
                                      context: context,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Tab(
                            child: SizedBox(
                              width: 120,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.history,
                                ),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        if (isA8KPCM2()) ...[
                          for (DeviceBlock deviceBlock in deviceBlocks) ...[
                            DeviceSettingPage(
                              deviceBlock: deviceBlock,
                              nodeId: node.id,
                            )
                          ],
                        ] else ...[
                          for (DeviceBlock deviceBlock in deviceBlocks) ...[
                            deviceBlock.name == 'Monitoring Chart'
                                ? DeviceMonitoringChartPage(
                                    deviceBlock: deviceBlock,
                                    nodeId: node.id,
                                    nodeName: node.name,
                                  )
                                : DeviceSettingPage(
                                    deviceBlock: deviceBlock,
                                    nodeId: node.id,
                                  )
                          ],
                          DeviceHistoryPage(
                            user: context.read<AuthenticationBloc>().state.user,
                            deviceRepository: deviceRepository,
                            nodeId: node.id,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_rounded,
                    size: 200,
                    color: Color(0xffffc107),
                  ),
                  Text(
                    getMessageLocalization(
                      msg: snapshot.data,
                      context: context,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                ],
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

class DeviceSettingPage extends StatelessWidget {
  const DeviceSettingPage({
    Key? key,
    required this.nodeId,
    required this.deviceBlock,
  }) : super(key: key);

  final int nodeId;
  final DeviceBlock deviceBlock;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviceBloc(
        user: context.read<AuthenticationBloc>().state.user,
        deviceRepository: RepositoryProvider.of<DeviceRepository>(context),
        nodeId: nodeId,
        deviceBlock: deviceBlock,
      ),
      child: DeviceSettingForm(
        nodeId: nodeId,
        deviceBlock: deviceBlock,
      ),
    );
  }
}
