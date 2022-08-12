import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/history/bloc/search/search_bloc.dart';
import 'package:ricoms_app/utils/common_style.dart';

class SearchForm extends StatelessWidget {
  const SearchForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Filters'),
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
                    const _WidgetTitle(title: 'Date'),
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
                    const _WidgetTitle(title: 'Category'),
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                    ),
                    const _ShelfSelector(),
                    const _SlotSelector(),
                    const _CurrentIssueCheckBox(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    const _WidgetTitle(title: 'Applied Filter'),
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
    return BlocBuilder<SearchBloc, SearchState>(
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
                  context.read<SearchBloc>().add(KeywordChanged(keyword));
                }
              },
              onFieldSubmitted: (String? keyword) {
                context.read<SearchBloc>().add(CriteriaSaved(context));
                // context.read<SearchBloc>().add(const FilterAdded());
                // _controller.clear();
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0),
                ),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Search here...',
                labelStyle: const TextStyle(
                  fontSize: CommonStyle.sizeL,
                ),
                suffixIconConstraints: const BoxConstraints(
                    maxHeight: 36, maxWidth: 36, minHeight: 36, minWidth: 36),
                suffixIcon: Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    splashColor: Colors.blue.shade100,
                    iconSize: 22,
                    icon: const Icon(
                      Icons.search_outlined,
                    ),
                    onPressed: () {
                      context.read<SearchBloc>().add(CriteriaSaved(context));
                      // context.read<SearchBloc>().add(const FilterAdded());
                      // _controller.clear();
                    },
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
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (previous, current) => previous.startDate != current.startDate,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () async {
            String startDate = state.startDate.replaceAll('/', '');
            DateTime? datetime = await showDatePicker(
                context: context,
                initialDate: startDate == ''
                    ? DateTime.now()
                    : DateTime.parse(startDate),
                firstDate: DateTime(2000),
                lastDate: DateTime(2050));

            if (datetime != null) {
              String formattedDateTime =
                  DateFormat('yyyy-MM-dd').format(datetime).toString();
              context
                  .read<SearchBloc>()
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
    return BlocBuilder<SearchBloc, SearchState>(
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
                lastDate: DateTime(2050));

            if (datetime != null) {
              String formattedDateTime =
                  DateFormat('yyyy-MM-dd').format(datetime).toString();
              context.read<SearchBloc>().add(EndDateChanged(formattedDateTime));
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

Map<String, String> shelfItem = {
  'All': '',
  '01': '1',
  '02': '2',
  '03': '3',
  '04': '4',
  '05': '5',
  '06': '6',
  '07': '7',
  '08': '8',
  '09': '9',
  '10': '10',
  '11': '11',
  '12': '12',
};

Map<String, String> slotItem = {
  'All': '',
  '01': '1',
  '02': '2',
  '03': '3',
  '04': '4',
  '05': '5',
  '06': '6',
  '07': '7',
  '08': '8',
  '09': '9',
  '10': '10',
  '11': '11',
  '12': '12',
  '13': '13',
  '14': '14',
  '15': '15',
  '16': '16',
  'FAN': '0',
};

class _ShelfSelector extends StatelessWidget {
  const _ShelfSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showShelfListDialog(
        BuildContext buildContext, String initialValue) async {
      return showDialog<void>(
        context: buildContext,
        barrierDismissible: false, // user must tap button!
        builder: (_) {
          return Dialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Shelf',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: shelfItem.keys.length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        title: Text(shelfItem.keys.toList()[index]),
                        value: shelfItem.values.toList()[index],
                        groupValue: initialValue,
                        toggleable: true,
                        onChanged: (String? value) {
                          //will not be call if radio is selected again
                          //which cause this dialog will not be pop
                          //so we set toggleable to be true and it return null when selected again
                          //we will not do anything but pop dialog if return null
                          value != null
                              ? buildContext
                                  .read<SearchBloc>()
                                  .add(ShelfChanged(value))
                              : null;
                          Navigator.pop(buildContext);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return BlocBuilder<SearchBloc, SearchState>(
        buildWhen: (previous, current) => previous.shelf != current.shelf,
        builder: (context, state) {
          return ListTile(
            title: const Text('Shelf'),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  shelfItem.keys.firstWhere(
                      (element) => shelfItem[element] == state.shelf),
                ),
                const Icon(Icons.arrow_forward_ios_outlined),
              ],
            ),
            onTap: () async => await _showShelfListDialog(context, state.shelf),
          );
        });
  }
}

class _SlotSelector extends StatelessWidget {
  const _SlotSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showSlotListDialog(
        BuildContext buildContext, String initialValue) async {
      return showDialog<void>(
        context: buildContext,
        barrierDismissible: false, // user must tap button!
        builder: (_) {
          return Dialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Slot',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: slotItem.keys.length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        title: Text(slotItem.keys.toList()[index]),
                        value: slotItem.values.toList()[index],
                        groupValue: initialValue,
                        toggleable: true,
                        onChanged: (String? value) {
                          value != null
                              ? buildContext
                                  .read<SearchBloc>()
                                  .add(SlotChanged(value))
                              : null;
                          Navigator.pop(buildContext);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return BlocBuilder<SearchBloc, SearchState>(
        buildWhen: (previous, current) => previous.slot != current.slot,
        builder: (context, state) {
          return ListTile(
            title: const Text('Slot'),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  slotItem.keys
                      .firstWhere((element) => slotItem[element] == state.slot),
                ),
                const Icon(Icons.arrow_forward_ios_outlined),
              ],
            ),
            onTap: () async => await _showSlotListDialog(context, state.slot),
          );
        });
  }
}

class _CurrentIssueCheckBox extends StatelessWidget {
  const _CurrentIssueCheckBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
        buildWhen: (previous, current) =>
            previous.unsolvedOnly != current.unsolvedOnly,
        builder: (context, state) {
          return CheckboxListTile(
              title: const Text('Show open issue only'),
              value: state.unsolvedOnly,
              onChanged: (bool? value) {
                context
                    .read<SearchBloc>()
                    .add(CurrentIssueChanged(value ?? false));
              });
        });
  }
}

class _AppliedFilterList extends StatelessWidget {
  const _AppliedFilterList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
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
                      label: const Text('Clear all filters'),
                      onPressed: () {
                        context.read<SearchBloc>().add(const FilterCleared());
                      },
                    )
                  : Container(),
              ...List<Widget>.generate(
                state.queries.length,
                (int index) {
                  return InputChip(
                    avatar: index == 0
                        ? const Icon(Icons.calendar_month_outlined)
                        : const Icon(Icons.tag),
                    label: Text(state.queries[index]),
                    onDeleted: () {
                      context.read<SearchBloc>().add(FilterDeleted(index));
                    },
                  );
                },
              ).toList(),
            ],
          );
        });
  }
}
