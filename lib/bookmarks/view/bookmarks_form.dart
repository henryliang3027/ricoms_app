import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/bookmarks/bloc/bookmarks_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/home/view/home_bottom_navigation_bar.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';
import 'package:ricoms_app/repository/bookmarks_repository/bookmarks_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/common_widget.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class BookmarksForm extends StatelessWidget {
  const BookmarksForm({
    Key? key,
    required this.pageController,
    required this.initialPath,
  }) : super(key: key);

  final PageController pageController;
  final List initialPath;

  @override
  Widget build(BuildContext context) {
    Future<void> _showFailureDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              CustomErrTitle.commonErrTitle,
              style: TextStyle(
                color: CustomStyle.customRed,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    getMessageLocalization(
                      msg: msg,
                      context: context,
                    ),
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

    return BlocListener<BookmarksBloc, BookmarksState>(
      listener: (context, state) async {
        if (state.targetDeviceStatus.isRequestFailure) {
          _showFailureDialog(state.targetDeviceMsg);
        } else if (state.deviceDeleteStatus.isRequestFailure) {
          _showFailureDialog(state.deleteResultMsg);
        } else if (state.loadMoreDeviceStatus.isRequestFailure) {
          _showFailureDialog(state.requestErrorMsg);
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          bool? isExit = await CommonWidget.showExitAppDialog(context: context);
          return isExit ?? false;
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(AppLocalizations.of(context)!.bookmarks),
            leading: HomeDrawerToolTip.setToolTip(context),
            elevation: 0.0,
            actions: const [
              _PopupMenu(),
            ],
          ),
          bottomNavigationBar: HomeBottomNavigationBar(
            pageController: pageController,
            selectedIndex: 4,
          ),
          drawer: HomeDrawer(
            user: context.read<AuthenticationBloc>().state.user,
            pageController: pageController,
            currentPageIndex: 4,
          ),
          body: _DeviceSliverList(
            pageController: pageController,
            initialPath: initialPath,
          ),
          floatingActionButton: const _BookmarksFloatingActionButton(),
        ),
      ),
    );
  }
}

enum Menu {
  deleteAll,
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarksBloc, BookmarksState>(
        builder: (context, state) {
      if (state.isDeleteMode) {
        return Container();
      } else {
        return PopupMenuButton<Menu>(
          icon: const Icon(
            Icons.more_vert_outlined,
            color: Colors.white,
          ),
          tooltip: '',
          onSelected: (Menu item) async {
            switch (item) {
              case Menu.deleteAll:
                context
                    .read<BookmarksBloc>()
                    .add(const BookmarksDeletedModeEnabled());
                break;
              default:
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
            PopupMenuItem<Menu>(
              value: Menu.deleteAll,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.delete_outline,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(AppLocalizations.of(context)!.deleteAll),
                ],
              ),
            ),
          ],
        );
      }
    });
  }
}

class _DeviceSliverList extends StatelessWidget {
  _DeviceSliverList({
    Key? key,
    required this.pageController,
    required this.initialPath,
  }) : super(key: key);

  final List initialPath;
  final PageController pageController;
  final ScrollController _scrollController = ScrollController();

  String _getDisplayName(Device device) {
    if (device.type == 5) {
      //a8k slot
      if (device.shelf == 0 && device.slot == 1) {
        return '${device.name} [ PCM2 (L) ]';
      } else if (device.shelf != 0 && device.slot == 0) {
        return '${device.name} [ Shelf ${device.shelf} / FAN ]';
      } else {
        return '${device.name} [ Shelf ${device.shelf} / Slot ${device.slot} ]';
      }
    } else {
      return device.name;
    }
  }

  SliverChildBuilderDelegate _deviceSliverChildBuilderDelegate({
    required List data,
    required List initialPath,
    required bool isDeleteMode,
    required List<Device> selectedDevices,
    required bool hasReachMax,
  }) {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        if (index >= data.length) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        Device device = data[index];
        return device.status != -99
            ? Padding(
                padding: const EdgeInsets.all(1.0),
                child: Material(
                  color: index.isEven ? Colors.grey.shade100 : Colors.white,
                  child: InkWell(
                    onTap: () {
                      if (isDeleteMode) {
                        context
                            .read<BookmarksBloc>()
                            .add(BookmarksItemToggled(device));
                      } else {
                        // print('${device.id} : ${device.path}');
                        context.read<BookmarksBloc>().add(DeviceStatusChecked(
                              initialPath,
                              device.path,
                              pageController,
                            ));
                      }
                    },
                    onLongPress: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: context.read<BookmarksBloc>(),
                          child: _BookmarksEditBottomMenu(
                            superContext: context,
                            device: device,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: CommonStyle.severityRectangleWidth,
                                  height: 60.0,
                                  color: CustomStyle
                                      .nodeStatusColor[device.status],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 0.0, 6.0, 4.0),
                                  child: Text(
                                    _getDisplayName(device),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                      fontSize: CommonStyle.sizeL,
                                      //fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 0.0, 6.0, 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        device.ip,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.roboto(
                                          fontSize: CommonStyle.sizeS,
                                          //fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isDeleteMode
                              ? selectedDevices.contains(device)
                                  ? const Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.amber,
                                    )
                                  : const Icon(
                                      Icons.circle_outlined,
                                      color: Colors.amber,
                                    )
                              : const Icon(
                                  Icons.circle_outlined,
                                  color: Colors.transparent,
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container(); // Hide deleted device
      },
      childCount: hasReachMax ? data.length : data.length + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _isBottom() {
      if (!_scrollController.hasClients) return false;
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      return currentScroll >= maxScroll;
    }

    void _onScroll() {
      if (_isBottom()) {
        print('BOTTOM');
        context.read<BookmarksBloc>().add(const MoreBookmarksRequested());
      }
    }

    _scrollController.addListener(_onScroll);

    return BlocBuilder<BookmarksBloc, BookmarksState>(
      builder: (context, state) {
        if (state.formStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.formStatus.isRequestSuccess) {
          return Container(
            color: Colors.grey.shade300,
            child: Scrollbar(
              controller: _scrollController,
              thickness: 8.0,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverList(
                    delegate: _deviceSliverChildBuilderDelegate(
                      data: state.devices,
                      initialPath: initialPath,
                      isDeleteMode: state.isDeleteMode,
                      selectedDevices: state.selectedDevices,
                      hasReachMax: state.hasReachedMax,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state.formStatus.isRequestFailure) {
          return Center(
            child: Text(
              getMessageLocalization(
                msg: state.requestErrorMsg,
                context: context,
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class _BookmarksFloatingActionButton extends StatelessWidget {
  const _BookmarksFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool?> _showConfirmDeleteDialog(List<Device> devices) async {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title:
                Text(AppLocalizations.of(context)!.dialogTitle_deleteBookmark),
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

    return BlocBuilder<BookmarksBloc, BookmarksState>(
        buildWhen: (previous, current) =>
            previous.isDeleteMode != current.isDeleteMode,
        builder: (context, state) {
          if (state.formStatus.isRequestSuccess) {
            if (state.isDeleteMode) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: null,
                    elevation: 0.0,
                    backgroundColor: const Color(0x742195F3),
                    onPressed: () async {
                      bool? result =
                          await _showConfirmDeleteDialog(state.devices);
                      if (result != null) {
                        result
                            ? context
                                .read<BookmarksBloc>()
                                .add(const MultipleBookmarksDeleted())
                            : null;
                      }
                    },
                    child: const Icon(
                      CustomIcons.check,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(6.0),
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    elevation: 0.0,
                    backgroundColor: const Color(0x742195F3),
                    onPressed: () {
                      context
                          .read<BookmarksBloc>()
                          .add(const BookmarksDeletedModeDisabled());
                    },
                    child: const Icon(
                      CustomIcons.cancel,
                    ),
                  ),
                ],
              );
            } else {
              return const Center();
            }
          } else {
            return const Center();
          }
        });
  }
}

class _BookmarksEditBottomMenu extends StatelessWidget {
  const _BookmarksEditBottomMenu({
    Key? key,
    required this.superContext,
    required this.device,
  }) : super(key: key);

  final BuildContext superContext;
  final Device device;

  @override
  Widget build(BuildContext context) {
    Future<bool?> _showConfirmDeleteDialog(Device device) async {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitle_deleteBookmark,
            ),
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
                          text: device.name,
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

            bool? result = await _showConfirmDeleteDialog(device);
            if (result != null) {
              result
                  ? superContext
                      .read<BookmarksBloc>()
                      .add((BookmarksDeleted(device)))
                  : null;
            }
          },
        ),
      ],
    );
  }
}
