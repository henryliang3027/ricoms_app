import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/edit_group/edit_group_bloc.dart';
import 'package:ricoms_app/root/view/group_edit_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupEditPage extends StatelessWidget {
  const GroupEditPage({
    Key? key,
    required this.user,
    required this.rootRepository,
    required this.parentNode,
    required this.isEditing,
    this.currentNode,
  }) : super(key: key);

  static Route route({
    required User user,
    required RootRepository rootRepository,
    required Node parentNode,
    required bool isEditing,
    Node? currentNode,
  }) {
    return MaterialPageRoute(
        builder: (_) => GroupEditPage(
              user: user,
              rootRepository: rootRepository,
              parentNode: parentNode,
              isEditing: isEditing,
              currentNode: currentNode,
            ));
  }

  final User user;
  final RootRepository rootRepository;
  final Node parentNode;
  final bool isEditing;
  final Node? currentNode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: ((context) => EditGroupBloc(
            user: user,
            rootRepository: rootRepository,
            parentNode: parentNode,
            isEditing: isEditing,
            currentNode: currentNode)),
        child: Scaffold(
          //resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: isEditing
                ? Text(AppLocalizations.of(context)!.editGroup)
                : Text(AppLocalizations.of(context)!.addGroup),
          ),
          body: const GroupEditForm(),
        ));
  }
}
