import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/advanced/bloc/trap_forward/trap_forward_bloc.dart';
import 'package:ricoms_app/advanced/view/trap_forward_view/trap_forward_edit_page.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_forward_repository/forward_outline.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/common_widget.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class TrapForwardForm extends StatelessWidget {
  const TrapForwardForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showSuccessDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitle_deletedSuccessfully,
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

    return BlocListener<TrapForwardBloc, TrapForwardState>(
      listener: (context, state) {
        if (state.deleteStatus.isSubmissionSuccess) {
          _showSuccessDialog(state.deleteResultMsg);
        } else if (state.deleteStatus.isSubmissionFailure) {
          _showFailureDialog(state.deleteResultMsg);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.trapForward),
          elevation: 0.0,
          actions: const [
            _PopupMenu(),
          ],
        ),
        body: const _ForwardOutlineSliverList(),
        floatingActionButton: const _AccountFloatingActionButton(),
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
    return BlocBuilder<TrapForwardBloc, TrapForwardState>(
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
                    .read<TrapForwardBloc>()
                    .add(const ForwardOutlinesDeletedModeEnabled());
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

class _AccountFloatingActionButton extends StatelessWidget {
  const _AccountFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool?> _showConfirmDeleteDialog() async {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitle_deleteTrapForward,
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

    return BlocBuilder<TrapForwardBloc, TrapForwardState>(
      buildWhen: (previous, current) =>
          previous.isDeleteMode != current.isDeleteMode,
      builder: (context, state) {
        if (state.isDeleteMode) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: null,
                elevation: 0.0,
                backgroundColor: const Color(0x742195F3),
                onPressed: () async {
                  bool? result = await _showConfirmDeleteDialog();
                  if (result != null) {
                    result
                        ? context
                            .read<TrapForwardBloc>()
                            .add(const MultipleForwardOutlinesDeleted())
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
                      .read<TrapForwardBloc>()
                      .add(const ForwardOutlinesDeletedModeDisabled());
                },
                child: const Icon(
                  CustomIcons.cancel,
                ),
              ),
            ],
          );
        } else {
          return FloatingActionButton(
            elevation: 0.0,
            backgroundColor: const Color(0x742195F3),
            onPressed: () async {
              bool? isModify = await Navigator.push(
                  context,
                  TrapForwardEditPage.route(
                      isEditing: false,
                      forwardOutline: ForwardOutline(
                        id: 0,
                        enable: 0,
                        name: '',
                        ip: '',
                        parameter: '',
                      )));

              if (isModify != null) {
                if (isModify) {
                  context
                      .read<TrapForwardBloc>()
                      .add(const ForwardOutlinesRequested());
                }
              }
            },
            child: const Icon(Icons.add),
          );
        }
      },
    );
  }
}

class _ForwardOutlineSliverList extends StatelessWidget {
  const _ForwardOutlineSliverList({
    Key? key,
  }) : super(key: key);

  SliverChildBuilderDelegate _forwardOutlineSliverChildBuilderDelegate({
    required List data,
    required bool isDeleteMode,
    required List<ForwardOutline> selectedForwardOutlines,
  }) {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        ForwardOutline forwardOutline = data[index];
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Material(
            color: index.isEven ? Colors.grey.shade100 : Colors.white,
            child: InkWell(
              onTap: isDeleteMode
                  ? () {
                      context
                          .read<TrapForwardBloc>()
                          .add(ForwardOutlinesItemToggled(forwardOutline));
                    }
                  : null,
              onLongPress: () {
                CommonWidget.showSafeModalBottomSheet(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<TrapForwardBloc>(),
                    child: _ForwardOutlineEditBottomMenu(
                      superContext: context,
                      forwardOutline: forwardOutline,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 6.0, 10.0),
                            child: Text(
                              forwardOutline.name,
                              //maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: CommonStyle.sizeXL,
                                //fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isDeleteMode
                        ? selectedForwardOutlines.contains(forwardOutline)
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
        );
      },
      childCount: data.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrapForwardBloc, TrapForwardState>(
      builder: (context, state) {
        if (state.status.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.status.isRequestSuccess) {
          return Container(
            color: Colors.grey.shade300,
            child: Scrollbar(
              thickness: 8.0,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: _forwardOutlineSliverChildBuilderDelegate(
                    data: state.forwardOutlines,
                    isDeleteMode: state.isDeleteMode,
                    selectedForwardOutlines: state.selectedforwardOutlines,
                  )),
                ],
              ),
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
                    msg: state.requestErrorMsg,
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

class _ForwardOutlineEditBottomMenu extends StatelessWidget {
  const _ForwardOutlineEditBottomMenu({
    Key? key,
    required this.superContext,
    required this.forwardOutline,
  }) : super(key: key);

  final BuildContext superContext;
  final ForwardOutline forwardOutline;

  @override
  Widget build(BuildContext context) {
    Future<bool?> _showConfirmDeleteDialog(
        ForwardOutline forwardOutline) async {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitle_deleteTrapForward,
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
                          text: forwardOutline.name,
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
                  Icons.edit,
                ),
              ),
            ),
          ),
          title: Text(
            AppLocalizations.of(context)!.edit,
            style: const TextStyle(fontSize: CommonStyle.sizeM),
          ),
          onTap: () async {
            Navigator.pop(context);
            bool? isModify = await Navigator.push(
                context,
                TrapForwardEditPage.route(
                  isEditing: true,
                  forwardOutline: forwardOutline,
                ));

            if (isModify != null) {
              if (isModify) {
                superContext
                    .read<TrapForwardBloc>()
                    .add(const ForwardOutlinesRequested());
              }
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
          title: Text(
            AppLocalizations.of(context)!.delete,
            style: const TextStyle(fontSize: CommonStyle.sizeM),
          ),
          onTap: () async {
            Navigator.pop(context);

            bool? result = await _showConfirmDeleteDialog(forwardOutline);
            if (result != null) {
              result
                  ? superContext
                      .read<TrapForwardBloc>()
                      .add((ForwardOutlineDeleted(forwardOutline.id)))
                  : null;
            }
          },
        ),
      ],
    );
  }
}
