import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart_filter/chart_filter_bloc.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/monitoring_chart_style.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MonitoringChartFilterForm extends StatelessWidget {
  const MonitoringChartFilterForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _WidgetTitle(
              title: AppLocalizations.of(context)!.date,
            ),
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _StartDatePicker(),
                  Text('-'),
                  _EndDatePicker(),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
            ),
            _WidgetTitle(
              title: AppLocalizations.of(context)!.parameter,
            ),
            const Padding(
              padding: EdgeInsets.all(4.0),
            ),
            const _SelectAllCheckBox(),
            const _ThresholdListView(),
            const _MultipleYAxisCheckBox(),
            const _SaveButton(),
          ],
        ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: CommonStyle.sizeS,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StartDatePicker extends StatelessWidget {
  const _StartDatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
      buildWhen: (previous, current) => previous.startDate != current.startDate,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () async {
            String formattedStartDate = state.startDate.replaceAll('/', '');
            DateTime startDate = formattedStartDate == ''
                ? DateTime.now()
                : DateTime.parse(formattedStartDate);

            DateTime? datetime = await showDatePicker(
              context: context,
              initialDate: startDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2050),
              locale: Localizations.localeOf(context),
              initialEntryMode: DatePickerEntryMode.calendarOnly,
            );

            if (datetime != null) {
              String formattedDateTime =
                  DateFormat('yyyy-MM-dd').format(datetime).toString();
              context
                  .read<ChartFilterBloc>()
                  .add(StartDateChanged(formattedDateTime));
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.startDate,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              const Icon(
                Icons.calendar_month_outlined,
                color: Colors.black,
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(6.0, 0.0, 8.0, 0.0),
            backgroundColor: Colors.white70,
            elevation: 0,
            visualDensity: const VisualDensity(
              horizontal: -4.0,
              vertical: -4.0,
            ),
          ),
        );
      },
    );
  }
}

class _EndDatePicker extends StatelessWidget {
  const _EndDatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
      buildWhen: (previous, current) =>
          previous.endDate != current.endDate ||
          previous.startDate != current.startDate,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () async {
            String formattedStartDate = state.startDate.replaceAll('/', '');
            String formattedEndDate = state.endDate.replaceAll('/', '');
            DateTime startDate = formattedStartDate == ''
                ? DateTime.now()
                : DateTime.parse(formattedStartDate);
            DateTime endDate = formattedEndDate == ''
                ? DateTime.now()
                : DateTime.parse(formattedEndDate);
            DateTime lastate = startDate.add(const Duration(days: 30));

            DateTime? datetime = await showDatePicker(
              context: context,
              initialDate: endDate,
              firstDate: startDate,
              lastDate: lastate,
              locale: Localizations.localeOf(context),
              initialEntryMode: DatePickerEntryMode.calendarOnly,
            );

            if (datetime != null) {
              String formattedDateTime =
                  DateFormat('yyyy-MM-dd').format(datetime).toString();
              context
                  .read<ChartFilterBloc>()
                  .add(EndDateChanged(formattedDateTime));
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.endDate,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              const Icon(
                Icons.calendar_month_outlined,
                color: Colors.black,
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(6.0, 0.0, 8.0, 0.0),
            backgroundColor: Colors.white70,
            elevation: 0,
            visualDensity: const VisualDensity(
              horizontal: -4.0,
              vertical: -4.0,
            ),
          ),
        );
      },
    );
  }
}

class _ThresholdListView extends StatelessWidget {
  const _ThresholdListView({Key? key}) : super(key: key);

  Widget _buildItem(
      ItemProperty itemProperty, Map<String, CheckBoxValue> checkBoxValues) {
    if (itemProperty.runtimeType == TextProperty) {
      TextProperty textProperty = itemProperty as TextProperty;
      return Expanded(
        flex: textProperty.boxLength,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: textProperty.boxColor,
              border: Border.all(color: textProperty.borderColor),
            ),
            child: Text(
              textProperty.text,
              style: TextStyle(
                color: textProperty.textColor,
                fontSize: textProperty.fontSize,
              ),
            ),
          ),
        ),
      );
    } else if (itemProperty.runtimeType == CheckBoxProperty) {
      CheckBoxProperty checkBoxProperty = itemProperty as CheckBoxProperty;
      return _FilterCheckBoxes(
        checkBoxProperty: checkBoxProperty,
        oid: checkBoxProperty.oid,
        value: checkBoxValues[checkBoxProperty.oid]!.value,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
        builder: (context, state) {
      if (state.status.isRequestSuccess) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2.0),
            borderRadius: const BorderRadius.all(Radius.circular(2.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 14.0,
              top: 8.0,
              right: 14.0,
              bottom: 8.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0;
                    i < state.itemPropertiesCollection.length;
                    i++) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (ItemProperty itemProperty
                          in state.itemPropertiesCollection[i]) ...[
                        _buildItem(itemProperty, state.checkBoxValues),
                      ]
                    ],
                  )
                ],
                const SizedBox(
                  height: 0,
                ),
              ],
            ),
          ),
        );
      } else if (state.status.isRequestFailure) {
        String errMsg = state.requestErrorMsg;
        return Center(
          child: Text(errMsg),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}

class _FilterCheckBoxes extends StatelessWidget {
  const _FilterCheckBoxes({
    Key? key,
    required this.checkBoxProperty,
    required this.oid,
    required this.value,
  }) : super(key: key);

  final CheckBoxProperty checkBoxProperty;
  final String oid;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
      builder: (context, state) {
        return Checkbox(
          visualDensity: const VisualDensity(vertical: -4.0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: value,
          onChanged: (value) {
            if (value != null) {
              context
                  .read<ChartFilterBloc>()
                  .add(CheckBoxValueChanged(oid, value));
            }
          },
        );
      },
    );
  }
}

class _SelectAllCheckBox extends StatelessWidget {
  const _SelectAllCheckBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
      buildWhen: (previous, current) =>
          previous.isSelectAll != current.isSelectAll,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 2.0),
            borderRadius: const BorderRadius.all(Radius.circular(2.0)),
          ),
          child: CheckboxListTile(
            title: Text(
              AppLocalizations.of(context)!.selectAll,
              style: const TextStyle(
                fontSize: CommonStyle.sizeM,
              ),
            ),
            value: state.isSelectAll,
            visualDensity: const VisualDensity(vertical: -4.0),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),
            onChanged: (bool? value) {
              context
                  .read<ChartFilterBloc>()
                  .add(AllCheckBoxValueChanged(value ?? false));
            },
          ),
        );
      },
    );
  }
}

class _MultipleYAxisCheckBox extends StatelessWidget {
  const _MultipleYAxisCheckBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
      buildWhen: (previous, current) =>
          previous.isShowMultipleYAxis != current.isShowMultipleYAxis ||
          previous.isSelectMultipleYAxis != current.isSelectMultipleYAxis,
      builder: (context, state) {
        return state.isShowMultipleYAxis
            ? Padding(
                padding: const EdgeInsets.only(
                  bottom: 4.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      AppLocalizations.of(context)!.multipleYAxis,
                      style: const TextStyle(
                        fontSize: CommonStyle.sizeM,
                      ),
                    ),
                    value: state.isSelectMultipleYAxis,
                    visualDensity: const VisualDensity(vertical: -4.0),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14.0),
                    onChanged: (bool? value) {
                      context.read<ChartFilterBloc>().add(
                          MultipleYAxisCheckBoxValueChanged(value ?? false));
                    },
                  ),
                ),
              )
            : Container();
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
      buildWhen: (previous, current) =>
          previous.selectedCheckBoxValues != current.selectedCheckBoxValues,
      builder: (context, state) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: SizedBox(
              height: 40,
              width: 80,
              child: ElevatedButton(
                key: const Key('monitoringChartFilterForm_save_raisedButton'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue;
                      } else if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      }
                      return null; // Use the component's default.
                    },
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.save,
                  style: const TextStyle(
                    fontSize: CommonStyle.sizeM,
                  ),
                ),
                onPressed: state.selectedCheckBoxValues.isNotEmpty
                    ? () {
                        //FocusManager.instance.primaryFocus?.unfocus();
                        context
                            .read<ChartFilterBloc>()
                            .add(const FilterSelectingModeDisabled());
                      }
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
