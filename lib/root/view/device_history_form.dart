import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/bloc/device_history/device_history_bloc.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:ricoms_app/root/view/device_history_detail_page.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class DeviceHistoryForm extends StatelessWidget {
  const DeviceHistoryForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showNoMoreRecordsDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitle_NoMoreData,
              style: const TextStyle(
                color: CustomStyle.customGreen,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    getMessageLocalization(
                      msg: msg,
                      context: context,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    return BlocListener<DeviceHistoryBloc, DeviceHistoryState>(
      listener: (context, state) {
        if (state.moreRecordsStatus.isRequestFailure) {
          _showNoMoreRecordsDialog(state.moreRecordsMessage);
        }
      },
      child: Scaffold(
        body: _HistorySliverList(),
        floatingActionButton: const _HistoryFloatingActionButton(),
      ),
    );
  }
}

class _HistorySliverList extends StatelessWidget {
  _HistorySliverList({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    bool _isBottom() {
      if (!_scrollController.hasClients) return false;
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      return currentScroll >= maxScroll;
    }

    void _onScroll() {
      if (context.read<DeviceHistoryBloc>().state.isShowFloatingActionButton) {
        if (!_isBottom()) {
          context
              .read<DeviceHistoryBloc>()
              .add(const FloatingActionButtonHided());
        }
      } else {
        if (_isBottom()) {
          context
              .read<DeviceHistoryBloc>()
              .add(const FloatingActionButtonShowed());
        }
      }
    }

    _scrollController.addListener(_onScroll);

    _historySliverChildBuilderDelegate(List<DeviceHistoryData> data) {
      return SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          DeviceHistoryData deviceHistoryData = data[index];
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: Material(
              color: index.isEven ? Colors.grey.shade100 : Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      DeviceHistoryDetailPage.route(deviceHistoryData));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 0.0, 10.0, 0.0),
                              width: CommonStyle.severityRectangleWidth,
                              height: CommonStyle.severityRectangleHeight,
                              color: CustomStyle
                                  .severityColor[deviceHistoryData.severity],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 10.0, 2.0),
                              child: Text(
                                deviceHistoryData.event,
                                //default textScaleFactor is MediaQuery.of(context).textScaleFactor = 1.15
                                textScaleFactor: 1.0,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: CommonStyle.sizeXL,
                                  //fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            deviceHistoryData.clearTime.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 0.0, 10.0, 0.0),
                                    child: Text(
                                      'Clear Time: ${deviceHistoryData.clearTime}',
                                      style: GoogleFonts.roboto(
                                        fontSize: 12.0,
                                        //fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 0.0, 10.0, 0.0),
                                    child: Text(
                                      'Time Received: ${deviceHistoryData.timeReceived}',
                                      style: GoogleFonts.roboto(
                                        fontSize: CommonStyle.sizeS,
                                        //fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
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

    return BlocBuilder<DeviceHistoryBloc, DeviceHistoryState>(
      builder: (context, state) {
        if (state.status.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.status.isRequestSuccess) {
          if (state.moreRecordsStatus.isRequestSuccess) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(_scrollController.offset + 20,
                    duration: const Duration(seconds: 1), curve: Curves.ease);
              }
            });
          }
          return Container(
            color: Colors.grey.shade300,
            child: Scrollbar(
              thickness: 8.0,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverList(
                      delegate: _historySliverChildBuilderDelegate(
                          state.deviceHistoryRecords)),
                ],
              ),
            ),
          );
        } else if (state.status.isRequestFailure) {
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
                    msg: state.errmsg,
                    context: context,
                  ),
                ),
                const SizedBox(height: 40.0),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class _HistoryFloatingActionButton extends StatelessWidget {
  const _HistoryFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceHistoryBloc, DeviceHistoryState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isShowFloatingActionButton,
          child: FloatingActionButton(
            elevation: 0.0,
            backgroundColor: const Color(0x742195F3),
            onPressed: !state.moreRecordsStatus.isRequestInProgress
                ? () {
                    context.read<DeviceHistoryBloc>().add(MoreRecordsRequested(
                        state.deviceHistoryRecords.last.trapId));
                  }
                : null,
            child: state.moreRecordsStatus.isRequestInProgress
                ? const SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

// class DeviceHistoryForm extends StatefulWidget {
//   const DeviceHistoryForm({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<DeviceHistoryForm> createState() => _DeviceHistoryFormState();
// }

// class _DeviceHistoryFormState extends State<DeviceHistoryForm> {
//   _historySliverChildBuilderDelegate(List data) {
//     return SliverChildBuilderDelegate(
//       (BuildContext context, int index) {
//         DeviceHistoryData deviceHistoryData = data[index];
//         return Padding(
//           padding: const EdgeInsets.all(1.0),
//           child: Material(
//             color: index.isEven ? Colors.grey.shade100 : Colors.white,
//             child: InkWell(
//               onTap: () {
//                 Navigator.push(
//                     context, DeviceHistoryDetailPage.route(deviceHistoryData));
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding:
//                                 const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
//                             width: CommonStyle.severityRectangleWidth,
//                             height: CommonStyle.severityRectangleHeight,
//                             color: CustomStyle
//                                 .severityColor[deviceHistoryData.severity],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       flex: 8,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding:
//                                 const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 2.0),
//                             child: Text(
//                               deviceHistoryData.event,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.roboto(
//                                 fontSize: 18.0,
//                                 //fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           deviceHistoryData.clearTime.isNotEmpty
//                               ? Padding(
//                                   padding: const EdgeInsets.fromLTRB(
//                                       10.0, 0.0, 10.0, 0.0),
//                                   child: Text(
//                                     'Clear Time: ${deviceHistoryData.clearTime}',
//                                     style: GoogleFonts.roboto(
//                                       fontSize: 12.0,
//                                       //fontWeight: FontWeight.w600,
//                                       color: Colors.grey.shade400,
//                                     ),
//                                   ),
//                                 )
//                               : Padding(
//                                   padding: const EdgeInsets.fromLTRB(
//                                       10.0, 0.0, 10.0, 0.0),
//                                   child: Text(
//                                     'Time Received: ${deviceHistoryData.timeReceived}',
//                                     style: GoogleFonts.roboto(
//                                       fontSize: 12.0,
//                                       //fontWeight: FontWeight.w600,
//                                       color: Colors.grey.shade400,
//                                     ),
//                                   ),
//                                 ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//       childCount: data.length,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     DeviceRepository deviceRepository =
//         RepositoryProvider.of<DeviceRepository>(context);
//     return FutureBuilder(
//       future: deviceRepository.getDeviceHistory(
//         user: context.read<AuthenticationBloc>().state.user,
//         nodeId: widget.nodeId,
//       ),
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (snapshot.hasData) {
//           if (snapshot.data is List) {
//             return Container(
//               color: Colors.grey.shade300,
//               child: CustomScrollView(
//                 slivers: [
//                   SliverList(
//                       delegate:
//                           _historySliverChildBuilderDelegate(snapshot.data))
//                 ],
//               ),
//             );
//           } else {
//             //String
//             return Center(
//               child: Text(snapshot.data),
//             );
//           }
//         } else {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     );
//   }
// }
