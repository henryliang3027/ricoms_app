import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/account/bloc/edit_account/edit_account_bloc.dart';
import 'package:ricoms_app/account/view/account_edit_form.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/account_outline.dart';
import 'package:ricoms_app/repository/account_repository.dart';

class AccountEditPage extends StatelessWidget {
  const AccountEditPage({
    Key? key,
    required this.isEditing,
    this.accountOutline,
  }) : super(key: key);

  static Route<bool> route({
    required bool isEditing,
    AccountOutline? accountOutline,
  }) {
    return MaterialPageRoute(
        builder: (_) => AccountEditPage(
              isEditing: isEditing,
              accountOutline: accountOutline,
            ));
  }

  final bool isEditing;
  final AccountOutline? accountOutline;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditAccountBloc(
        user: context.read<AuthenticationBloc>().state.user,
        accountRepository: RepositoryProvider.of<AccountRepository>(context),
        isEditing: isEditing,
        accountOutline: accountOutline,
      ),
      child: AccountEditForm(isEditing: isEditing),
    );
  }
}
