import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_file/internet_file.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdfx/pdfx.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/home/view/home_bottom_navigation_bar.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';
import 'package:ricoms_app/repository/root_repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/bloc/root/root_bloc.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:ricoms_app/root/view/device_edit_page.dart';
import 'package:ricoms_app/root/view/device_setting_tabbar.dart';
import 'package:ricoms_app/root/view/group_edit_page.dart';
import 'package:ricoms_app/root/view/search_page.dart';
import 'package:ricoms_app/utils/common_request.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/common_widget.dart';
import 'package:ricoms_app/utils/display_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/utils/message_localization.dart';

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
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitle_settingUp,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: const <Widget>[
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
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(
                color: CustomStyle.customGreen,
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
              AppLocalizations.of(context)!.dialogTitle_error,
              style: const TextStyle(
                color: CustomStyle.customRed,
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

    Future<void> _showDeviceHasBeenDeletedDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.notice,
              style: const TextStyle(
                color: CustomStyle.customRed,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!
                        .dialogMessage_leafNodehasBeenDeleted,
                  ),
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
        } else if (state.dataSheetOpenStatus.isRequestSuccess) {
          final pdfControllerPinch = PdfControllerPinch(
            document:
                PdfDocument.openData(InternetFile.get(state.dataSheetOpenPath)),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CustomPDFViewer(pdfControllerPinch: pdfControllerPinch)),
          );
        } else if (state.dataSheetOpenStatus.isRequestFailure) {
          Navigator.of(context).pop();
          _showFailureDialog(state.dataSheetOpenMsg);
        } else if (state.nodesExportStatus.isRequestSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  getMessageLocalization(
                    msg: state.nodesExportMsg,
                    context: context,
                  ),
                ),
                action: SnackBarAction(
                  label: AppLocalizations.of(context)!.open,
                  onPressed: () async {
                    OpenResult result = await OpenFilex.open(
                      state.nodesExportFilePath,
                      type: 'application/vnd.ms-excel',
                      uti: 'com.microsoft.excel.xls',
                    );
                    print(result.message);
                  },
                ),
              ),
            );
        } else if (state.isDeviceHasBeenDeleted) {
          _showDeviceHasBeenDeletedDialog();
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          List<Node> _directory = context.read<RootBloc>().state.directory;
          if (_directory.length > 1) {
            context.read<RootBloc>().add(ChildDataRequested(
                _directory[_directory.length - 2], RequestMode.initial));
            return false;
          } else {
            bool? isExit =
                await CommonWidget.showExitAppDialog(context: context);
            return isExit ?? false;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const _DynamicTitle(),
            leading: HomeDrawerToolTip.setToolTip(context),
            elevation: 0.0,
            actions: const [
              _PopupMenu(),
            ],
            bottom: const PreferredSize(
              child: _NodeDirectory(),
              preferredSize: Size.fromHeight(64.0),
            ),
          ),
          bottomNavigationBar: HomeBottomNavigationBar(
            pageController: pageController,
            selectedIndex: 1,
          ),
          drawer: HomeDrawer(
            user: context.read<AuthenticationBloc>().state.user,
            pageController: pageController,
            currentPageIndex: 1,
          ),
          body: Container(
            color: Colors.grey.shade300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                // _NodeDirectory(),
                _NodeContent(),
              ],
            ),
          ),
          floatingActionButton: const _DynamicFloatingActionButton(),
        ),
      ),
    );
  }
}

class CustomPDFViewer extends StatelessWidget {
  const CustomPDFViewer({
    Key? key,
    required this.pdfControllerPinch,
  }) : super(key: key);

  final PdfControllerPinch pdfControllerPinch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.datasheet,
          ),
        ),
        body: PdfViewPinch(
          controller: pdfControllerPinch,
        ));
  }
}

class _DynamicTitle extends StatelessWidget {
  const _DynamicTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootBloc, RootState>(builder: (context, state) {
      String defaultTitle = AppLocalizations.of(context)!.network;

      if (state.formStatus.isRequestSuccess) {
        Node node = state.directory.last;
        if (node.type == 5 || node.type == 2) {
          return Text(node.name);
        } else {
          return Text(defaultTitle);
        }
      } else {
        return Text(defaultTitle);
      }
    });
  }
}

enum Menu {
  search,
  export,
  favorite,
  datasheet,
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PopupMenuItem<Menu> _getSearchMenuItem() {
      return PopupMenuItem<Menu>(
        value: Menu.search,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.search,
              size: 20.0,
              color: Colors.black,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              AppLocalizations.of(context)!.search,
            ),
          ],
        ),
      );
    }

    PopupMenuItem<Menu> _getfavoriteMenuItem(
      bool isAddedToBookmarks,
    ) {
      return PopupMenuItem<Menu>(
        value: Menu.favorite,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isAddedToBookmarks
                ? const Icon(
                    Icons.star_outlined,
                    size: 20.0,
                    color: Colors.amber,
                  )
                : const Icon(
                    Icons.star_border_outlined,
                    size: 20.0,
                    color: Colors.black,
                  ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              AppLocalizations.of(context)!.favorite,
            ),
          ],
        ),
      );
    }

    PopupMenuItem<Menu> _getDatasheetMenuItem() {
      return PopupMenuItem<Menu>(
        value: Menu.datasheet,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.assignment_outlined,
              size: 20.0,
              color: Colors.black,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              AppLocalizations.of(context)!.datasheet,
            ),
          ],
        ),
      );
    }

    PopupMenuItem<Menu> _getExportMenuItem() {
      return PopupMenuItem<Menu>(
        value: Menu.export,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              CustomIcons.export,
              size: 20.0,
              color: Colors.black,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              AppLocalizations.of(context)!.export,
            ),
          ],
        ),
      );
    }

    return BlocBuilder<RootBloc, RootState>(builder: (context, state) {
      List<PopupMenuEntry<Menu>> _buildPopupMenu() {
        if (state.directory.last.type == 5 || state.directory.last.type == 2) {
          if (state.directory.last.status != 0) {
            // unknown
            return [
              _getSearchMenuItem(),
              _getfavoriteMenuItem(
                state.isAddedToBookmarks,
              ),
              _getDatasheetMenuItem(),
            ];
          } else {
            return [
              _getSearchMenuItem(),
            ];
          }
        } else {
          return [
            _getSearchMenuItem(),
            _getExportMenuItem(),
          ];
        }
      }

      if (state.formStatus.isRequestSuccess) {
        return PopupMenuButton<Menu>(
          tooltip: '',
          onSelected: (Menu item) async {
            switch (item) {
              case Menu.search:
                List? path = await Navigator.push(
                    context,
                    SearchPage.route(
                      context.read<AuthenticationBloc>().state.user,
                      RepositoryProvider.of<RootRepository>(
                        context,
                      ),
                    ));

                if (path != null) {
                  context.read<RootBloc>().add(DeviceNavigateRequested(path));
                }
                break;
              case Menu.export:
                context.read<RootBloc>().add(const NodesExported());
                break;
              case Menu.favorite:
                context
                    .read<RootBloc>()
                    .add(BookmarksChanged(state.directory.last));
                break;
              case Menu.datasheet:
                context
                    .read<RootBloc>()
                    .add(DataSheetOpened(state.directory.last));
                break;
              default:
                break;
            }
          },
          itemBuilder: (BuildContext context) => _buildPopupMenu(),
        );
      } else {
        return Container();
      }
    });
  }
}

class _DynamicFloatingActionButton extends StatelessWidget {
  const _DynamicFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map _userFunctionMap =
        context.read<AuthenticationBloc>().state.userFunctionMap;

    return BlocBuilder<RootBloc, RootState>(builder: (context, state) {
      if (state.formStatus.isRequestSuccess) {
        if (state.directory.last.type == 1) {
          // 1 is group
          return _userFunctionMap[8]
              ? FloatingActionButton(
                  elevation: 0.0,
                  backgroundColor: const Color(0x742195F3),
                  onPressed: () {
                    // because RootBloc cannot be found inside ModalBottomSheet
                    // provide the context that contain RootBloc for it
                    showModalBottomSheet(
                        context: context,
                        builder: (_) => _NodeCreationBottomMenu(
                              parentContext: context,
                              parentNode: state.directory.last,
                            ));
                  },
                  child: const Icon(
                    CustomIcons.add,
                  ),
                )
              : const Center();
        } else {
          return const Center();
        }
      } else {
        return const Center();
      }
    });
  }
}

class _NodeContent extends StatelessWidget {
  const _NodeContent({Key? key}) : super(key: key);

  SliverChildBuilderDelegate _rootSliverChildBuilderDelegate(
    Node parentNode,
    List childData,
    bool enabledEdit,
    bool enabledDelete,
  ) {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        // if (kDebugMode) {
        //   print('build _rootSliverChildBuilderDelegate : $index');
        // }
        Node node = childData[index];
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Material(
            child: InkWell(
              onTap: () {
                // Root: 0,
                // Group: 1,
                // Device: 2, (edfa)
                // A8K: 3,
                // Shelf: 4,
                // Slot: 5,
                context
                    .read<RootBloc>()
                    .add(ChildDataRequested(node, RequestMode.initial));
              },
              onLongPress: () {
                if (node.type == 1 || node.type == 2 || node.type == 3) {
                  if (enabledEdit || enabledDelete) {
                    // because RootBloc cannot be found inside ModalBottomSheet
                    // provide the context that contain RootBloc for it
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => _NodeEditBottomMenu(
                        parentContext:
                            context, //pass this context contain RootBloc so that BottomMenu can use it
                        parentNode: parentNode,
                        currentNode: node,
                        enabledEdit: enabledEdit,
                        enabledDelete: enabledDelete,
                      ),
                    );
                  }
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
                          color: CustomStyle.nodeStatusColor[node.status],
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
                            child: DisplayStyle.getNodeDisplayName(
                                node, context,
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
      childCount: childData.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    Map _userFunctionMap =
        context.read<AuthenticationBloc>().state.userFunctionMap;

    return BlocBuilder<RootBloc, RootState>(builder: (context, state) {
      if (state.formStatus.isRequestSuccess) {
        if (state.directory.last.type == 2 || state.directory.last.type == 5) {
          // 2: edfa, 5: a8k slot

          if (state.directory.last.status == 0) {
            return Expanded(
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      size: 200,
                      color: Color(0xffffc107),
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .dialogMessage_DeviceDoesNotRespond,
                    ),
                    const SizedBox(height: 40.0),
                  ],
                ),
              ),
            );
          }

          descriptionChangeNotifier() =>
              context.read<RootBloc>().add(const DeviceTypeNodeUpdated());

          return Expanded(
            child: DeviceSettingTabBar(
              descriptionChangedNotifier: descriptionChangeNotifier,
              node: state.directory.last,
            ),
          );
        } else {
          if (state.directory.last.type == 1) {
            //group
            if (state.childData.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.noData,
                  ),
                ),
              );
            }

            return Expanded(
                child: Scrollbar(
              thickness: 8.0,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: _rootSliverChildBuilderDelegate(
                    state.directory.last,
                    state.childData,
                    _userFunctionMap[9],
                    _userFunctionMap[10],
                  ))
                ],
              ),
            ));
          } else if (state.directory.last.type == 3) {
            //a8k
            if (state.directory.last.status == 0) {
              return Expanded(
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.warning_rounded,
                        size: 200,
                        color: Color(0xffffc107),
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .dialogMessage_DeviceDoesNotRespond,
                      ),
                      const SizedBox(height: 40.0),
                    ],
                  ),
                ),
              );
            }

            return Expanded(
                child: Scrollbar(
              thickness: 8.0,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: _rootSliverChildBuilderDelegate(
                    state.directory.last,
                    state.childData,
                    _userFunctionMap[9],
                    _userFunctionMap[10],
                  ))
                ],
              ),
            ));
          } else if (state.directory.last.type == 4) {
            // a8k shelf
            if (state.directory.last.status == 0) {
              return Expanded(
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.warning_rounded,
                        size: 200,
                        color: Color(0xffffc107),
                      ),
                      Text('The device does not respond.'),
                      SizedBox(height: 40.0),
                    ],
                  ),
                ),
              );
            }

            return Expanded(
                child: Scrollbar(
              thickness: 8.0,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: _rootSliverChildBuilderDelegate(
                    state.directory.last,
                    state.childData,
                    _userFunctionMap[9],
                    _userFunctionMap[10],
                  ))
                ],
              ),
            ));
          } else {
            return const Expanded(
              child: Center(
                child: Text('Undefined device type.'),
              ),
            );
          }
        }
      } else if (state.formStatus.isRequestFailure) {
        return Expanded(
          child: Container(
            width: double.maxFinite,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_rounded,
                  size: 200,
                  color: Color(0xffffc107),
                ),
                Text(
                  getMessageLocalization(
                    msg: state.errmsg,
                    context: context,
                  ),
                ),
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        );
      } else {
        return const Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}

// class _NodeSliverList extends StatelessWidget {
//   const _NodeSliverList({Key? key}) : super(key: key);

//   _rootSliverChildBuilderDelegate(
//     Node parentNode,
//     List data,
//     bool enabledEdit,
//     bool enabledDelete,
//   ) {
//     return SliverChildBuilderDelegate(
//       (BuildContext context, int index) {
//         if (kDebugMode) {
//           print('build _rootSliverChildBuilderDelegate : $index');
//         }
//         Node node = data[index];
//         return Padding(
//           padding: const EdgeInsets.all(1.0),
//           child: Material(
//             child: InkWell(
//               onTap: () {
//                 if (node.type == 2 || node.type == 5) {
//                   // 2 : EDFA, 5 : A8K slot
//                   context.read<RootBloc>().add(DeviceDataRequested(node));
//                 } else {
//                   context
//                       .read<RootBloc>()
//                       .add(ChildDataRequested(node, RequestMode.initial));
//                 }
//               },
//               onLongPress: () {
//                 if (node.type == 1 || node.type == 2 || node.type == 3) {
//                   if (enabledEdit || enabledDelete) {
//                     // because RootBloc cannot be found inside ModalBottomSheet
//                     // provide the context that contain RootBloc for it
//                     showModalBottomSheet(
//                       context: context,
//                       builder: (_) => _NodeEditBottomMenu(
//                         parentContext:
//                             context, //pass this context contain RootBloc so that BottomMenu can use it
//                         parentNode: parentNode,
//                         currentNode: node,
//                         enabledEdit: enabledEdit,
//                         enabledDelete: enabledDelete,
//                       ),
//                     );
//                   }
//                 }
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: CommonStyle.severityRectangleWidth,
//                           height: CommonStyle.severityRectangleHeight,
//                           color: CustomStyle.severityColor[node.status],
//                         ),
//                       ],
//                     ),
//                     CustomStyle.typeIcon[node.type] != null
//                         ? Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: CustomStyle.typeIcon[node.type],
//                           )
//                         : const Padding(
//                             padding: EdgeInsets.zero,
//                           ),
//                     Expanded(
//                       child: Row(children: [
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: DisplayStyle.getNodeDisplayName(
//                                 node, context,
//                                 isLastItemOfDirectory: false),
//                           ),
//                         ),
//                       ]),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//       childCount: data.length,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Map _userFunctionMap =
//         context.read<AuthenticationBloc>().state.userFunctionMap;
//     return BlocBuilder<RootBloc, RootState>(
//       buildWhen: (previous, current) => previous.data != current.data,
//       builder: (context, state) {
//         if (state.formStatus.isRequestSuccess) {
//           if (state.directory.last.type == 1) {
//             //group
//             if (state.data.isEmpty) {
//               return Expanded(
//                 child: Center(
//                   child: Text(
//                     AppLocalizations.of(context)!.noData,
//                   ),
//                 ),
//               );
//             }

//             return Expanded(
//                 child: Scrollbar(
//               thickness: 8.0,
//               child: CustomScrollView(
//                 slivers: [
//                   SliverList(
//                       delegate: _rootSliverChildBuilderDelegate(
//                     state.directory.last,
//                     state.data,
//                     _userFunctionMap[9],
//                     _userFunctionMap[10],
//                   ))
//                 ],
//               ),
//             ));
//           } else if (state.directory.last.type == 3) {
//             //a8k
//             if (state.directory.last.status == 0) {
//               return Expanded(
//                 child: Container(
//                   width: double.maxFinite,
//                   height: double.maxFinite,
//                   color: Colors.white,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.warning_rounded,
//                         size: 200,
//                         color: Color(0xffffc107),
//                       ),
//                       Text(
//                         AppLocalizations.of(context)!
//                             .dialogMessage_DeviceDoesNotRespond,
//                       ),
//                       const SizedBox(height: 40.0),
//                     ],
//                   ),
//                 ),
//               );
//             }

//             return Expanded(
//                 child: Scrollbar(
//               thickness: 8.0,
//               child: CustomScrollView(
//                 slivers: [
//                   SliverList(
//                       delegate: _rootSliverChildBuilderDelegate(
//                     state.directory.last,
//                     state.data,
//                     _userFunctionMap[9],
//                     _userFunctionMap[10],
//                   ))
//                 ],
//               ),
//             ));
//           } else if (state.directory.last.type == 4) {
//             // a8k shelf
//             if (state.directory.last.status == 0) {
//               return Expanded(
//                 child: Container(
//                   width: double.maxFinite,
//                   height: double.maxFinite,
//                   color: Colors.white,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Icon(
//                         Icons.warning_rounded,
//                         size: 200,
//                         color: Color(0xffffc107),
//                       ),
//                       Text('The device does not respond.'),
//                       SizedBox(height: 40.0),
//                     ],
//                   ),
//                 ),
//               );
//             }

//             return Expanded(
//                 child: Scrollbar(
//               thickness: 8.0,
//               child: CustomScrollView(
//                 slivers: [
//                   SliverList(
//                       delegate: _rootSliverChildBuilderDelegate(
//                     state.directory.last,
//                     state.data,
//                     _userFunctionMap[9],
//                     _userFunctionMap[10],
//                   ))
//                 ],
//               ),
//             ));
//           } else {
//             return const Expanded(
//               child: Center(
//                 child: Text('Undefined device type.'),
//               ),
//             );
//           }
//         } else if (state.formStatus.isRequestFailure) {
//           return Expanded(
//             child: Center(
//               child: Text(
//                 getMessageLocalization(
//                   msg: state.errmsg,
//                   context: context,
//                 ),
//               ),
//             ),
//           );
//         } else {
//           // wait for data
//           return const Expanded(
//             child: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//       },
//     );
//   }
// }

class _NodeDirectory extends StatelessWidget {
  const _NodeDirectory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return BlocBuilder<RootBloc, RootState>(
      buildWhen: (previous, current) => previous.directory != current.directory,
      builder: (context, state) {
        if (state.formStatus.isRequestSuccess) {
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
              elevation: 0.0,
              child: Row(
                children: [
                  //home button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6.0, 2.0, 2.0, 2.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<RootBloc>().add(ChildDataRequested(
                            state.directory[0], RequestMode.initial));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.home_outlined,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 2.0),
                          Text(
                            AppLocalizations.of(context)!.root,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(6.0, 0.0, 8.0, 0.0),
                        backgroundColor: Colors.white70,
                        elevation: 0,
                        side: const BorderSide(
                          width: 1.0,
                          color: Colors.black,
                        ),
                        visualDensity: const VisualDensity(
                          horizontal: -4.0,
                          vertical: -4.0,
                        ),
                      ),
                    ),
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
                                      ChildDataRequested(state.directory[i],
                                          RequestMode.initial));
                                },
                                child: state.directory.length - 1 == i
                                    ? DisplayStyle.getNodeDisplayName(
                                        state.directory[i], context,
                                        isLastItemOfDirectory: true)
                                    : DisplayStyle.getNodeDisplayName(
                                        state.directory[i], context,
                                        isLastItemOfDirectory: false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white70,
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
          // if state.formStatus.isRequestFailure or isRequestInProgress
          return const Center();
        }
      },
    );
  }
}

class _NodeEditBottomMenu extends StatelessWidget {
  const _NodeEditBottomMenu({
    Key? key,
    required this.parentContext,
    required this.parentNode,
    required this.currentNode,
    required this.enabledEdit,
    required this.enabledDelete,
  }) : super(key: key);

  final BuildContext parentContext;
  final Node parentNode;
  final Node currentNode;
  final bool enabledEdit;
  final bool enabledDelete;

  @override
  Widget build(BuildContext context) {
    Future<bool?> _showConfirmDeleteDialog(Node currentNode) async {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: currentNode.type == 1
                ? Text(AppLocalizations.of(context)!.dialogTitle_deletedGroup)
                : Text(AppLocalizations.of(context)!.dialogTitle_deletedDevice),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .dialogMessage_AskBeforeDelete,
                          style: const TextStyle(
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
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.confirmDeleted,
                  style: const TextStyle(
                    color: CustomStyle.customRed,
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

    Widget _buildEditListTile() {
      return ListTile(
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
        title: Text(
          AppLocalizations.of(context)!.edit,
          style: const TextStyle(fontSize: CommonStyle.sizeM),
        ),
        onTap: () {
          Navigator.pop(context);
          if (currentNode.type == 2 || currentNode.type == 3) {
            //device or a8k
            Navigator.push(
                context,
                DeviceEditPage.route(
                    user: context.read<AuthenticationBloc>().state.user,
                    parentNode: parentNode,
                    isEditing: true,
                    currentNode: currentNode));
          } else if (currentNode.type == 1) {
            //group
            Navigator.push(
                context,
                GroupEditPage.route(
                    user: context.read<AuthenticationBloc>().state.user,
                    parentNode: parentNode,
                    isEditing: true,
                    currentNode: currentNode));
          }
        },
      );
    }

    Widget _buildDeleteListTile() {
      return ListTile(
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
        title: Text(
          AppLocalizations.of(context)!.delete,
          style: const TextStyle(fontSize: CommonStyle.sizeM),
        ),
        onTap: () async {
          Navigator.pop(context);

          bool? result = await _showConfirmDeleteDialog(currentNode);
          if (result != null) {
            result
                ? parentContext.read<RootBloc>().add(NodeDeleted(currentNode))
                : null;
          }
        },
      );
    }

    return Wrap(
      children: [
        enabledEdit ? _buildEditListTile() : Container(),
        enabledDelete ? _buildDeleteListTile() : Container(),
      ],
    );
  }
}

class _NodeCreationBottomMenu extends StatelessWidget {
  const _NodeCreationBottomMenu({
    Key? key,
    required this.parentContext,
    required this.parentNode,
  }) : super(key: key);

  final BuildContext parentContext;
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
          title: Text(
            AppLocalizations.of(context)!.group,
            style: const TextStyle(fontSize: CommonStyle.sizeM),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                GroupEditPage.route(
                    user: context.read<AuthenticationBloc>().state.user,
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
          title: Text(
            AppLocalizations.of(context)!.device,
            style: const TextStyle(fontSize: CommonStyle.sizeM),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                DeviceEditPage.route(
                    user: context.read<AuthenticationBloc>().state.user,
                    parentNode: parentNode,
                    isEditing: false,
                    currentNode: null));
          },
        ),
      ],
    );
  }
}
