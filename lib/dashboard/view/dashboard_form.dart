import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/dashboard/bloc/dashboard_bloc.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

class DashboardForm extends StatelessWidget {
  const DashboardForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DeviceStatisticsGridView(),
      ],
    );
  }
}

class AlarmStatisticsPieChart extends StatelessWidget {
  const AlarmStatisticsPieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DeviceStatisticsGridView extends StatelessWidget {
  const DeviceStatisticsGridView({Key? key}) : super(key: key);

  final gridTitles = const [
    'All',
    'Critical',
    'Warning',
    'Normal',
    'Offline',
    'Unknown',
  ];

  final gridColors = const [
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
          return Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: GridView.builder(
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 6.0,
                    mainAxisSpacing: 6.0,
                  ),
                  itemBuilder: (_, int index) {
                    return GridTile(
                      child: Container(
                        color: gridColors[index],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(gridTitles[index]),
                            Text(deviceStatistics[index].toString()),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
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
