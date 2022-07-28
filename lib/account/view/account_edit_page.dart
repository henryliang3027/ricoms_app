import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/account/bloc/edit_account/edit_account_bloc.dart';
import 'package:ricoms_app/account/view/account_edit_form.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/account_repository.dart';

class AccountEditPage extends StatelessWidget {
  const AccountEditPage({
    Key? key,
    required this.isEditing,
  }) : super(key: key);

  static Route route({
    required bool isEditing,
  }) {
    return MaterialPageRoute(
        builder: (_) => AccountEditPage(
              isEditing: isEditing,
            ));
  }

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditAccountBloc(
        user: context.read<AuthenticationBloc>().state.user,
        accountRepository: RepositoryProvider.of<AccountRepository>(context),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: isEditing
              ? const Text('Edit Account')
              : const Text('Add Account'),
        ),
        body: const AccountEditForm(),
      ),
    );
  }
}
