import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/edit_device/edit_device_bloc.dart';
import 'package:ricoms_app/root/view/device_edit_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeviceEditPage extends StatelessWidget {
  const DeviceEditPage({
    Key? key,
    required this.user,
    required this.parentNode,
    required this.isEditing,
    this.currentNode,
  }) : super(key: key);

  static Route route({
    required User user,
    required Node parentNode,
    required bool isEditing,
    Node? currentNode,
  }) {
    return MaterialPageRoute(
        builder: (_) => DeviceEditPage(
              user: user,
              parentNode: parentNode,
              isEditing: isEditing,
              currentNode: currentNode,
            ));
  }

  final User user;
  final Node parentNode;
  final bool isEditing;
  final Node? currentNode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: ((context) => EditDeviceBloc(
              user: user,
              rootRepository: RepositoryProvider.of<RootRepository>(context),
              parentNode: parentNode,
              isEditing: isEditing,
              currentNode: currentNode,
            )),
        child: Scaffold(
          //resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            title: isEditing
                ? Text(AppLocalizations.of(context)!.editDevice)
                : Text(AppLocalizations.of(context)!.addDevice),
          ),
          body: const DeviceEditForm(),
        ));
  }
}
