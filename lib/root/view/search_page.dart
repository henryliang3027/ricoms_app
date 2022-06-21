import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/search/search_bloc.dart';
import 'package:ricoms_app/root/view/search_form.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
    required this.rootRepository,
    required this.deviceRepository,
  }) : super(key: key);

  static Route route(
      RootRepository rootRepository, DeviceRepository deviceRepository) {
    return MaterialPageRoute<void>(
        builder: (_) => SearchPage(
              rootRepository: rootRepository,
              deviceRepository: deviceRepository,
            ));
  }

  final RootRepository rootRepository;
  final DeviceRepository deviceRepository;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(
        rootRepository: widget.rootRepository,
        deviceRepository: widget.deviceRepository,
      ),
      child: const SearchForm(),
    );
  }
}
