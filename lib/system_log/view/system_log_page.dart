import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/system_log_repository.dart';
import 'package:ricoms_app/system_log/bloc/system_log/system_log_bloc.dart';
import 'package:ricoms_app/system_log/view/system_log_form.dart';

class SystemLogPage extends StatelessWidget {
  const SystemLogPage({
    Key? key,
    required this.pageController,
    required this.initialRootPath,
  }) : super(key: key);

  final PageController pageController;
  final List initialRootPath;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SystemLogBloc(
        user: context.read<AuthenticationBloc>().state.user,
        systemLogRepository:
            RepositoryProvider.of<SystemLogRepository>(context),
      ),
      child: SystemLogForm(
        pageController: pageController,
        initialPath: initialRootPath,
      ),
    );
  }
}
