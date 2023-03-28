import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/root_repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/root/root_bloc.dart';
import 'package:ricoms_app/root/view/root_form.dart';

class RootPage extends StatefulWidget {
  const RootPage({
    Key? key,
    required this.pageController,
    required this.initialRootPath,
  }) : super(key: key);

  final PageController pageController;
  final List initialRootPath;

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RootBloc(
        user: context.read<AuthenticationBloc>().state.user,
        rootRepository: RepositoryProvider.of<RootRepository>(context),
        initialPath: widget.initialRootPath,
      ),
      child: RootForm(pageController: widget.pageController),
    );
  }
}
