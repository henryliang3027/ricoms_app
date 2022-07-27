import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/bookmarks/bloc/bookmarks_bloc.dart';
import 'package:ricoms_app/home/view/home_bottom_navigation_bar.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';
import 'package:ricoms_app/repository/bookmarks_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';

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
    return BlocListener<BookmarksBloc, BookmarksState>(
      listener: (context, state) async {},
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookmarks'),
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
      ),
    );
  }
}

enum Menu {
  delete,
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarksBloc, BookmarksState>(
        builder: (context, state) {
      return PopupMenuButton<Menu>(
        onSelected: (Menu item) async {
          switch (item) {
            case Menu.delete:
              context
                  .read<BookmarksBloc>()
                  .add(const BookmarksDeletedModeToggled());
              break;
            default:
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          PopupMenuItem<Menu>(
            value: Menu.delete,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.delete_outline,
                  size: 20.0,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text('Delete'),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _DeviceSliverList extends StatelessWidget {
  const _DeviceSliverList({
    Key? key,
    required this.pageController,
    required this.initialPath,
  }) : super(key: key);

  final List initialPath;
  final PageController pageController;

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
  }) {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        Device device = data[index];
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Material(
            child: InkWell(
              onTap: () {
                // initialPath.clear();
                // initialPath.addAll(device.path);
                context.read<BookmarksBloc>().add(DeviceStatusChecked(
                      initialPath,
                      device.path,
                      pageController,
                    ));
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
                            color: CustomStyle.severityColor[device.status],
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
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 4.0),
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
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        ? const Icon(
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
        );
      },
      childCount: data.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarksBloc, BookmarksState>(
      builder: (context, state) {
        if (state.formStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.formStatus.isRequestSuccess) {
          return Container(
              color: Colors.grey.shade300,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: _deviceSliverChildBuilderDelegate(
                      data: state.devices,
                      initialPath: initialPath,
                      isDeleteMode: state.isDeleteMode,
                    ),
                  )
                ],
              ));
        } else if (state.formStatus.isRequestFailure) {
          return Center(
            child: Text(state.requestErrorMsg),
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
