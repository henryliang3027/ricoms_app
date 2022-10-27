import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/multiple_axis_chart/multiple_axis_chart_bloc.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/multiple_axis_chart_form.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/monitoring_chart_style.dart';

class MultipleAxisChartPage extends StatelessWidget {
  const MultipleAxisChartPage({
    Key? key,
    required this.index,
    required this.chartDateValuePairs,
    required this.nodeId,
    required this.startDate,
    required this.endDate,
    required this.selectedCheckBoxValues,
  }) : super(key: key);

  final Map<String, List<ChartDateValuePair>> chartDateValuePairs;
  final int index;
  final int nodeId;
  final String startDate;
  final String endDate;
  final Map<String, CheckBoxValue> selectedCheckBoxValues;

  @override
  Widget build(BuildContext context) {
    return MultipleAxisChartForm(
      selectedCheckBoxValues: selectedCheckBoxValues,
      chartDateValuePairs: chartDateValuePairs,
    );
    // BlocProvider(
    //   create: (context) => MultipleAxisChartBloc(
    //     index: index,
    //     user: context.read<AuthenticationBloc>().state.user,
    //     deviceRepository: RepositoryProvider.of<DeviceRepository>(context),
    //     startDate: startDate,
    //     endDate: endDate,
    //     nodeId: nodeId,
    //     selectedCheckBoxValues: selectedCheckBoxValues,
    //   ),
    //   child: MultipleAxisChartForm(
    //     selectedCheckBoxValues: selectedCheckBoxValues,
    //   ),
    // );
  }
}
