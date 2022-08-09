import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/root/view/device_history_detail_page.dart';
import 'package:ricoms_app/utils/common_style.dart';

class DeviceHistoryForm extends StatefulWidget {
  const DeviceHistoryForm({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<DeviceHistoryForm> createState() => _DeviceHistoryFormState();
}

class _DeviceHistoryFormState extends State<DeviceHistoryForm> {
  _historySliverChildBuilderDelegate(List data) {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        DeviceHistoryData deviceHistoryData = data[index];
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Material(
            color: index.isEven ? Colors.grey.shade100 : Colors.white,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context, DeviceHistoryDetailPage.route(deviceHistoryData));
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
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
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
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 2.0),
                            child: Text(
                              deviceHistoryData.event,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                fontSize: 18.0,
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
                                      fontSize: 12.0,
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

  @override
  Widget build(BuildContext context) {
    DeviceRepository deviceRepository =
        RepositoryProvider.of<DeviceRepository>(context);
    return FutureBuilder(
      future: deviceRepository.getDeviceHistory(user: widget.user),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List) {
            return Container(
              color: Colors.grey.shade300,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate:
                          _historySliverChildBuilderDelegate(snapshot.data))
                ],
              ),
            );
          } else {
            //String
            return Center(
              child: Text(snapshot.data),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
