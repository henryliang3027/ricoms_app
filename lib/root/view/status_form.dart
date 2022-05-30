import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/status/status_bloc.dart';
import 'package:ricoms_app/root/view/custom_style.dart';

class StatusForm extends StatefulWidget {
  const StatusForm({Key? key, required this.rootRepository}) : super(key: key);

  final RootRepository rootRepository;

  @override
  State<StatusForm> createState() => _StatusFormState();
}

class _StatusFormState extends State<StatusForm> {
  @override
  Widget build(BuildContext context) {
    print('build Status');
    return BlocProvider(
      create: (context) => StatusBloc(rootRepository: widget.rootRepository)
        ..add(StatusDataRequested()),
      child: BlocBuilder<StatusBloc, StatusState>(
        builder: (BuildContext context, state) {
          if (state.status.isSubmissionInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status.isSubmissionSuccess) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var item in state.data) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var e in item) ...[
                          CustomStyle.getBox(e['style'], e),
                        ]
                      ],
                    )
                  ],
                ],
              ),
            );
          } else {
            String errnsg = state.data[0];
            return Center(
              child: Text(errnsg),
            );
          }
        },
      ),
    );
  }
}
