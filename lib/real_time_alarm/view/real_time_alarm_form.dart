import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricoms_app/real_time_alarm/bloc/real_time_alarm_bloc.dart';
import 'package:ricoms_app/repository/real_time_alarm_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';

class RealTimeAlarmForm extends StatelessWidget {
  const RealTimeAlarmForm({
    Key? key,
    required this.pageController,
    required this.initialPath,
  }) : super(key: key);

  final PageController pageController;
  final List initialPath;

  @override
  Widget build(BuildContext context) {
    Future<void> _showFailureDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(
                color: CustomStyle.severityColor[3],
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(msg),
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

    return BlocListener<RealTimeAlarmBloc, RealTimeAlarmState>(
      listener: (context, state) {
        if (state.targetDeviceStatus.isRequestFailure) {
          _showFailureDialog(state.errmsg);
        }
      },
      child: DefaultTabController(
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
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _AllAlarmsSliverList(
                pageController: pageController,
                initialPath: initialPath,
              ),
              _CriticalAlarmsSliverList(
                pageController: pageController,
                initialPath: initialPath,
              ),
              _WarningAlarmsSliverList(
                pageController: pageController,
                initialPath: initialPath,
              ),
              _NormalAlarmsSliverList(
                pageController: pageController,
                initialPath: initialPath,
              ),
              _NoticeAlarmsSliverList(
                pageController: pageController,
                initialPath: initialPath,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _showEmptyContent() {
  return const Center(
    child: Text('There are no records to show'),
  );
}

String _getDisplayName(Alarm alarmData) {
  if (alarmData.type == 5) {
    //a8k slot
    if (alarmData.shelf == 0 && alarmData.slot == 1) {
      return '${alarmData.name} [ PCM2 (L) ]';
    } else if (alarmData.shelf != 0 && alarmData.slot == 0) {
      return '${alarmData.name} [ Shelf ${alarmData.shelf} / FAN ]';
    } else {
      return '${alarmData.name} [ Shelf ${alarmData.shelf} / Slot ${alarmData.slot} ]';
    }
  } else {
    return alarmData.name;
  }
}

SliverChildBuilderDelegate _alarmSliverChildBuilderDelegate(
  List data,
  List initialPath,
  PageController pageController,
) {
  return SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      Alarm alarmData = data[index];
      return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Material(
          child: InkWell(
            onTap: () {
              initialPath.clear();
              initialPath.addAll(alarmData.path);
              context
                  .read<RealTimeAlarmBloc>()
                  .add(CheckDeviceStatus(alarmData.path, pageController));
              //pageController.jumpToPage(1);
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
                          height: 60.0,
                          color: CustomStyle.severityColor[alarmData.severity],
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
                              const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 4.0),
                          child: Text(
                            alarmData.event,
                            //maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                              fontSize: CommonStyle.sizeL,
                              //fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 4.0),
                          child: Text(
                            _getDisplayName(alarmData),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                              fontSize: CommonStyle.sizeS,
                              //fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                alarmData.ip,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  fontSize: CommonStyle.sizeS,
                                  //fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                alarmData.receivedTime,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  fontSize: CommonStyle.sizeS,
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

class _AllAlarmsSliverList extends StatefulWidget {
  const _AllAlarmsSliverList({
    Key? key,
    required this.pageController,
    required this.initialPath,
  }) : super(key: key);

  final PageController pageController;
  final List initialPath;

  @override
  State<_AllAlarmsSliverList> createState() => __AllAlarmsSliverListState();
}

class __AllAlarmsSliverListState extends State<_AllAlarmsSliverList> {
  @override
  void initState() {
    //Use StatefulWidget and subscribe stream in order to update periodic
    context
        .read<RealTimeAlarmBloc>()
        .add(const AlarmPeriodicUpdated(AlarmType.all));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('build _AllAlarmsSliverList');
    }
    return BlocBuilder<RealTimeAlarmBloc, RealTimeAlarmState>(
      builder: (context, state) {
        if (state.allAlarmsStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.allAlarmsStatus.isRequestSuccess) {
          return Container(
            color: Colors.grey.shade300,
            child: state.allAlarms.isNotEmpty
                ? CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: _alarmSliverChildBuilderDelegate(
                          state.allAlarms,
                          widget.initialPath,
                          widget.pageController,
                        ),
                      )
                    ],
                  )
                : _showEmptyContent(),
          );
        } else if (state.allAlarmsStatus.isRequestFailure) {
          return Center(
            child: Text(state.allAlarms[0]),
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

class _CriticalAlarmsSliverList extends StatefulWidget {
  const _CriticalAlarmsSliverList({
    Key? key,
    required this.pageController,
    required this.initialPath,
  }) : super(key: key);

  final PageController pageController;
  final List initialPath;

  @override
  State<_CriticalAlarmsSliverList> createState() =>
      __CriticalAlarmsSliverListState();
}

class __CriticalAlarmsSliverListState extends State<_CriticalAlarmsSliverList> {
  @override
  void initState() {
    context
        .read<RealTimeAlarmBloc>()
        .add(const AlarmPeriodicUpdated(AlarmType.critical));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('build _CriticalAlarmsSliverList');
    }
    return BlocBuilder<RealTimeAlarmBloc, RealTimeAlarmState>(
      builder: (context, state) {
        if (state.criticalAlarmsStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.criticalAlarmsStatus.isRequestSuccess) {
          return Container(
            color: Colors.grey.shade300,
            child: state.criticalAlarms.isNotEmpty
                ? CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: _alarmSliverChildBuilderDelegate(
                          state.criticalAlarms,
                          widget.initialPath,
                          widget.pageController,
                        ),
                      )
                    ],
                  )
                : _showEmptyContent(),
          );
        } else if (state.criticalAlarmsStatus.isRequestFailure) {
          return Center(
            child: Text(state.criticalAlarms[0]),
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

class _WarningAlarmsSliverList extends StatefulWidget {
  const _WarningAlarmsSliverList({
    Key? key,
    required this.pageController,
    required this.initialPath,
  }) : super(key: key);

  final PageController pageController;
  final List initialPath;

  @override
  State<_WarningAlarmsSliverList> createState() =>
      __WarningAlarmsSliverListState();
}

class __WarningAlarmsSliverListState extends State<_WarningAlarmsSliverList> {
  @override
  void initState() {
    context
        .read<RealTimeAlarmBloc>()
        .add(const AlarmPeriodicUpdated(AlarmType.warning));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('build _WarningAlarmsSliverList');
    }
    return BlocBuilder<RealTimeAlarmBloc, RealTimeAlarmState>(
      builder: (context, state) {
        if (state.warningAlarmsStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.warningAlarmsStatus.isRequestSuccess) {
          return Container(
            color: Colors.grey.shade300,
            child: state.warningAlarms.isNotEmpty
                ? CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: _alarmSliverChildBuilderDelegate(
                          state.warningAlarms,
                          widget.initialPath,
                          widget.pageController,
                        ),
                      )
                    ],
                  )
                : _showEmptyContent(),
          );
        } else if (state.warningAlarmsStatus.isRequestFailure) {
          return Center(
            child: Text(state.warningAlarms[0]),
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

class _NormalAlarmsSliverList extends StatefulWidget {
  const _NormalAlarmsSliverList({
    Key? key,
    required this.pageController,
    required this.initialPath,
  }) : super(key: key);

  final PageController pageController;
  final List initialPath;

  @override
  State<_NormalAlarmsSliverList> createState() =>
      __NormalAlarmsSliverListState();
}

class __NormalAlarmsSliverListState extends State<_NormalAlarmsSliverList> {
  @override
  void initState() {
    context
        .read<RealTimeAlarmBloc>()
        .add(const AlarmPeriodicUpdated(AlarmType.normal));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('build _NormalAlarmsSliverList');
    }
    return BlocBuilder<RealTimeAlarmBloc, RealTimeAlarmState>(
      builder: (context, state) {
        if (state.normalAlarmsStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.normalAlarmsStatus.isRequestSuccess) {
          return Container(
            color: Colors.grey.shade300,
            child: state.normalAlarms.isNotEmpty
                ? CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: _alarmSliverChildBuilderDelegate(
                          state.normalAlarms,
                          widget.initialPath,
                          widget.pageController,
                        ),
                      )
                    ],
                  )
                : _showEmptyContent(),
          );
        } else if (state.normalAlarmsStatus.isRequestFailure) {
          return Center(
            child: Text(state.normalAlarms[0]),
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

class _NoticeAlarmsSliverList extends StatefulWidget {
  const _NoticeAlarmsSliverList({
    Key? key,
    required this.pageController,
    required this.initialPath,
  }) : super(key: key);

  final PageController pageController;
  final List initialPath;

  @override
  State<_NoticeAlarmsSliverList> createState() =>
      __NoticeAlarmsSliverListState();
}

class __NoticeAlarmsSliverListState extends State<_NoticeAlarmsSliverList> {
  @override
  void initState() {
    context
        .read<RealTimeAlarmBloc>()
        .add(const AlarmPeriodicUpdated(AlarmType.notice));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('build _NoticeAlarmsSliverList');
    }
    return BlocBuilder<RealTimeAlarmBloc, RealTimeAlarmState>(
      builder: (context, state) {
        if (state.noticeAlarmsStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.noticeAlarmsStatus.isRequestSuccess) {
          return Container(
            color: Colors.grey.shade300,
            child: state.noticeAlarms.isNotEmpty
                ? CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: _alarmSliverChildBuilderDelegate(
                          state.noticeAlarms,
                          widget.initialPath,
                          widget.pageController,
                        ),
                      )
                    ],
                  )
                : _showEmptyContent(),
          );
        } else if (state.noticeAlarmsStatus.isRequestFailure) {
          return Center(
            child: Text(state.noticeAlarms[0]),
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
