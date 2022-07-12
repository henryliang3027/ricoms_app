import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/history/bloc/search/search_bloc.dart';
import 'package:ricoms_app/history/view/search_form.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<List>(builder: (_) => const SearchPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: const SearchForm(),
    );
  }
}
