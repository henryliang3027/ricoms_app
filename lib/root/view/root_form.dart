import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/bloc/root/root_bloc.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/root/view/device_setting_page.dart';
import 'package:ricoms_app/utils/common_style.dart';

class RootForm extends StatelessWidget {
  const RootForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    DeviceRepository deviceRepository = RepositoryProvider.of<DeviceRepository>(
      context,
    );

    Future<void> _showInProgressDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Setting up...'),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              CircularProgressIndicator(),
            ],
          );
        },
      );
    }

    Future<void> _showCompleteDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(msg),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    Widget _getDisplayName(Node node) {
      if (node.type == 5) {
        //slot
        if (node.shelf != 0 && node.slot == 0) {
          //a8k FAN slot
          return Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "FAN",
                  style: TextStyle(
                    fontSize: CommonStyle.sizeL,
                    color: Colors.blue,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  node.name,
                  style: const TextStyle(
                    fontSize: CommonStyle.sizeL,
                  ),
                ),
              ),
            ],
          );
        } else if (node.shelf != 0) {
          // a8k normal slot
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  node.slot.toString(),
                  style: const TextStyle(
                    fontSize: CommonStyle.sizeL,
                    color: Colors.blue,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  node.name,
                  style: const TextStyle(
                    fontSize: CommonStyle.sizeL,
                  ),
                ),
              ),
            ],
          );
        } else if (node.shelf == 0 && node.slot == 0) {
          return const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "PCM2 (L)",
              style: TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
            ),
          ); // display of PCML2 (L)
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              node.name,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
            ),
          );
        }
      } else if (node.type == 4) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Shelf ' + node.shelf.toString(),
            style: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            node.name,
            style: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
          ),
        );
      }
    }

    _rootSliverChildBuilderDelegate(List data) {
      return SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          print('build _rootSliverChildBuilderDelegate : ${index}');
          Node node = data[index];
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: Material(
              child: InkWell(
                onTap: () {
                  if (node.type == 2 || node.type == 5) {
                    // 2 : EDFA, 5 : A8K slot
                    deviceRepository.deviceNodeId = node.id.toString();
                    Navigator.push(context,
                        DeviceSettingPage.route(deviceRepository, node.name));
                  } else {
                    context.read<RootBloc>().add(ChildDataRequested(node));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: CommonStyle.severityRectangleWidth,
                            height: CommonStyle.severityRectangleHeight,
                            color: CustomStyle.severityColor[node.status],
                          ),
                        ],
                      ),
                      CustomStyle.typeIcon[node.type] != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomStyle.typeIcon[node.type],
                            )
                          : const Padding(
                              padding: EdgeInsets.zero,
                            ),
                      Flexible(
                        child: _getDisplayName(node),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        childCount: data.length,
      );
    }

    return BlocListener<RootBloc, RootState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress) {
          await _showInProgressDialog();
        } else if (state.submissionStatus.isSubmissionFailure ||
            state.submissionStatus.isSubmissionSuccess) {
          Navigator.of(context).pop();
          _showCompleteDialog(state.saveResultMsg);
        }
      },
      child: BlocBuilder<RootBloc, RootState>(
        builder: (BuildContext context, state) {
          if (state.formStatus.isRequestInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.formStatus.isRequestSuccess ||
              state.formStatus.isUpdating) {
            return Container(
              color: Colors.grey.shade300,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    for (Node node in state.directory)
                                      if (node.id == 0) ...[
                                        IconButton(
                                            onPressed: () {
                                              context.read<RootBloc>().add(
                                                  ChildDataRequested(node));
                                            },
                                            icon: Icon(Icons.home_outlined)),
                                      ] else ...[
                                        ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<RootBloc>()
                                                .add(ChildDataRequested(node));
                                          },
                                          child: Text(' > ${node.name}'),
                                        ),
                                      ]
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // TextField(
                  //   controller: _controller,
                  //   textAlign: TextAlign.center,
                  //   keyboardType: TextInputType.number,
                  // ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       print('textfield text : ${_controller.text}');
                  //       deviceRepository.deviceNodeId = _controller.text;
                  //       Navigator.push(
                  //           context, DeviceSettingPage.route(deviceRepository));
                  //     },
                  //     child: Text('test A8K')),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                            delegate:
                                _rootSliverChildBuilderDelegate(state.data))
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            //FormStatus.requestFailure
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
