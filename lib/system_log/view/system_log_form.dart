import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/home/view/home_bottom_navigation_bar.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';
import 'package:ricoms_app/repository/system_log_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/system_log/bloc/system_log/system_log_bloc.dart';
import 'package:ricoms_app/system_log/view/filter_page.dart';
import 'package:ricoms_app/system_log/view/system_log_detail_page.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/common_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/utils/display_style.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class SystemLogForm extends StatelessWidget {
  const SystemLogForm({
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
              style: TextStyle(
                color: CustomStyle.severityColor[3],
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

    Future<void> _showNoMoreLogsDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitle_NoMoreData,
              style: TextStyle(
                color: CustomStyle.severityColor[1],
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

    return BlocListener<SystemLogBloc, SystemLogState>(
      listener: (context, state) {
        if (state.targetDeviceStatus.isRequestFailure) {
          _showFailureDialog(state.errmsg);
        } else if (state.logExportStatus.isRequestSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  getMessageLocalization(
                    msg: state.logExportMsg,
                    context: context,
                  ),
                ),
                action: SnackBarAction(
                  label: AppLocalizations.of(context)!.open,
                  onPressed: () async {
                    OpenFilex.open(
                      state.logExportFilePath,
                      type: 'text/comma-separated-values',
                      uti: 'public.comma-separated-values-text',
                    );
                  },
                ),
              ),
            );
        } else if (state.logExportStatus.isRequestFailure) {
          _showFailureDialog(state.logExportMsg);
        } else if (state.moreLogsStatus.isRequestFailure) {
          _showNoMoreLogsDialog(state.moreLogsMessage);
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          bool? isExit = await CommonWidget.showExitAppDialog(context: context);
          return isExit ?? false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            centerTitle: true,
            title: Text(AppLocalizations.of(context)!.systemLog),
            leading: HomeDrawerToolTip.setToolTip(context),
            elevation: 0.0,
            actions: const [
              _PopupMenu(),
            ],
          ),
          bottomNavigationBar: HomeBottomNavigationBar(
            pageController: pageController,
            selectedIndex: 5, // No need to show button, set an useless index
          ),
          drawer: HomeDrawer(
            user: context.read<AuthenticationBloc>().state.user,
            pageController: pageController,
            currentPageIndex: 5,
          ),
          body: _LogSliverList(
            pageController: pageController,
            initialPath: initialPath,
          ),
          floatingActionButton: const _LogFloatingActionButton(),
        ),
      ),
    );
  }
}

class _LogFloatingActionButton extends StatelessWidget {
  const _LogFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SystemLogBloc, SystemLogState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isShowFloatingActionButton,
          child: FloatingActionButton(
            elevation: 0.0,
            backgroundColor: const Color(0x742195F3),
            onPressed: !state.moreLogsStatus.isRequestInProgress
                ? () {
                    context
                        .read<SystemLogBloc>()
                        .add(MoreLogsRequested(state.logs.last.id));
                  }
                : null,
            child: state.moreLogsStatus.isRequestInProgress
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
    return BlocBuilder<SystemLogBloc, SystemLogState>(
        builder: (context, state) {
      return PopupMenuButton<Menu>(
        tooltip: '',
        onSelected: (Menu item) async {
          switch (item) {
            case Menu.filter:
              var filterCriteria = await Navigator.push(
                  context, FilterPage.route(state.filterCriteria));

              if (filterCriteria != null) {
                context.read<SystemLogBloc>().add(LogRequested(filterCriteria));
              }
              break;
            case Menu.export:
              context.read<SystemLogBloc>().add(const LogsExported());
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
                  CustomIcons.filter,
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

class _LogSliverList extends StatelessWidget {
  _LogSliverList({
    Key? key,
    required this.pageController,
    required this.initialPath,
  }) : super(key: key);

  final PageController pageController;
  final List initialPath;
  final ScrollController _scrollController = ScrollController();

  SliverChildBuilderDelegate _logSliverChildBuilderDelegate(
    List data,
    List initialPath,
    PageController pageController,
  ) {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        Log log = data[index];
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Material(
            color: index.isEven ? Colors.grey.shade100 : Colors.white,
            child: InkWell(
              onTap: () {
                // because SystemLogBloc cannot be found inside ModalBottomSheet
                // provide the context that contain SystemLogBloc for it
                showModalBottomSheet(
                  context: context,
                  builder: (_) => _LogBottomMenu(
                    parentContext: context,
                    initialPath: initialPath,
                    log: log,
                    pageController: pageController,
                  ),
                );
              },
              child: _buildItem(log),
            ),
          ),
        );
      },
      childCount: data.length,
    );
  }

  Widget _buildItem(Log log) {
    if (log.logType == 'User') {
      return _buildUserTypeItem(log);
    } else if (log.logType == 'Device') {
      return _buildDeviceTypeItem(log);
    } else {
      return const Center(
        child: Text(
          'Log type is not valid.',
        ),
      );
    }
  }

  Widget _buildUserTypeItem(Log log) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  CustomIcons.user,
                  color: Colors.blue,
                  size: 30.0,
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        log.event,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: CommonStyle.sizeL,
                          //fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        log.account,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        log.userIP,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: CommonStyle.sizeS,
                          //fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        log.startTime,
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceTypeItem(Log log) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  CustomIcons.device_simple,
                  color: Colors.blue,
                  size: 30.0,
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
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 4.0),
                  child: Text(
                    log.event,
                    //maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: CommonStyle.sizeL,
                      //fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 4.0),
                  child: Text(
                    DisplayStyle.getSystemLogDeviceTypeDeviceDisplayName(log),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: CommonStyle.sizeS,
                      //fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        log.deviceIP,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: CommonStyle.sizeS,
                          //fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        log.startTime,
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
      if (context.read<SystemLogBloc>().state.isShowFloatingActionButton) {
        if (!_isBottom()) {
          context.read<SystemLogBloc>().add(const FloatingActionButtonHided());
        }
      } else {
        if (_isBottom()) {
          context.read<SystemLogBloc>().add(const FloatingActionButtonShowed());
        }
      }
    }

    _scrollController.addListener(_onScroll);

    return BlocBuilder<SystemLogBloc, SystemLogState>(
      builder: (context, state) {
        if (state.status.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.status.isRequestSuccess) {
          if (state.moreLogsStatus.isRequestSuccess) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(_scrollController.offset + 20,
                    duration: const Duration(seconds: 1), curve: Curves.ease);
              }
            });
          }

          return Container(
            color: Colors.grey.shade300,
            child: Scrollbar(
              controller: _scrollController,
              thickness: 8.0,
              child: state.logs.isNotEmpty
                  ? CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverList(
                          delegate: _logSliverChildBuilderDelegate(
                            state.logs,
                            initialPath,
                            pageController,
                          ),
                        ),
                      ],
                    )
                  : _showEmptyContent(context),
            ),
          );
        } else if (state.status.isRequestFailure) {
          return Center(
            child: Text(
              getMessageLocalization(
                msg: state.errmsg,
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

class _LogBottomMenu extends StatelessWidget {
  const _LogBottomMenu({
    Key? key,
    required this.parentContext,
    required this.initialPath,
    required this.log,
    required this.pageController,
  }) : super(key: key);

  final BuildContext parentContext;
  final List initialPath;
  final Log log;
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
            Navigator.push(context, SystemLogDetailPage.route(log));
          },
        ),
        log.logType == 'Device'
            ? ListTile(
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
                  parentContext.read<SystemLogBloc>().add(DeviceStatusChecked(
                        initialPath,
                        log.path,
                        pageController,
                      ));
                },
              )
            : Container(),
      ],
    );
  }
}
