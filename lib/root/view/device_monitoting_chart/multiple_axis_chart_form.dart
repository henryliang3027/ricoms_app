import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart_filter/chart_filter_bloc.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/custom_multiple_line_chart.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/monitoring_chart_style.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/multiple_axis_line_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class MultipleAxisChartForm extends StatelessWidget {
  const MultipleAxisChartForm({
    Key? key,
    required this.nodeName,
    required this.chartDateValuePairs,
    required this.selectedCheckBoxValues,
  }) : super(key: key);

  final String nodeName;
  final Map<String, List<ChartDateValuePair>> chartDateValuePairs;
  final Map<String, CheckBoxValue> selectedCheckBoxValues;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChartFilterBloc, ChartFilterState>(
      listener: (context, state) {
        if (state.chartDataExportStatus.isRequestSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  getMessageLocalization(
                    msg: state.chartDataExportMsg,
                    context: context,
                  ),
                ),
                action: SnackBarAction(
                  label: AppLocalizations.of(context)!.open,
                  onPressed: () {
                    OpenFilex.open(
                      state.chartDataExportFilePath,
                      type: 'application/vnd.ms-excel',
                      uti: 'com.microsoft.excel.xls',
                    );
                  },
                ),
              ),
            );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ExportButton(
            nodeName: nodeName,
            chartDateValuePairs: chartDateValuePairs,
            checkBoxValues: selectedCheckBoxValues,
          ),
          CustomMultipleLineChart(
            chartDateValuePairListMap: chartDateValuePairs,
            selectedCheckBoxValuesMap: selectedCheckBoxValues,
          ),
          // SizedBox(
          //   height: 400,
          //   child: MultipleAxisLineChart(
          //     nodeName: nodeName,
          //     chartDateValues: chartDateValuePairs,
          //     checkBoxValues: selectedCheckBoxValues,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  const _ExportButton({
    Key? key,
    required this.nodeName,
    required this.checkBoxValues,
    required this.chartDateValuePairs,
  }) : super(key: key);

  final String nodeName;
  final Map<String, CheckBoxValue> checkBoxValues;
  final Map<String, List<ChartDateValuePair>> chartDateValuePairs;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 10.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  context
                      .read<ChartFilterBloc>()
                      .add(MultipleAxisChartDataExported(
                        nodeName,
                        checkBoxValues,
                        chartDateValuePairs,
                      ));
                },
                child: Text(
                  AppLocalizations.of(context)!.export,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  elevation: 0,
                  side: const BorderSide(
                    width: 1.0,
                    color: Colors.black,
                  ),
                  visualDensity:
                      const VisualDensity(horizontal: -4.0, vertical: -4.0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
