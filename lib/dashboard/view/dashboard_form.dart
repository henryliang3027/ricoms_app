import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/dashboard/bloc/dashboard_bloc.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardForm extends StatelessWidget {
  const DashboardForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _WidgetTitle(title: 'Alarm Ratio'),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('1 Day'),
                    _AlarmOneDayStatisticsPieChart(),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('3 Days'),
                    _AlarmThreeDaysStatisticsPieChart(),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('1 Week'),
                    _AlarmOneWeekStatisticsPieChart(),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('2 Weeks'),
                    _AlarmTwoWeeksStatisticsPieChart(),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('1 Month'),
                    _AlarmOneMonthStatisticsPieChart(),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 5,
              effect: const WormEffect(
                dotHeight: 10.0,
                dotWidth: 10.0,
                type: WormType.thin,
                // strokeWidth: 5,
              ),
            ),
          ),
          //_AlarmStatisticsPieChart(),
          // Expanded(
          //     flex: 0,
          //     child: Padding(padding: EdgeInsets.symmetric(vertical: 4.0))),
          const _WidgetTitle(title: 'Device Status'),
          const _DeviceStatisticsGridView(),
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
        fontSize: CommonStyle.sizeM,
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
          return Card(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                          startDegreeOffset: 270,
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections(alarmOneDayStatistics)),
                    ),
                  ),
                ),
                _buildLegend(),
                const SizedBox(
                  width: 28,
                ),
              ],
            ),
          );
        } else if (state.alarmOneDayStatisticsStatus.isRequestFailure) {
          return Center(
            child: Text(state.errmsg),
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
          return Card(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                          startDegreeOffset: 270,
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections(alarmThreeDaysStatistics)),
                    ),
                  ),
                ),
                _buildLegend(),
                const SizedBox(
                  width: 28,
                ),
              ],
            ),
          );
        } else if (state.alarmThreeDaysStatisticsStatus.isRequestFailure) {
          return Center(
            child: Text(state.errmsg),
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
          return Card(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                          startDegreeOffset: 270,
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections(alarmOneWeekStatistics)),
                    ),
                  ),
                ),
                _buildLegend(),
                const SizedBox(
                  width: 28,
                ),
              ],
            ),
          );
        } else if (state.alarmOneWeekStatisticsStatus.isRequestFailure) {
          return Center(
            child: Text(state.errmsg),
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
          return Card(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                          startDegreeOffset: 270,
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections(alarmTwoWeeksStatistics)),
                    ),
                  ),
                ),
                _buildLegend(),
                const SizedBox(
                  width: 28,
                ),
              ],
            ),
          );
        } else if (state.alarmTwoWeeksStatisticsStatus.isRequestFailure) {
          return Center(
            child: Text(state.errmsg),
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
          return Card(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                          startDegreeOffset: 270,
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections(alarmOneMonthStatistics)),
                    ),
                  ),
                ),
                _buildLegend(),
                const SizedBox(
                  width: 28,
                ),
              ],
            ),
          );
        } else if (state.alarmOneMonthStatisticsStatus.isRequestFailure) {
          return Center(
            child: Text(state.errmsg),
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

class _DeviceStatisticsGridView extends StatelessWidget {
  const _DeviceStatisticsGridView({Key? key}) : super(key: key);

  final _gridTitles = const [
    'All',
    'Critical',
    'Warning',
    'Normal',
    'Offline',
    'Unknown',
  ];

  final _gridColors = const [
    Color(0xFFF6F6F6), // all
    Color(0xffdc3545), // critical
    Color(0xffffc107), // warning
    Color(0xff28a745), // normal
    Color(0xFF746969), // offline
    Color(0xFFD1C6C6), //unknown
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.deviceStatisticsStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.deviceStatisticsStatus.isRequestSuccess) {
          List deviceStatistics = state.deviceStatistics;
          return Center(
            //padding: EdgeInsets.all(6.0),
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 3.0,
                  mainAxisSpacing: 3.0,
                ),
                itemBuilder: (_, int index) {
                  return Card(
                    color: _gridColors[index],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _gridTitles[index],
                          style: const TextStyle(
                            fontSize: CommonStyle.sizeL,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          deviceStatistics[index].toString(),
                          style: const TextStyle(
                            fontSize: CommonStyle.sizeM,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          );
        } else if (state.deviceStatisticsStatus.isRequestFailure) {
          return Center(
            child: Text(state.errmsg),
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
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}

Widget _buildLegend() {
  return Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const <Widget>[
      Indicator(
        color: Color(0xffdc3545),
        text: 'Critical',
        isSquare: true,
      ),
      SizedBox(
        height: 4,
      ),
      Indicator(
        color: Color(0xffffc107),
        text: 'Warning',
        isSquare: true,
      ),
      SizedBox(
        height: 4,
      ),
      Indicator(
        color: Color(0xff28a745),
        text: 'Normal',
        isSquare: true,
      ),
      SizedBox(
        height: 18,
      ),
    ],
  );
}

List<PieChartSectionData> showingSections(List alarmStatistics) {
  double totalAlarms = 0;
  alarmStatistics.forEach((element) {
    totalAlarms += element;
  });
  return List.generate(3, (i) {
    final fontSize = 12.0;
    final radius = 50.0;
    double percentage = (alarmStatistics[i] / totalAlarms) * 100.0;
    switch (i) {
      case 0:
        double percentage = (alarmStatistics[i] / totalAlarms) * 100.0;
        return PieChartSectionData(
          color: Color(0xffdc3545),
          value: percentage,
          title: '${percentage.toStringAsFixed(1)} %',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        );
      case 1:
        return PieChartSectionData(
          color: Color(0xffffc107),
          value: percentage,
          title: '${percentage.toStringAsFixed(1)} %',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        );
      case 2:
        return PieChartSectionData(
          color: Color(0xff28a745),
          value: percentage,
          title: '${percentage.toStringAsFixed(1)} %',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        );
      default:
        return PieChartSectionData(
          color: const Color(0xff0293ee),
          value: 40,
          title: '40%',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        );
    }
  });
}
