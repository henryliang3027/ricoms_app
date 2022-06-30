import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/home/view/home_bottom_navigation_bar.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/bloc/root/root_bloc.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/root/view/device_edit_page.dart';
import 'package:ricoms_app/root/view/device_setting_page.dart';
import 'package:ricoms_app/root/view/group_edit_page.dart';
import 'package:ricoms_app/root/view/search_page.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/display_style.dart';

class RootForm extends StatelessWidget {
  const RootForm({Key? key, required this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
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
        } else if (state.formStatus.isRequestSuccess) {}
      },
      child: WillPopScope(
        onWillPop: () async {
          List<Node> _directory = context.read<RootBloc>().state.directory;
          if (_directory.length > 1) {
            context
                .read<RootBloc>()
                .add(ChildDataRequested(_directory[_directory.length - 2]));
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const _DynamicTitle(),
            actions: const [
              _SearchAction(),
              _SecondAction(),
            ],
          ),
          bottomNavigationBar: HomeBottomNavigationBar(
            pageController: pageController,
            selectedIndex: 1,
          ),
          drawer: HomeDrawer(
            user: context.read<AuthenticationBloc>().state.user,
            pageController: pageController,
          ),
          body: Container(
            color: Colors.grey.shade300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _NodeDirectory(),
                _NodeSliverList(),
              ],
            ),
          ),
          floatingActionButton: const _DynamicFloatingActionButton(),
        ),
      ),
    );
  }
}

class _DynamicTitle extends StatelessWidget {
  const _DynamicTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootBloc, RootState>(builder: (context, state) {
      const String defaultTitle = 'Network';

      if (state.directory.isNotEmpty) {
        Node node = state.directory.last;
        if (node.type == 5 || node.type == 2) {
          return Text(node.name);
        } else {
          return const Text(defaultTitle);
        }
      } else {
        return const Text(defaultTitle);
      }
    });
  }
}

class _SearchAction extends StatelessWidget {
  const _SearchAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootBloc, RootState>(builder: (context, state) {
      if (state.directory.isNotEmpty) {
        Node node = state.directory.last;

        return IconButton(
            onPressed: () async {
              List? path = await Navigator.push(
                  context,
                  SearchPage.route(
                    RepositoryProvider.of<RootRepository>(
                      context,
                    ),
                    RepositoryProvider.of<DeviceRepository>(
                      context,
                    ),
                  ));

              if (path != null) {
                context.read<RootBloc>().add(DeviceNavigateRequested(path));
              }
            },
            icon: const Icon(Icons.search));
      } else {
        return Center();
      }
    });
  }
}

class _SecondAction extends StatelessWidget {
  const _SecondAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootBloc, RootState>(builder: (context, state) {
      if (state.directory.isNotEmpty) {
        Node node = state.directory.last;
        if (node.type == 5 || node.type == 2) {
          return IconButton(onPressed: () {}, icon: Icon(Icons.star_rounded));
        } else {
          return IconButton(
              onPressed: () async {
                List<dynamic> result =
                    await RepositoryProvider.of<RootRepository>(
                  context,
                ).exportNodes();
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(result[1])),
                  );
              },
              icon: Icon(Icons.save_alt_outlined));
        }
      } else {
        return IconButton(
            onPressed: () async {
              List<dynamic> result =
                  await RepositoryProvider.of<RootRepository>(
                context,
              ).exportNodes();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(result[1])),
                );
            },
            icon: Icon(Icons.save_alt_outlined));
      }
    });
  }
}

class _DynamicFloatingActionButton extends StatelessWidget {
  const _DynamicFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootBloc, RootState>(builder: (context, state) {
      if (state.directory.isNotEmpty && state.directory.last.type == 1) {
        // 1 is group
        return FloatingActionButton(
            backgroundColor: Colors.blue.shade900,
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (_) => _NodeCreationBottomMenu(
                        superContext: context,
                        parentNode: state.directory.last,
                      ));
            },
            child: const Icon(CustomIcons.add));
      } else {
        return Center();
      }
    });
  }
}

class _NodeSliverList extends StatelessWidget {
  const _NodeSliverList({Key? key}) : super(key: key);

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
                  context.read<RootBloc>().add(DeviceDataRequested(node));
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
                    Expanded(
                      child: Row(children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: DisplayStyle.getDisplayName(node, context,
                                isLastItemOfDirectory: false),
                          ),
                        ),
                      ]),
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootBloc, RootState>(
      builder: (context, state) {
        if (state.directory.isNotEmpty) {
          if (state.directory.last.type == 2 ||
              state.directory.last.type == 5) {
            return Expanded(
              child: DeviceSettingPage(
                deviceRepository: RepositoryProvider.of<DeviceRepository>(
                  context,
                ),
                node: state.directory.last,
              ),
            );
          } else {
            return Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: _rootSliverChildBuilderDelegate(
                          state.directory.last, state.data))
                ],
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class _NodeDirectory extends StatelessWidget {
  const _NodeDirectory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return BlocBuilder<RootBloc, RootState>(
      buildWhen: (previous, current) => previous.directory != current.directory,
      builder: (context, state) {
        if (state.directory.isNotEmpty) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(seconds: 1),
                  curve: Curves.ease);
            }
          });

          return Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 10.0),
            child: Card(
              child: Row(
                children: [
                  //home button
                  IconButton(
                    onPressed: () {
                      context
                          .read<RootBloc>()
                          .add(ChildDataRequested(state.directory[0]));
                    },
                    icon: const Icon(Icons.home_outlined),
                    padding: EdgeInsets.zero,
                    visualDensity:
                        const VisualDensity(horizontal: -4.0, vertical: -4.0),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2.0, 2.0, 6.0, 2.0),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                      ChildDataRequested(state.directory[i]));
                                },
                                child: state.directory.length - 1 == i
                                    ? DisplayStyle.getDisplayName(
                                        state.directory[i], context,
                                        isLastItemOfDirectory: true)
                                    : DisplayStyle.getDisplayName(
                                        state.directory[i], context,
                                        isLastItemOfDirectory: false),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white70,
                                  elevation: 0,
                                  side: BorderSide(
                                    width: 1.0,
                                    color: i == state.directory.length - 1
                                        ? Colors.blue
                                        : Colors.black,
                                  ),
                                  visualDensity: const VisualDensity(
                                      horizontal: -4.0, vertical: -4.0),
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
          );
        } else {
          return const Center();
        }
      },
    );
  }
}

class _NodeEditBottomMenu extends StatelessWidget {
  const _NodeEditBottomMenu({
    Key? key,
    required this.superContext,
    required this.parentNode,
    required this.currentNode,
  }) : super(key: key);

  final BuildContext superContext;
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
                      rootRepository:
                          RepositoryProvider.of<RootRepository>(superContext),
                      parentNode: parentNode,
                      isEditing: true,
                      currentNode: currentNode));
            } else if (currentNode.type == 1) {
              //group
              Navigator.push(
                  context,
                  GroupEditPage.route(
                      rootRepository:
                          RepositoryProvider.of<RootRepository>(superContext),
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
    required this.superContext,
    required this.parentNode,
  }) : super(key: key);

  final BuildContext superContext;
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
                    rootRepository:
                        RepositoryProvider.of<RootRepository>(superContext),
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
                    rootRepository:
                        RepositoryProvider.of<RootRepository>(superContext),
                    parentNode: parentNode,
                    isEditing: false,
                    currentNode: null));
          },
        ),
      ],
    );
  }
}
