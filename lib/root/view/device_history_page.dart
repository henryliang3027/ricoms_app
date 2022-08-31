import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/device_history/device_history_bloc.dart';
import 'package:ricoms_app/root/view/device_history_form.dart';

class DeviceHistoryPage extends StatelessWidget {
  const DeviceHistoryPage({
    Key? key,
    required this.user,
    required this.deviceRepository,
    required this.nodeId,
  }) : super(key: key);

  final User user;
  final DeviceRepository deviceRepository;
  final int nodeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviceHistoryBloc(
        user: user,
        deviceRepository: deviceRepository,
        nodeId: nodeId,
      ),
      child: const DeviceHistoryForm(),
    );
  }
}
