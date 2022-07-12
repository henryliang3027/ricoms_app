import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/history/bloc/history/history_bloc.dart';
import 'package:ricoms_app/history/view/history_form.dart';
import 'package:ricoms_app/repository/history_repository.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    Key? key,
    required this.pageController,
    required this.initialRootPath,
  }) : super(key: key);

  final PageController pageController;
  final List initialRootPath;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryBloc(
        user: context.read<AuthenticationBloc>().state.user,
        historyRepository: RepositoryProvider.of<HistoryRepository>(context),
      ),
      child: HistoryForm(
        pageController: widget.pageController,
        initialPath: widget.initialRootPath,
      ),
    );
  }
}
