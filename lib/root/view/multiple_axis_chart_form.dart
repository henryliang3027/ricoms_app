import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ricoms_app/root/view/monitoring_chart_style.dart';

class MultipleAxisChartForm extends StatelessWidget {
  const MultipleAxisChartForm({
    Key? key,
    required this.selectedCheckBoxValues,
  }) : super(key: key);

  final Map<String, CheckBoxValue> selectedCheckBoxValues;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
