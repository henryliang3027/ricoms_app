import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/account/bloc/account/account_bloc.dart';
import 'package:ricoms_app/account/view/account_form.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/account_repository.dart';

class AdvancedPage extends StatelessWidget {
  const AdvancedPage({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Advanced'),
    );
    // BlocProvider(
    //   create: (context) => AccountBloc(
    //     user: context.read<AuthenticationBloc>().state.user,
    //     accountRepository: RepositoryProvider.of<AccountRepository>(context),
    //   ),
    //   child: AccountForm(
    //     pageController: pageController,
    //   ),
    // );
  }
}
