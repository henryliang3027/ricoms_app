import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/history/bloc/search/search_bloc.dart';
import 'package:ricoms_app/history/model/search_critria.dart';
import 'package:ricoms_app/history/view/search_form.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
    Key? key,
    required this.searchCriteria,
  }) : super(key: key);

  final SearchCriteria searchCriteria;

  static Route route(SearchCriteria searchCriteria) {
    return MaterialPageRoute(
        builder: (_) => SearchPage(
              searchCriteria: searchCriteria,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(searchCriteria: searchCriteria),
      child: const SearchForm(),
    );
  }
}
