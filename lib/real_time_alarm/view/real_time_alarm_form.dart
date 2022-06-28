import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricoms_app/real_time_alarm/bloc/real_time_alarm_bloc.dart';
import 'package:ricoms_app/repository/real_time_alarm_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';

class RealTimeAlarmForm extends StatelessWidget {
  const RealTimeAlarmForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,

          //title: Text(widget.node.name),
          centerTitle: true,
          titleSpacing: 0.0,
          title: const TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.blue,
            isScrollable: true,
            tabs: [
              Tab(
                text: 'All',
              ),
              Tab(
                text: 'Critical',
              ),
              Tab(
                text: 'Warning',
              ),
              Tab(
                text: 'Normal',
              ),
              Tab(
                text: 'Notice',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            _AlarmSliverList(
              alarmType: AlarmType.all,
            ),
            _AlarmSliverList(
              alarmType: AlarmType.critical,
            ),
            _AlarmSliverList(
              alarmType: AlarmType.warning,
            ),
            _AlarmSliverList(
              alarmType: AlarmType.normal,
            ),
            _AlarmSliverList(
              alarmType: AlarmType.notice,
            ),
          ],
        ),
      ),
    );
  }
}

class _AlarmSliverList extends StatelessWidget {
  const _AlarmSliverList({Key? key, required this.alarmType}) : super(key: key);

  final AlarmType alarmType;

  @override
  Widget build(BuildContext context) {
    _alarmSliverChildBuilderDelegate(List data) {
      return SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          print('build _deviceSliverChildBuilderDelegate : ${index}');
          Alarm alarmData = data[index];
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: Material(
              child: InkWell(
                onTap: () {
                  //Navigator.pop(context, searchData.path);
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
                          children: [
                            Container(
                              width: CommonStyle.severityRectangleWidth,
                              height: CommonStyle.severityRectangleHeight,
                              color:
                                  CustomStyle.severityColor[alarmData.severity],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 2.0, 4.0),
                              child: Text(
                                alarmData.event,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  fontSize: 18.0,
                                  //fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 2.0, 4.0),
                              child: Text(
                                alarmData.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  fontSize: 12.0,
                                  //fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 2.0, 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    alarmData.ip,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                      fontSize: 12.0,
                                      //fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    alarmData.receivedTime,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                      fontSize: 12.0,
                                      //fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
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

    return BlocBuilder<RealTimeAlarmBloc, RealTimeAlarmState>(
      builder: (context, state) {
        if (state.status.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.status.isRequestSuccess) {
          return Container(
            color: Colors.grey.shade300,
            child: CustomScrollView(
              slivers: [
                if (alarmType == AlarmType.all) ...[
                  SliverList(
                      delegate:
                          _alarmSliverChildBuilderDelegate(state.allAlarms))
                ] else if (alarmType == AlarmType.critical) ...[
                  SliverList(
                      delegate: _alarmSliverChildBuilderDelegate(
                          state.criticalAlarms))
                ] else if (alarmType == AlarmType.warning) ...[
                  SliverList(
                      delegate:
                          _alarmSliverChildBuilderDelegate(state.warningAlarms))
                ] else if (alarmType == AlarmType.normal) ...[
                  SliverList(
                      delegate:
                          _alarmSliverChildBuilderDelegate(state.normalAlarms))
                ] else if (alarmType == AlarmType.notice) ...[
                  SliverList(
                      delegate:
                          _alarmSliverChildBuilderDelegate(state.noticeAlarms))
                ] else ...[
                  SliverList(
                      delegate:
                          _alarmSliverChildBuilderDelegate(state.allAlarms))
                ]
              ],
            ),
          );
        } else if (state.status.isrequestFailure) {
          if (alarmType == AlarmType.all) {
            return Center(
              child: Text(state.allAlarms[0]),
            );
          } else if (alarmType == AlarmType.critical) {
            return Center(
              child: Text(state.criticalAlarms[0]),
            );
          } else if (alarmType == AlarmType.warning) {
            return Center(
              child: Text(state.warningAlarms[0]),
            );
          } else if (alarmType == AlarmType.normal) {
            return Center(
              child: Text(state.normalAlarms[0]),
            );
          } else if (alarmType == AlarmType.notice) {
            return Center(
              child: Text(state.noticeAlarms[0]),
            );
          } else {
            return Center(
              child: Text(state.allAlarms[0]),
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
