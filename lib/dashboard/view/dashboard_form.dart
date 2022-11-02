import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/dashboard/bloc/dashboard_bloc.dart';
import 'package:ricoms_app/home/view/home_bottom_navigation_bar.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/common_widget.dart';
import 'package:ricoms_app/utils/message_localization.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardForm extends StatelessWidget {
  const DashboardForm({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? isExit = await CommonWidget.showExitAppDialog(context: context);
        return isExit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.dashboard),
          leading: HomeDrawerToolTip.setToolTip(context),
          elevation: 0.0,
        ),
        bottomNavigationBar: HomeBottomNavigationBar(
          pageController: pageController,
          selectedIndex: 2,
        ),
        drawer: HomeDrawer(
          user: context.read<AuthenticationBloc>().state.user,
          pageController: pageController,
          currentPageIndex: 2,
        ),
        body: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Expanded(
                child: _PieChartPageViewCard(),
              ),
              _DeviceStatisticsCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PieChartPageViewCard extends StatelessWidget {
  const _PieChartPageViewCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController _pieChartPageController = PageController();
    return Card(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: _WidgetTitle(
              title: AppLocalizations.of(context)!.alarmRatio,
            ),
          ),
          _buildLegend(context),
          Expanded(
            //height: 250,
            child: PageView(
              controller: _pieChartPageController,
              children: const <Widget>[
                _AlarmOneDayStatisticsPieChart(),
                _AlarmThreeDaysStatisticsPieChart(),
                _AlarmOneWeekStatisticsPieChart(),
                _AlarmTwoWeeksStatisticsPieChart(),
                _AlarmOneMonthStatisticsPieChart(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
            child: SmoothPageIndicator(
              controller: _pieChartPageController,
              count: 5,
              effect: const WormEffect(
                dotHeight: 10.0,
                dotWidth: 10.0,
                type: WormType.normal,
                // strokeWidth: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WidgetTitle extends StatelessWidget {
  const _WidgetTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: CommonStyle.sizeXL,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _AlarmOneDayStatisticsPieChart extends StatefulWidget {
  const _AlarmOneDayStatisticsPieChart({Key? key}) : super(key: key);

  @override
  State<_AlarmOneDayStatisticsPieChart> createState() =>
      __AlarmOneDayStatisticsPieChartState();
}

class __AlarmOneDayStatisticsPieChartState
    extends State<_AlarmOneDayStatisticsPieChart> {
  @override
  void initState() {
    context.read<DashboardBloc>().add(const AlarmStatisticPeriodicUpdated(1));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.alarmOneDayStatisticsStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.alarmOneDayStatisticsStatus.isRequestSuccess) {
          List alarmOneDayStatistics = state.alarmOneDayStatistics;
          return _buildPieChart(
            title: AppLocalizations.of(context)!.oneDay,
            alarmStatistics: alarmOneDayStatistics,
          );
        } else if (state.alarmOneDayStatisticsStatus.isRequestFailure) {
          return Center(
            child: Text(
              getMessageLocalization(
                msg: state.errmsg,
                context: context,
              ),
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

class _AlarmThreeDaysStatisticsPieChart extends StatefulWidget {
  const _AlarmThreeDaysStatisticsPieChart({Key? key}) : super(key: key);

  @override
  State<_AlarmThreeDaysStatisticsPieChart> createState() =>
      __AlarmThreeDaysStatisticsPieChartState();
}

class __AlarmThreeDaysStatisticsPieChartState
    extends State<_AlarmThreeDaysStatisticsPieChart> {
  @override
  void initState() {
    context.read<DashboardBloc>().add(const AlarmStatisticPeriodicUpdated(2));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.alarmThreeDaysStatisticsStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.alarmThreeDaysStatisticsStatus.isRequestSuccess) {
          List alarmThreeDaysStatistics = state.alarmThreeDaysStatistics;
          return _buildPieChart(
            title: AppLocalizations.of(context)!.threeDays,
            alarmStatistics: alarmThreeDaysStatistics,
          );
        } else if (state.alarmThreeDaysStatisticsStatus.isRequestFailure) {
          return Center(
            child: Text(
              getMessageLocalization(
                msg: state.errmsg,
                context: context,
              ),
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

class _AlarmOneWeekStatisticsPieChart extends StatefulWidget {
  const _AlarmOneWeekStatisticsPieChart({Key? key}) : super(key: key);

  @override
  State<_AlarmOneWeekStatisticsPieChart> createState() =>
      __AlarmOneWeekStatisticsPieChartState();
}

class __AlarmOneWeekStatisticsPieChartState
    extends State<_AlarmOneWeekStatisticsPieChart> {
  @override
  void initState() {
    context.read<DashboardBloc>().add(const AlarmStatisticPeriodicUpdated(3));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.alarmOneWeekStatisticsStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.alarmOneWeekStatisticsStatus.isRequestSuccess) {
          List alarmOneWeekStatistics = state.alarmOneWeekStatistics;
          return _buildPieChart(
            title: AppLocalizations.of(context)!.oneWeek,
            alarmStatistics: alarmOneWeekStatistics,
          );
        } else if (state.alarmOneWeekStatisticsStatus.isRequestFailure) {
          return Center(
            child: Text(
              getMessageLocalization(
                msg: state.errmsg,
                context: context,
              ),
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

class _AlarmTwoWeeksStatisticsPieChart extends StatefulWidget {
  const _AlarmTwoWeeksStatisticsPieChart({Key? key}) : super(key: key);

  @override
  State<_AlarmTwoWeeksStatisticsPieChart> createState() =>
      __AlarmTwoWeeksStatisticsPieChartState();
}

class __AlarmTwoWeeksStatisticsPieChartState
    extends State<_AlarmTwoWeeksStatisticsPieChart> {
  @override
  void initState() {
    context.read<DashboardBloc>().add(const AlarmStatisticPeriodicUpdated(4));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.alarmTwoWeeksStatisticsStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.alarmTwoWeeksStatisticsStatus.isRequestSuccess) {
          List alarmTwoWeeksStatistics = state.alarmTwoWeeksStatistics;
          return _buildPieChart(
            title: AppLocalizations.of(context)!.twoWeeks,
            alarmStatistics: alarmTwoWeeksStatistics,
          );
        } else if (state.alarmTwoWeeksStatisticsStatus.isRequestFailure) {
          return Center(
            child: Text(
              getMessageLocalization(
                msg: state.errmsg,
                context: context,
              ),
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

class _AlarmOneMonthStatisticsPieChart extends StatefulWidget {
  const _AlarmOneMonthStatisticsPieChart({Key? key}) : super(key: key);

  @override
  State<_AlarmOneMonthStatisticsPieChart> createState() =>
      __AlarmOneMonthStatisticsPieChartState();
}

class __AlarmOneMonthStatisticsPieChartState
    extends State<_AlarmOneMonthStatisticsPieChart> {
  @override
  void initState() {
    context.read<DashboardBloc>().add(const AlarmStatisticPeriodicUpdated(5));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.alarmOneMonthStatisticsStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.alarmOneMonthStatisticsStatus.isRequestSuccess) {
          List alarmOneMonthStatistics = state.alarmOneMonthStatistics;
          return _buildPieChart(
            title: AppLocalizations.of(context)!.oneMonth,
            alarmStatistics: alarmOneMonthStatistics,
          );
        } else if (state.alarmOneMonthStatisticsStatus.isRequestFailure) {
          return Center(
            child: Text(
              getMessageLocalization(
                msg: state.errmsg,
                context: context,
              ),
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

class _DeviceStatisticsCard extends StatelessWidget {
  const _DeviceStatisticsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              child: _WidgetTitle(
                title: AppLocalizations.of(context)!.deviceStatus,
              ),
            ),
            const _DeviceStatisticsGridView(),
          ],
        ),
      ),
    );
  }
}

class _DeviceStatisticsGridView extends StatelessWidget {
  const _DeviceStatisticsGridView({Key? key}) : super(key: key);

  final _gridColors = const [
    Colors.white, // all
    Color(0xffdc3545), // critical
    Color(0xffffc107), // warning
    Color(0xff28a745), // normal
    Color(0xFF6C757D), // offline
    Color(0xFF6C757D), //unknown
  ];

  final _fontColors = const [
    Colors.black, // all
    Colors.white, // critical
    Colors.black, // warning
    Colors.white, // normal
    Colors.white, // offline
    Colors.white, //unknown
  ];

  @override
  Widget build(BuildContext context) {
    final _gridTitles = [
      AppLocalizations.of(context)!.allDeviceStatus,
      AppLocalizations.of(context)!.criticalDeviceStatus,
      AppLocalizations.of(context)!.warningDeviceStatus,
      AppLocalizations.of(context)!.normalDeviceStatus,
      AppLocalizations.of(context)!.offlineDeviceStatus,
      AppLocalizations.of(context)!.unknownDeviceStatus,
    ];

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.deviceStatisticsStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.deviceStatisticsStatus.isRequestSuccess) {
          List deviceStatistics = state.deviceStatistics;
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1.6,
            ),
            itemBuilder: (_, int index) {
              return Container(
                decoration: BoxDecoration(
                  color: _gridColors[index],
                  border: _gridColors[index] == Colors.white
                      ? Border.all(color: Colors.black)
                      : null,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _gridTitles[index],
                      style: TextStyle(
                        color: _fontColors[index],
                        fontSize: CommonStyle.sizeL,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      deviceStatistics[index].toString(),
                      style: TextStyle(
                        color: _fontColors[index],
                        fontSize: CommonStyle.sizeM,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (state.deviceStatisticsStatus.isRequestFailure) {
          return Center(
            child: Text(
              getMessageLocalization(
                msg: state.errmsg,
                context: context,
              ),
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

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: CommonStyle.sizeS,
              fontWeight: FontWeight.w500,
              color: textColor),
        )
      ],
    );
  }
}

Widget _buildLegend(BuildContext context) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    //crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Indicator(
        color: const Color(0xffdc3545),
        text: AppLocalizations.of(context)!.critical,
        isSquare: false,
        size: CommonStyle.sizeS,
      ),
      const SizedBox(
        width: 8,
      ),
      Indicator(
        color: const Color(0xffffc107),
        text: AppLocalizations.of(context)!.warning,
        isSquare: false,
        size: CommonStyle.sizeS,
      ),
      const SizedBox(
        width: 8,
      ),
      Indicator(
        color: const Color(0xff28a745),
        text: AppLocalizations.of(context)!.normal,
        isSquare: false,
        size: CommonStyle.sizeS,
      ),
    ],
  );
}

List<PieChartSectionData> showingSections(List alarmStatistics) {
  double totalAlarms = 0;
  for (var element in alarmStatistics) {
    totalAlarms += element;
  }
  return List.generate(3, (i) {
    const fontSize = 12.0;
    const radius = 50.0;
    double percentage = (alarmStatistics[i] / totalAlarms) * 100.0;
    switch (i) {
      case 0:
        return PieChartSectionData(
          color: const Color(0xffdc3545),
          value: percentage,
          title: '${percentage.toStringAsFixed(1)} %',
          radius: radius,
          titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff)),
        );
      case 1:
        return PieChartSectionData(
          color: const Color(0xffffc107),
          value: percentage,
          title: '${percentage.toStringAsFixed(1)} %',
          radius: radius,
          titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff)),
        );
      case 2:
        return PieChartSectionData(
          color: const Color(0xff28a745),
          value: percentage,
          title: '${percentage.toStringAsFixed(1)} %',
          radius: radius,
          titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff)),
        );
      default:
        return PieChartSectionData(
          color: const Color(0xff0293ee),
          value: 40,
          title: '40%',
          radius: radius,
          titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff)),
        );
    }
  });
}

Widget _buildPieChart({
  required String title,
  required List alarmStatistics,
}) {
  return Column(
    // mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      Expanded(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: PieChart(
                PieChartData(
                  startDegreeOffset: 270,
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  //centerSpaceRadius: 60,
                  sections: showingSections(alarmStatistics),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
