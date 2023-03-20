import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/custom_single_line_chart.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/full_screen_single_line_chart_form.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/utils/message_localization.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart_filter/chart_filter_bloc.dart';

class SingleAxisChartForm extends StatelessWidget {
  const SingleAxisChartForm({
    Key? key,
    required this.nodeName,
    required this.chartDateValuePairs,
    required this.name,
    this.majorH,
    this.majorL,
    this.minorH,
    this.minorL,
  }) : super(key: key);

  final String nodeName;
  final List<ChartDateValuePair> chartDateValuePairs;
  final String name;
  final double? majorH;
  final double? majorL;
  final double? minorH;
  final double? minorL;

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
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ChartTitle(
              name: name,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _FullScreenButton(
                  nodeName: nodeName,
                  parameterName: name,
                  chartDateValuePairs: chartDateValuePairs,
                  majorH: majorH,
                  majorL: majorL,
                  minorH: minorH,
                  minorL: majorL,
                ),
                _ExportButton(
                  nodeName: nodeName,
                  parameterName: name,
                  chartDateValuePairs: chartDateValuePairs,
                ),
              ],
            ),

            CustomSingleLineChart(
              chartDateValuePairList: chartDateValuePairs,
              name: name,
              majorH: majorH,
              majorL: majorL,
              minorH: minorH,
              minorL: minorL,
            ),
            const SizedBox(
              height: 20.0,
            ),
            // SingleAxisLineChart(
            //   chartDateValuePairs: chartDateValuePairs,
            //   name: name,
            //   majorH: majorH,
            //   majorL: majorL,
            //   minorH: minorH,
            //   minorL: minorL,
            // )
          ],
        ),
      ),
    );
  }
}

class _ChartTitle extends StatelessWidget {
  const _ChartTitle({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
      buildWhen: (previous, current) =>
          previous.checkBoxValues != current.checkBoxValues,
      builder: (context, state) {
        return Center(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: CommonStyle.sizeXXL,
            ),
          ),
        );
      },
    );
  }
}

class _FullScreenButton extends StatelessWidget {
  const _FullScreenButton({
    Key? key,
    required this.nodeName,
    required this.parameterName,
    required this.chartDateValuePairs,
    this.majorH,
    this.majorL,
    this.minorH,
    this.minorL,
  }) : super(key: key);

  final String nodeName;
  final String parameterName;
  final List<ChartDateValuePair> chartDateValuePairs;
  final double? majorH;
  final double? majorL;
  final double? minorH;
  final double? minorL;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 8.0, 0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    FullScreenSingleLineChartForm.route(
                      nodeName: nodeName,
                      chartDateValuePairs: chartDateValuePairs,
                      name: parameterName,
                      majorH: majorH,
                      majorL: majorL,
                      minorH: minorH,
                      minorL: minorL,
                    ),
                  );
                },
                child: const Icon(
                  Icons.fullscreen_outlined,
                  color: Colors.black,
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

class _ExportButton extends StatelessWidget {
  const _ExportButton({
    Key? key,
    required this.nodeName,
    required this.parameterName,
    required this.chartDateValuePairs,
  }) : super(key: key);

  final String nodeName;
  final String parameterName;
  final List<ChartDateValuePair> chartDateValuePairs;

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
                      .add(SingleAxisChartDataExported(
                        nodeName,
                        parameterName,
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
