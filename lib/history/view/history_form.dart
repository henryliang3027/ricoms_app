import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/history/bloc/history/history_bloc.dart';
import 'package:ricoms_app/history/view/device_history_detail_page.dart';
import 'package:ricoms_app/history/view/search_page.dart';
import 'package:ricoms_app/home/view/home_bottom_navigation_bar.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';
import 'package:ricoms_app/repository/history_repository/history_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/common_widget.dart';
import 'package:ricoms_app/utils/display_style.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/utils/message_localization.dart';

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
              AppLocalizations.of(context)!.dialogTitle_error,
              style: const TextStyle(color: CustomStyle.customRed),
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

    Future<void> _showNoMoreRecordsDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitle_NoMoreData,
              style: const TextStyle(
                color: CustomStyle.customGreen,
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

    return BlocListener<HistoryBloc, HistoryState>(
      listener: (context, state) {
        if (state.targetDeviceStatus.isRequestFailure) {
          _showFailureDialog(state.errmsg);
        } else if (state.historyExportStatus.isRequestSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  getMessageLocalization(
                    msg: state.historyExportMsg,
                    context: context,
                  ),
                ),
                action: SnackBarAction(
                  label: AppLocalizations.of(context)!.open,
                  onPressed: () async {
                    OpenResult result = await OpenFilex.open(
                      state.historyExportFilePath,
                      type: 'application/vnd.ms-excel',
                      uti: 'com.microsoft.excel.xls',
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
      child: WillPopScope(
        onWillPop: () async {
          bool? isExit = await CommonWidget.showExitAppDialog(context: context);
          return isExit ?? false;
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(AppLocalizations.of(context)!.history),
            leading: HomeDrawerToolTip.setToolTip(context),
            elevation: 0.0,
            actions: const [
              _PopupMenu(),
            ],
          ),
          bottomNavigationBar: HomeBottomNavigationBar(
            pageController: pageController,
            selectedIndex: 3,
          ),
          drawer: HomeDrawer(
            user: context.read<AuthenticationBloc>().state.user,
            pageController: pageController,
            currentPageIndex: 3,
          ),
          body: _HistorySliverList(
            pageController: pageController,
            initialPath: initialPath,
          ),
          floatingActionButton: const _HistoryFloatingActionButton(),
        ),
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
      builder: (context, state) {
        return Visibility(
          visible: state.isShowFloatingActionButton,
          child: FloatingActionButton(
            elevation: 0.0,
            backgroundColor: const Color(0x742195F3),
            onPressed: !state.moreRecordsStatus.isRequestInProgress
                ? () {
                    context
                        .read<HistoryBloc>()
                        .add(const MoreOlderRecordsRequested());
                  }
                : null,
            child: state.moreRecordsStatus.isRequestInProgress
                ? const SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.add),
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
        icon: const Icon(
          Icons.more_vert_outlined,
          color: Colors.white,
        ),
        tooltip: '',
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  CustomIcons.filters,
                  size: 20.0,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  AppLocalizations.of(context)!.filters,
                ),
              ],
            ),
          ),
          PopupMenuItem<Menu>(
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
          )
        ],
      );
    });
  }
}

Widget _showEmptyContent(BuildContext context) {
  return Center(
    child: Text(AppLocalizations.of(context)!.noMoreRecordToShow),
  );
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
            color: index.isEven ? Colors.grey.shade100 : Colors.white,
            child: InkWell(
              onTap: () {
                // because HistoryBloc cannot be found inside ModalBottomSheet
                // provide the context that contain HistoryBloc for it
                showModalBottomSheet(
                  context: context,
                  builder: (_) => _HistoryBottomMenu(
                    parentContext: context,
                    initialPath: initialPath,
                    record: record,
                    pageController: pageController,
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
                              style: const TextStyle(
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
                              style: const TextStyle(
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
                                  style: const TextStyle(
                                    fontSize: CommonStyle.sizeS,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  record.receivedTime,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
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

          return RefreshIndicator(
            onRefresh: () async {
              Future block = context.read<HistoryBloc>().stream.first;
              context
                  .read<HistoryBloc>()
                  .add(const MoreNewerRecordsRequested());
              await block;
            },
            child: Container(
              color: Colors.grey.shade300,
              child: state.records.isNotEmpty
                  ? Scrollbar(
                      controller: _scrollController,
                      thickness: 8.0,
                      child: ScrollConfiguration(
                        behavior: ScrollBehavior(),
                        child: GlowingOverscrollIndicator(
                          axisDirection: AxisDirection.down,
                          color: Colors.blue,
                          child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            slivers: [
                              SliverList(
                                delegate: _historySliverChildBuilderDelegate(
                                  state.records,
                                  initialPath,
                                  pageController,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : _showEmptyContent(context),
            ),
          );
        } else if (state.status.isRequestFailure) {
          return Container(
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
    required this.parentContext,
    required this.initialPath,
    required this.record,
    required this.pageController,
  }) : super(key: key);

  final BuildContext parentContext;
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
          title: Text(
            AppLocalizations.of(context)!.showDetail,
            style: const TextStyle(fontSize: CommonStyle.sizeM),
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
          title: Text(
            AppLocalizations.of(context)!.goToDeviceSetting,
            style: const TextStyle(fontSize: CommonStyle.sizeM),
          ),
          onTap: () {
            Navigator.pop(context);
            parentContext.read<HistoryBloc>().add(DeviceStatusChecked(
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
