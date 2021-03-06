import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/history/bloc/history/history_bloc.dart';
import 'package:ricoms_app/history/view/device_history_detail_page.dart';
import 'package:ricoms_app/history/view/search_page.dart';
import 'package:ricoms_app/home/view/home_bottom_navigation_bar.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';
import 'package:ricoms_app/repository/history_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/display_style.dart';
import 'package:open_file/open_file.dart';

class HistoryForm extends StatelessWidget {
  const HistoryForm({
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

    Future<void> _showNoMoreRecordsDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Success!',
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

    return BlocListener<HistoryBloc, HistoryState>(
      listener: (context, state) {
        if (state.targetDeviceStatus.isRequestFailure) {
          _showFailureDialog(state.errmsg);
        } else if (state.historyExportStatus.isRequestSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.historyExportMsg),
                action: SnackBarAction(
                  label: 'Open',
                  onPressed: () async {
                    OpenFile.open(
                      state.historyExportFilePath,
                      type: 'text/comma-separated-values',
                      uti: 'public.comma-separated-values-text',
                    );
                  },
                ),
              ),
            );
        } else if (state.historyExportStatus.isRequestFailure) {
          _showFailureDialog(state.historyExportMsg);
        } else if (state.moreRecordsStatus.isRequestFailure) {
          _showNoMoreRecordsDialog(state.moreRecordsMessage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History'),
          actions: const [
            _PopupMenu(),
          ],
        ),
        bottomNavigationBar: HomeBottomNavigationBar(
          pageController: pageController,
          selectedIndex: 3,
        ),
        drawer: HomeDrawer(
          user: context.select(
            (AuthenticationBloc bloc) => bloc.state.user,
          ),
          pageController: pageController,
          currentPageIndex: 3,
        ),
        body: _HistorySliverList(
          pageController: pageController,
          initialPath: initialPath,
        ),
        floatingActionButton: const _HistoryFloatingActionButton(),
      ),
    );
  }
}

class _HistoryFloatingActionButton extends StatelessWidget {
  const _HistoryFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      buildWhen: (previous, current) =>
          previous.isShowFloatingActionButton !=
          current.isShowFloatingActionButton,
      builder: (context, state) {
        return Visibility(
          visible: state.isShowFloatingActionButton,
          child: FloatingActionButton(
            elevation: 0.0,
            backgroundColor: const Color(0x742195F3),
            onPressed: () {
              context
                  .read<HistoryBloc>()
                  .add(MoreRecordsRequested(state.records.last.trapId));
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

enum Menu {
  filter,
  export,
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(builder: (context, state) {
      return PopupMenuButton<Menu>(
        onSelected: (Menu item) async {
          switch (item) {
            case Menu.filter:
              var searchCriteria = await Navigator.push(
                  context, SearchPage.route(state.currentCriteria));

              if (searchCriteria != null) {
                context
                    .read<HistoryBloc>()
                    .add(HistoryRequested(searchCriteria));
              }
              break;
            case Menu.export:
              context.read<HistoryBloc>().add(const HistoryRecordsExported());
              break;
            default:
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          PopupMenuItem<Menu>(
            value: Menu.filter,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  // <-- Icon
                  CustomIcons.filter,
                  size: 20.0,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text('Filters'),
              ],
            ),
          ),
          PopupMenuItem<Menu>(
            value: Menu.export,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  CustomIcons.export,
                  size: 20.0,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text('Export'),
              ],
            ),
          )
        ],
      );
    });
  }
}

class _HistorySliverList extends StatelessWidget {
  _HistorySliverList({
    Key? key,
    required this.pageController,
    required this.initialPath,
  }) : super(key: key);

  final PageController pageController;
  final List initialPath;
  final ScrollController _scrollController = ScrollController();

  SliverChildBuilderDelegate _historySliverChildBuilderDelegate(
    List data,
    List initialPath,
    PageController pageController,
  ) {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        Record record = data[index];
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                // because HistoryBloc cannot be found inside ModalBottomSheet
                // provide HistoryBloc for it by using BlocProvider
                showModalBottomSheet(
                    context: context,
                    builder: (_) => BlocProvider.value(
                          value: context.read<HistoryBloc>(),
                          child: _HistoryBottomMenu(
                            initialPath: initialPath,
                            record: record,
                            pageController: pageController,
                          ),
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
                            color: CustomStyle.severityColor[record.severity],
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
                              record.event,
                              //maxLines: 2,
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
                            child: Text(
                              DisplayStyle.getDeviceDisplayName(record),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                fontSize: CommonStyle.sizeS,
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
                                  record.ip,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                    fontSize: CommonStyle.sizeS,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  record.receivedTime,
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
    bool _isBottom() {
      if (!_scrollController.hasClients) return false;
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      return currentScroll >= maxScroll;
    }

    void _onScroll() {
      if (context.read<HistoryBloc>().state.isShowFloatingActionButton) {
        if (!_isBottom()) {
          context.read<HistoryBloc>().add(const FloatingActionButtonHided());
        }
      } else {
        if (_isBottom()) {
          context.read<HistoryBloc>().add(const FloatingActionButtonShowed());
        }
      }
    }

    _scrollController.addListener(_onScroll);

    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state.status.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.status.isRequestSuccess) {
          if (state.moreRecordsStatus.isRequestSuccess) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(_scrollController.offset + 20,
                    duration: const Duration(seconds: 1), curve: Curves.ease);
              }
            });
          }

          return Container(
            color: Colors.grey.shade300,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverList(
                  delegate: _historySliverChildBuilderDelegate(
                    state.records,
                    initialPath,
                    pageController,
                  ),
                ),
                // SliverList(
                //   delegate: SliverChildBuilderDelegate(
                //       (BuildContext context, int index) {
                //     return Container(
                //       height: 80,
                //       color: Colors.white,
                //     );
                //   }, childCount: 1),
                // )
              ],
            ),
          );
        } else if (state.status.isRequestFailure) {
          return Center(
            child: Text(state.errmsg),
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

class _HistoryBottomMenu extends StatelessWidget {
  const _HistoryBottomMenu({
    Key? key,
    required this.initialPath,
    required this.record,
    required this.pageController,
  }) : super(key: key);

  final List initialPath;
  final Record record;
  final PageController pageController;

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
                  Icons.info_outline,
                ),
              ),
            ),
          ),
          title: const Text(
            'Show Detail',
            style: TextStyle(fontSize: CommonStyle.sizeM),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, HistoryDetailPage.route(record));
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
            'Go to Device Setting',
            style: TextStyle(fontSize: CommonStyle.sizeM),
          ),
          onTap: () {
            Navigator.pop(context);
            context.read<HistoryBloc>().add(DeviceStatusChecked(
                  initialPath,
                  record.path,
                  pageController,
                ));
          },
        ),
      ],
    );
  }
}
