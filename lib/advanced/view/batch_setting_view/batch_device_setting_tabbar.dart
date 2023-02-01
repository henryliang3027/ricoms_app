import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/batch_setting_repository.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class BatchDeviceSettingTabBar extends StatelessWidget {
  const BatchDeviceSettingTabBar({
    Key? key,
    // required this.user,
    required this.moduleId,
    required this.nodeIds,
  }) : super(key: key);

  // final User user;
  final int moduleId;
  final List<int> nodeIds;

  @override
  Widget build(BuildContext context) {
    BatchSettingRepository batchSettingRepository =
        RepositoryProvider.of<BatchSettingRepository>(context);

    return FutureBuilder(
      future: batchSettingRepository.getDeviceBlock(
        user: context.read<AuthenticationBloc>().state.user,
        moduleId: moduleId,
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List<DeviceBlock>) {
            List<DeviceBlock> deviceBlocks = snapshot.data;
            return DefaultTabController(
              length: deviceBlocks.length,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.maxFinite,
                    color: Colors.blue,
                    child: Center(
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
                          ]),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        for (DeviceBlock deviceBlock in deviceBlocks) ...[
                          const Icon(
                            Icons.abc,
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
