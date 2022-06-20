import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/bloc/root/root_bloc.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/root/view/device_edit_page.dart';
import 'package:ricoms_app/root/view/device_setting_page.dart';
import 'package:ricoms_app/root/view/group_edit_page.dart';
import 'package:ricoms_app/utils/common_style.dart';

class RootForm extends StatefulWidget {
  const RootForm({Key? key}) : super(key: key);

  @override
  State<RootForm> createState() => _RootFormState();
}

class _RootFormState extends State<RootForm> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DeviceRepository deviceRepository = RepositoryProvider.of<DeviceRepository>(
      context,
    );

    RootRepository rootRepository = RepositoryProvider.of<RootRepository>(
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

    Future<void> _showSuccessDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Deleted',
              style: TextStyle(
                color: CustomStyle.severityColor[1],
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(msg),
                ],
              ),
            ),
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

    Future<void> _showFailureDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(
                color: CustomStyle.severityColor[3],
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(msg),
                ],
              ),
            ),
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
                  node.slot.toString().padLeft(2, '0'),
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
          //PCML2 (L)
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
        //shelf
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

    void _autoScrollToTheEnd() {
      Future.delayed(
          const Duration(milliseconds: 500),
          () => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(seconds: 1),
              curve: Curves.ease));
    }

    _rootSliverChildBuilderDelegate(Node parentNode, List data) {
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
                        DeviceSettingPage.route(deviceRepository, node));
                  } else {
                    context.read<RootBloc>().add(ChildDataRequested(node));
                  }
                },
                onLongPress: () {
                  if (node.type == 1 || node.type == 2 || node.type == 3) {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => _NodeEditBottomMenu(
                          superContext:
                              context, //pass this context contain RootBloc so that BottomMenu can use it to call NodeDeleted event
                          rootRepository: rootRepository,
                          parentNode: parentNode,
                          currentNode: node),
                    );
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
        } else if (state.submissionStatus.isSubmissionSuccess) {
          Navigator.of(context).pop();
          _showSuccessDialog(state.deleteResultMsg);
        } else if (state.submissionStatus.isSubmissionFailure) {
          Navigator.of(context).pop();
          _showFailureDialog(state.deleteResultMsg);
        } else if (state.formStatus.isRequestSuccess) {
          _autoScrollToTheEnd();
        }
      },
      child: BlocBuilder<RootBloc, RootState>(
        builder: (BuildContext context, state) {
          if (state.formStatus.isRequestInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.formStatus.isRequestSuccess ||
              state.formStatus.isUpdatSuccess) {
            return Scaffold(
              body: Container(
                color: Colors.grey.shade300,
                child: Column(
                  children: [
                    Padding(
                      //directory
                      padding: EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 10.0),
                      child: Card(
                        child: Row(
                          children: [
                            //home button
                            IconButton(
                              onPressed: () {
                                context.read<RootBloc>().add(
                                    ChildDataRequested(state.directory[0]));
                              },
                              icon: Icon(Icons.home_outlined),
                              padding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                  horizontal: -4.0, vertical: -4.0),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(2.0, 2.0, 6.0, 2.0),
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      for (int i = 1;
                                          i < state.directory.length;
                                          i++) ...[
                                        const Icon(
                                          Icons.keyboard_arrow_right_outlined,
                                          size: 20.0,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            context.read<RootBloc>().add(
                                                ChildDataRequested(
                                                    state.directory[i]));
                                          },
                                          child: Text(
                                            state.directory[i].name,
                                            style: TextStyle(
                                              color: i ==
                                                      state.directory.length - 1
                                                  ? Colors.blue
                                                  : Colors.black,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white70,
                                            elevation: 0,
                                            side: BorderSide(
                                              width: 1.0,
                                              color: i ==
                                                      state.directory.length - 1
                                                  ? Colors.blue
                                                  : Colors.black,
                                            ),
                                            visualDensity: const VisualDensity(
                                                horizontal: -4.0,
                                                vertical: -4.0),
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverList(
                              delegate: _rootSliverChildBuilderDelegate(
                                  state.directory.last, state.data))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: state.directory.last.type == 1
                  ? FloatingActionButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => _NodeCreationBottomMenu(
                                  rootRepository: rootRepository,
                                  parentNode: state.directory.last,
                                ));
                      },
                      child: const Icon(CustomIcons.add))
                  : null,
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

class _NodeEditBottomMenu extends StatelessWidget {
  const _NodeEditBottomMenu({
    Key? key,
    required this.superContext,
    required this.rootRepository,
    required this.parentNode,
    required this.currentNode,
  }) : super(key: key);

  final BuildContext superContext;
  final RootRepository rootRepository;
  final Node parentNode;
  final Node currentNode;

  @override
  Widget build(BuildContext context) {
    Future<bool?> _showConfirmDeleteDialog(Node currentNode) async {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: currentNode.type == 1
                ? const Text('Delete Group')
                : const Text('Delete Device'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  // Text(
                  //   'Are you sure you want to delete $nodeName ?',
                  //   style: TextStyle(fontSize: CommonStyle.sizeL),
                  // ),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Are you sure you want to delete ',
                          style: TextStyle(
                            fontSize: CommonStyle.sizeXL,
                          ),
                        ),
                        TextSpan(
                          text: currentNode.name,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: CommonStyle.sizeXL,
                          ),
                        ),
                        const TextSpan(
                          text: ' ?',
                          style: TextStyle(
                            fontSize: CommonStyle.sizeXL,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
              TextButton(
                child: Text(
                  'Yes, delete it!',
                  style: TextStyle(
                    color: CustomStyle.severityColor[3],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    return Wrap(
      children: [
        ListTile(
          dense: true,
          leading: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300, shape: BoxShape.circle),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: Icon(
                  Icons.edit,
                ),
              ),
            ),
          ),
          title: const Text(
            'Edit',
            style: TextStyle(fontSize: CommonStyle.sizeM),
          ),
          onTap: () {
            Navigator.pop(context);
            if (currentNode.type == 2 || currentNode.type == 3) {
              //device or a8k
              Navigator.push(
                  context,
                  DeviceEditPage.route(
                      rootRepository: rootRepository,
                      parentNode: parentNode,
                      isEditing: true,
                      currentNode: currentNode));
            } else if (currentNode.type == 1) {
              //group
              Navigator.push(
                  context,
                  GroupEditPage.route(
                      rootRepository: rootRepository,
                      parentNode: parentNode,
                      isEditing: true,
                      currentNode: currentNode));
            }
          },
        ),
        ListTile(
          dense: true,
          leading: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300, shape: BoxShape.circle),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: Icon(
                  Icons.delete,
                  size: 20.0,
                ),
              ),
            ),
          ),
          title: const Text(
            'Delete',
            style: TextStyle(fontSize: CommonStyle.sizeM),
          ),
          onTap: () async {
            Navigator.pop(context);

            bool? result = await _showConfirmDeleteDialog(currentNode);
            print(result);
            if (result != null) {
              result
                  ? superContext.read<RootBloc>().add(NodeDeleted(currentNode))
                  : null;
            }
          },
        ),
      ],
    );
  }
}

class _NodeCreationBottomMenu extends StatelessWidget {
  const _NodeCreationBottomMenu({
    Key? key,
    required this.rootRepository,
    required this.parentNode,
  }) : super(key: key);

  final RootRepository rootRepository;
  final Node parentNode;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          dense: true,
          leading: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300, shape: BoxShape.circle),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: Icon(
                  CustomIcons.root,
                ),
              ),
            ),
          ),
          title: const Text(
            'Group',
            style: TextStyle(fontSize: CommonStyle.sizeM),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                GroupEditPage.route(
                    rootRepository: rootRepository,
                    parentNode: parentNode,
                    isEditing: false,
                    currentNode: null));
          },
        ),
        ListTile(
          dense: true,
          leading: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300, shape: BoxShape.circle),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: Icon(
                  CustomIcons.device,
                  size: 20.0,
                ),
              ),
            ),
          ),
          title: const Text(
            'Device',
            style: TextStyle(fontSize: CommonStyle.sizeM),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                DeviceEditPage.route(
                    rootRepository: rootRepository,
                    parentNode: parentNode,
                    isEditing: false,
                    currentNode: null));
          },
        ),
      ],
    );
  }
}
