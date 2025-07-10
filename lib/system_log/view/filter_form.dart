import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/system_log/bloc/filter/filter_bloc.dart';
import 'package:ricoms_app/system_log/model/filter_critria.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterForm extends StatelessWidget {
  const FilterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.filters,
        ),
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              height: double.maxFinite,
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                    ),
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
                      title: AppLocalizations.of(context)!.appliedFilter,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                    ),
                    const _AppliedFilterList(),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _KeywordInput(),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: const _FilterFloatingActionButton(),
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

class _KeywordInput extends StatelessWidget {
  _KeywordInput({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
        buildWhen: (previous, current) => previous.keyword != current.keyword,
        builder: (context, state) {
          return SizedBox(
            child: TextFormField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (String? keyword) {
                if (keyword != null) {
                  context.read<FilterBloc>().add(KeywordChanged(keyword));
                }
              },
              onFieldSubmitted: (String? keyword) {
                context.read<FilterBloc>().add(CriteriaSaved(context));
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8.0),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0),
                ),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                labelText: AppLocalizations.of(context)!.searchHint,
                labelStyle: const TextStyle(
                  fontSize: CommonStyle.sizeL,
                ),
                floatingLabelStyle: const TextStyle(
                  color: Colors.black,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _StartDatePicker extends StatelessWidget {
  const _StartDatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
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
              initialEntryMode: DatePickerEntryMode.calendarOnly,
            );

            if (datetime != null) {
              String formattedDateTime =
                  DateFormat('yyyy-MM-dd').format(datetime).toString();
              context
                  .read<FilterBloc>()
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
    return BlocBuilder<FilterBloc, FilterState>(
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

            DateTime? datetime = await showDatePicker(
              context: context,
              initialDate: endDate.isAfter(startDate) ? endDate : startDate,
              firstDate: startDate,
              lastDate: DateTime(2050),
              locale: Localizations.localeOf(context),
              initialEntryMode: DatePickerEntryMode.calendarOnly,
            );

            if (datetime != null) {
              String formattedDateTime =
                  DateFormat('yyyy-MM-dd').format(datetime).toString();
              context.read<FilterBloc>().add(EndDateChanged(formattedDateTime));
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

class _AppliedFilterList extends StatelessWidget {
  const _AppliedFilterList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
        buildWhen: (previous, current) => previous.queries != current.queries,
        builder: (context, state) {
          return Wrap(
            // main axis spacing
            spacing: 5.0,
            // cross axis spacing
            runSpacing: 8.0,
            // main axis alignment
            alignment: WrapAlignment.start,
            // cross axis alignment
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              state.queries.isNotEmpty
                  ? InputChip(
                      label: Text(
                        AppLocalizations.of(context)!.clearAllFilters,
                      ),
                      onPressed: () {
                        context.read<FilterBloc>().add(const FilterCleared());
                      },
                    )
                  : Container(),
              ...List<Widget>.generate(
                state.queries.length,
                (int index) {
                  return InputChip(
                    // 檢查第一筆 InputChip 是不是日期的query, 來決定icon
                    // 如果是則使用 calendar icon, 否則使用 tag icon
                    // 其他筆 InputChip 都是用 tag icon
                    avatar: index == 0
                        ? isDateQuery(state.queries[index])
                            ? const Icon(Icons.calendar_month_outlined)
                            : const Icon(Icons.tag)
                        : const Icon(Icons.tag),
                    label: Text(state.queries[index]),
                    onDeleted: () {
                      context.read<FilterBloc>().add(FilterDeleted(index));
                    },
                  );
                },
              ).toList(),
            ],
          );
        });
  }
}

class _FilterFloatingActionButton extends StatelessWidget {
  const _FilterFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0.0,
      backgroundColor: const Color(0x742195F3),
      onPressed: () {
        context.read<FilterBloc>().add(CriteriaSaved(context));
      },
      child: const Icon(
        Icons.search_outlined,
      ),
    );
  }
}
