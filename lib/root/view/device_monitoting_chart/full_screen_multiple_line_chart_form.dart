import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/custom_multiple_line_chart.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/custom_single_line_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/monitoring_chart_style.dart';
import 'package:ricoms_app/utils/common_style.dart';

class FullScreenMultipleLineChartForm extends StatefulWidget {
  const FullScreenMultipleLineChartForm({
    Key? key,
    required this.nodeName,
    required this.checkBoxValues,
    required this.chartDateValuePairs,
  }) : super(key: key);

  static Route route({
    required String nodeName,
    required Map<String, List<ChartDateValuePair>> chartDateValuePairs,
    required Map<String, CheckBoxValue> checkBoxValues,
  }) {
    return MaterialPageRoute(
      builder: (_) => FullScreenMultipleLineChartForm(
        nodeName: nodeName,
        chartDateValuePairs: chartDateValuePairs,
        checkBoxValues: checkBoxValues,
      ),
    );
  }

  final String nodeName;
  final Map<String, CheckBoxValue> checkBoxValues;
  final Map<String, List<ChartDateValuePair>> chartDateValuePairs;

  @override
  State<FullScreenMultipleLineChartForm> createState() =>
      _FullScreenMultipleLineChartFormState();
}

class _FullScreenMultipleLineChartFormState
    extends State<FullScreenMultipleLineChartForm> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.lineChart,
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomMultipleLineChart(
                chartDateValuePairListMap: widget.chartDateValuePairs,
                selectedCheckBoxValuesMap: widget.checkBoxValues,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
