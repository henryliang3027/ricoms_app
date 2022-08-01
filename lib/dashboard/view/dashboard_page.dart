import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/dashboard/bloc/dashboard_bloc.dart';
import 'package:ricoms_app/dashboard/view/dashboard_form.dart';
import 'package:ricoms_app/repository/dashboard_repository.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(
        user: context.read<AuthenticationBloc>().state.user,
        dashboardRepository:
            RepositoryProvider.of<DashboardRepository>(context),
      ),
      child: DashboardForm(
        pageController: pageController,
      ),
    );
  }
}
