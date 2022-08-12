import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/device/device_bloc.dart';
import 'package:ricoms_app/root/view/device_history_form.dart';
import 'package:ricoms_app/root/view/device_setting_form.dart';
import 'package:ricoms_app/utils/common_style.dart';

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
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  titleSpacing: 0.0,
                  title: TabBar(
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.blue,
                    isScrollable: true,
                    tabs: [
                      if (isA8KPCM2()) ...[
                        for (DeviceBlock deviceBlock in deviceBlocks)
                          Tab(text: deviceBlock.name),
                      ] else ...[
                        for (DeviceBlock deviceBlock in deviceBlocks)
                          Tab(text: deviceBlock.name),
                        const Tab(text: 'History')
                      ]
                    ],
                  ),
                ),
                body: TabBarView(
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
                        DeviceSettingPage(
                          deviceBlock: deviceBlock,
                          nodeId: node.id,
                        )
                      ],
                      DeviceHistoryForm(
                        nodeId: node.id,
                      ),
                    ],
                  ],
                ),
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



// class DeviceSettingPage extends StatefulWidget {
//   const DeviceSettingPage({
//     Key? key,
//     required this.user,
//     required this.node,
//   }) : super(key: key);

//   final User user;
//   final Node node;

//   @override
//   State<DeviceSettingPage> createState() => _DeviceSettingPageState();
// }

// class _DeviceSettingPageState extends State<DeviceSettingPage>
//     with TickerProviderStateMixin {
//   late TabController tabController;

//   @override
//   void initState() {
//     super.initState();
//   }

//   bool isA8KPCM2() {
//     if (widget.node.name.startsWith(CommonStyle.a8KPCM2Name)) {
//       //some name of pcm2 are 'A8KPCM2(L)' or 'A8KPCM2'
//       return true;
//     } else {
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     DeviceRepository deviceRepository =
//         RepositoryProvider.of<DeviceRepository>(context);
//     return FutureBuilder(
//       future: deviceRepository.createDeviceBlock(
//         user: widget.user,
//         nodeId: widget.node.id,
//       ),
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (snapshot.hasData) {
//           if (snapshot.data is List<DeviceBlock>) {
//             List<DeviceBlock> deviceBlocks = snapshot.data;
//             tabController = TabController(
//                 length:
//                     isA8KPCM2() ? deviceBlocks.length : deviceBlocks.length + 1,
//                 vsync: this);
//             return Scaffold(
//               appBar: AppBar(
//                 elevation: 0.0,
//                 backgroundColor: Colors.white,
//                 centerTitle: true,
//                 titleSpacing: 0.0,
//                 title: TabBar(
//                   unselectedLabelColor: Colors.grey,
//                   labelColor: Colors.blue,
//                   isScrollable: true,
//                   tabs: [
//                     if (isA8KPCM2()) ...[
//                       for (DeviceBlock deviceBlock in deviceBlocks)
//                         Tab(text: deviceBlock.name),
//                     ] else ...[
//                       for (DeviceBlock deviceBlock in deviceBlocks)
//                         Tab(text: deviceBlock.name),
//                       const Tab(text: 'History')
//                     ]
//                   ],
//                   controller: tabController,
//                 ),
//               ),
//               body: TabBarView(
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: [
//                   if (isA8KPCM2()) ...[
//                     for (DeviceBlock deviceBlock in deviceBlocks) ...[
//                       DeviceSettingForm(
//                         user: widget.user,
//                         deviceBlock: deviceBlock,
//                         nodeId: widget.node.id,
//                       )
//                     ],
//                   ] else ...[
//                     for (DeviceBlock deviceBlock in deviceBlocks) ...[
//                       DeviceSettingForm(
//                         user: widget.user,
//                         deviceBlock: deviceBlock,
//                         nodeId: widget.node.id,
//                       )
//                     ],
//                     DeviceHistoryForm(
//                       user: widget.user,
//                       nodeId: widget.node.id,
//                     ),
//                   ],
//                 ],
//                 controller: tabController,
//               ),
//             );
//           } else {
//             //String
//             return Scaffold(
//               appBar: AppBar(
//                 title: const Text('Error'),
//               ),
//               body: Center(
//                 child: Text(snapshot.data),
//               ),
//             );
//           }
//         } else {
//           //wait for data
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//       },
//     );
//   }
// }
