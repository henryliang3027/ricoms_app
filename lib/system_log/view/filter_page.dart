import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/system_log/bloc/filter/filter_bloc.dart';
import 'package:ricoms_app/system_log/model/filter_critria.dart';
import 'package:ricoms_app/system_log/view/filter_form.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({
    Key? key,
    required this.filterCriteria,
  }) : super(key: key);

  final FilterCriteria filterCriteria;

  static Route route(FilterCriteria filterCriteria) {
    return MaterialPageRoute(
        builder: (_) => FilterPage(
              filterCriteria: filterCriteria,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterBloc(filterCriteria: filterCriteria),
      child: const FilterForm(),
    );
  }
}
