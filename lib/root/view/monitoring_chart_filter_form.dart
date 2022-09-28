import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/bloc/monitoring_chart/chart_filter_bloc.dart';
import 'package:ricoms_app/root/view/monitoring_chart_style.dart';
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
            _ThresholdListView(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _CancelButton(),
                _SaveButton(),
              ],
            ),
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
            String startDate = state.startDate.replaceAll('/', '');
            DateTime? datetime = await showDatePicker(
              context: context,
              initialDate:
                  startDate == '' ? DateTime.now() : DateTime.parse(startDate),
              firstDate: DateTime(2000),
              lastDate: DateTime(2050),
              locale: Localizations.localeOf(context),
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
            primary: Colors.white70,
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
      buildWhen: (previous, current) => previous.endDate != current.endDate,
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

            DateTime? datetime = await showDatePicker(
              context: context,
              initialDate: endDate.isAfter(startDate) ? endDate : startDate,
              firstDate: startDate,
              lastDate: DateTime(2050),
              locale: Localizations.localeOf(context),
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
            primary: Colors.white70,
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
  _ThresholdListView({Key? key}) : super(key: key);

  final Map<String, bool> checkBoxValues = {};
  final Map<String, ThresholdData> thresholdDataSet = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
        builder: (context, state) {
      if (state.status.isRequestSuccess) {
        return Container(
          decoration: BoxDecoration(
            //color: Colors.grey,
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var item in state.data) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10.0,
                      ),
                      for (var e in item) ...[
                        MonitoringChartStyle.getChartFilterData(
                            e: e,
                            checkBoxValues: checkBoxValues,
                            thresholdDataSet: thresholdDataSet)
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
        String errMsg = state.data[0];
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

class _CancelButton extends StatelessWidget {
  const _CancelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(CommonStyle.lineSpacing),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            shape: const RoundedRectangleBorder(
                side: BorderSide(width: 1.0, color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          key: const Key('monitoringChartFilterForm_cancel_raisedButton'),
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: const TextStyle(
              fontSize: CommonStyle.sizeM,
              color: Colors.black,
            ),
          ),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context
                .read<ChartFilterBloc>()
                .add(const FilterSelectingModeChanged());
          }),
    );
  }
}

class _SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartFilterBloc, ChartFilterState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(6),
          child: ElevatedButton(
              key: const Key('monitoringChartFilterForm_save_raisedButton'),
              child: Text(
                AppLocalizations.of(context)!.save,
                style: const TextStyle(
                  fontSize: CommonStyle.sizeM,
                ),
              ),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                context
                    .read<ChartFilterBloc>()
                    .add(const FilterSelectingModeChanged());
              }),
        );
      },
    );
  }
}
