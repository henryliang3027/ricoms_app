import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/multiple_axis_chart/multiple_axis_chart_bloc.dart';
import 'package:ricoms_app/root/view/monitoring_chart_style.dart';
import 'package:ricoms_app/root/view/multiple_axis_line_chart.dart';

class MultipleAxisChartForm extends StatelessWidget {
  const MultipleAxisChartForm({
    Key? key,
    required this.selectedCheckBoxValues,
  }) : super(key: key);

  final Map<String, CheckBoxValue> selectedCheckBoxValues;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultipleAxisChartBloc, MultipleAxisChartState>(
      builder: (context, state) {
        if (state.status.isRequestSuccess) {
          return MultipleAxisLineChart(
            chartDateValues: state.chartDateValues,
            checkBoxValues: selectedCheckBoxValues,
          );
        } else if (state.status.isRequestFailure) {
          return Center(
            child: Text(state.errMsg),
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
