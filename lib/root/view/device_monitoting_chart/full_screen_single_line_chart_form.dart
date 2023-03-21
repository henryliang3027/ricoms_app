import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/custom_line_chart/custom_single_line_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/utils/common_style.dart';

class FullScreenSingleLineChartForm extends StatefulWidget {
  const FullScreenSingleLineChartForm({
    Key? key,
    required this.nodeName,
    required this.chartDateValuePairs,
    required this.name,
    this.majorH,
    this.majorL,
    this.minorH,
    this.minorL,
  }) : super(key: key);

  static Route route({
    required String nodeName,
    required List<ChartDateValuePair> chartDateValuePairs,
    required String name,
    double? majorH,
    double? majorL,
    double? minorH,
    double? minorL,
  }) {
    return MaterialPageRoute(
      builder: (_) => FullScreenSingleLineChartForm(
          nodeName: nodeName,
          chartDateValuePairs: chartDateValuePairs,
          name: name,
          majorH: majorH,
          majorL: majorL,
          minorH: minorH,
          minorL: minorL),
    );
  }

  final String nodeName;
  final List<ChartDateValuePair> chartDateValuePairs;
  final String name;
  final double? majorH;
  final double? majorL;
  final double? minorH;
  final double? minorL;

  @override
  State<FullScreenSingleLineChartForm> createState() =>
      _FullScreenSingleLineChartFormState();
}

class _FullScreenSingleLineChartFormState
    extends State<FullScreenSingleLineChartForm> {
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
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: CommonStyle.sizeXXL,
                  ),
                ),
              ),
              CustomSingleLineChart(
                chartDateValuePairList: widget.chartDateValuePairs,
                name: widget.name,
                majorH: widget.majorH,
                majorL: widget.majorL,
                minorH: widget.minorH,
                minorL: widget.minorL,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
