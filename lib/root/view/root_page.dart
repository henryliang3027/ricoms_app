import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/root/root_bloc.dart';
import 'package:ricoms_app/root/view/root_form.dart';

class RootPage extends StatefulWidget {
  RootPage({Key? key, required this.pageController}) : super(key: key);

  final PageController pageController;
  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RootBloc(
          rootRepository: RepositoryProvider.of<RootRepository>(context),
          deviceRepository: RepositoryProvider.of<DeviceRepository>(context)),
      child: RootForm(pageController: widget.pageController),
    );
  }
}
