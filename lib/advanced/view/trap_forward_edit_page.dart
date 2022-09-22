import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/advanced/bloc/edit_trap_forward/edit_trap_forward_bloc.dart';
import 'package:ricoms_app/advanced/view/trap_forward_edit_form.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/forward_outline.dart';
import 'package:ricoms_app/repository/trap_forward_repository.dart';

class TrapForwardEditPage extends StatelessWidget {
  const TrapForwardEditPage({
    Key? key,
    required this.isEditing,
    this.forwardOutline,
  }) : super(key: key);

  static Route<bool> route({
    required bool isEditing,
    ForwardOutline? forwardOutline,
  }) {
    return MaterialPageRoute(
        builder: (_) => TrapForwardEditPage(
              isEditing: isEditing,
              forwardOutline: forwardOutline,
            ));
  }

  final bool isEditing;
  final ForwardOutline? forwardOutline;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditTrapForwardBloc(
        user: context.read<AuthenticationBloc>().state.user,
        trapForwardRepository:
            RepositoryProvider.of<TrapForwardRepository>(context),
        forwardOutline: forwardOutline,
        isEditing: isEditing,
      ),
      child: TrapForwardEditForm(
        isEditing: isEditing,
        forwardOutline: forwardOutline,
      ),
    );
  }
}
