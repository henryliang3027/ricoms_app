import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/advanced/bloc/default_setting/default_setting_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/repository/default_setting_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class DefaultSettingForm extends StatelessWidget {
  const DefaultSettingForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showSuccessDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitle_editSuccess,
              style: const TextStyle(
                color: CustomStyle.customGreen,
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

    return BlocListener<DefaultSettingBloc, DefaultSettingState>(
      listener: (context, state) {
        if (state.status.isRequestFailure) {
          _showFailureDialog(state.requestErrorMsg);
        } else if (state.submissionStatus.isSubmissionSuccess) {
          _showSuccessDialog();
        } else if (state.submissionStatus.isSubmissionFailure) {
          _showFailureDialog(state.submissionErrorMsg);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.resetToDefaultSettings,
            overflow: TextOverflow.visible,
          ),
          elevation: 0.0,
          actions: const [
            _PopupMenu(),
          ],
        ),
        body: const _DefaultSettingContent(),
        floatingActionButton: const _DefaultSettingEditFloatingActionButton(),
      ),
    );
  }
}

enum Menu {
  selectAll,
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DefaultSettingBloc, DefaultSettingState>(
        builder: (context, state) {
      if (state.status.isRequestSuccess) {
        if (state.isEditing) {
          return PopupMenuButton<Menu>(
            tooltip: '',
            onSelected: (Menu item) async {
              switch (item) {
                case Menu.selectAll:
                  context
                      .read<DefaultSettingBloc>()
                      .add(const AllItemsSelected());
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
              PopupMenuItem<Menu>(
                value: Menu.selectAll,
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
                    Text(AppLocalizations.of(context)!.selectAll),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      } else {
        return Container();
      }
    });
  }
}

class _DefaultSettingContent extends StatelessWidget {
  const _DefaultSettingContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildSettingTitle({required String title}) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
          bottom: 10.0,
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildDefaultSettingCustomTile({
      required String name,
      required int index,
      required bool isEditing,
      required DefaultSettingItem defaultSettingItem,
      required Function onSelect,
    }) {
      return Material(
        child: InkWell(
          onTap: isEditing
              ? () {
                  context
                      .read<DefaultSettingBloc>()
                      .add(DefaultSettingItemToggled(index));
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 10.0,
              bottom: 10.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: CommonStyle.sizeXL,
                        ),
                      ),
                    ),
                    isEditing
                        ? defaultSettingItem.isSelected
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
                          ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.defaultValue,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      defaultSettingItem.defaultValue,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.currentValue,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      defaultSettingItem.currentValue,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BlocBuilder<DefaultSettingBloc, DefaultSettingState>(
      builder: (context, state) {
        if (state.status.isRequestSuccess) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSettingTitle(
                  title: AppLocalizations.of(context)!.deviceWorkingCycle,
                ),
                _buildDefaultSettingCustomTile(
                  name: AppLocalizations.of(context)!.deviceWorkingCycle,
                  index: 0,
                  isEditing: state.isEditing,
                  defaultSettingItem: state.defaultSettingItems[0],
                  onSelect: () {
                    context
                        .read<DefaultSettingBloc>()
                        .add(const DefaultSettingItemToggled(0));
                  },
                ),
                const Divider(
                  color: Colors.grey,
                  height: 1,
                ),
                _buildSettingTitle(
                  title: AppLocalizations.of(context)!.trapHistory,
                ),
                _buildDefaultSettingCustomTile(
                  name: AppLocalizations.of(context)!
                      .archivedHistoricalRecordQuanitiy,
                  index: 1,
                  isEditing: state.isEditing,
                  defaultSettingItem: state.defaultSettingItems[1],
                  onSelect: () {
                    context
                        .read<DefaultSettingBloc>()
                        .add(const DefaultSettingItemToggled(1));
                  },
                ),
                const Divider(
                  color: Colors.grey,
                  height: 1,
                ),
                _buildSettingTitle(
                  title: AppLocalizations.of(context)!.apiLog,
                ),
                _buildDefaultSettingCustomTile(
                  name: AppLocalizations.of(context)!.clearingFeature,
                  index: 2,
                  isEditing: state.isEditing,
                  defaultSettingItem: state.defaultSettingItems[2],
                  onSelect: () {
                    context
                        .read<DefaultSettingBloc>()
                        .add(const DefaultSettingItemToggled(2));
                  },
                ),
                _buildDefaultSettingCustomTile(
                  name: AppLocalizations.of(context)!.preservedQuantity,
                  index: 3,
                  isEditing: state.isEditing,
                  defaultSettingItem: state.defaultSettingItems[3],
                  onSelect: () {
                    context
                        .read<DefaultSettingBloc>()
                        .add(const DefaultSettingItemToggled(3));
                  },
                ),
                _buildDefaultSettingCustomTile(
                  name: AppLocalizations.of(context)!.preservedDays,
                  index: 4,
                  isEditing: state.isEditing,
                  defaultSettingItem: state.defaultSettingItems[4],
                  onSelect: () {
                    context
                        .read<DefaultSettingBloc>()
                        .add(const DefaultSettingItemToggled(4));
                  },
                ),
                const Divider(
                  color: Colors.grey,
                  height: 1,
                ),
                _buildSettingTitle(
                  title: AppLocalizations.of(context)!.userSystemLog,
                ),
                _buildDefaultSettingCustomTile(
                  name: AppLocalizations.of(context)!.clearingFeature,
                  index: 5,
                  isEditing: state.isEditing,
                  defaultSettingItem: state.defaultSettingItems[5],
                  onSelect: () {
                    context
                        .read<DefaultSettingBloc>()
                        .add(const DefaultSettingItemToggled(5));
                  },
                ),
                _buildDefaultSettingCustomTile(
                  name: AppLocalizations.of(context)!.preservedQuantity,
                  index: 6,
                  isEditing: state.isEditing,
                  defaultSettingItem: state.defaultSettingItems[6],
                  onSelect: () {
                    context
                        .read<DefaultSettingBloc>()
                        .add(const DefaultSettingItemToggled(6));
                  },
                ),
                _buildDefaultSettingCustomTile(
                  name: AppLocalizations.of(context)!.preservedDays,
                  index: 7,
                  isEditing: state.isEditing,
                  defaultSettingItem: state.defaultSettingItems[7],
                  onSelect: () {
                    context
                        .read<DefaultSettingBloc>()
                        .add(const DefaultSettingItemToggled(7));
                  },
                ),
                const Divider(
                  color: Colors.grey,
                  height: 1,
                ),
                _buildSettingTitle(
                  title: AppLocalizations.of(context)!.deviceSystemLog,
                ),
                _buildDefaultSettingCustomTile(
                  name: AppLocalizations.of(context)!.clearingFeature,
                  index: 8,
                  isEditing: state.isEditing,
                  defaultSettingItem: state.defaultSettingItems[8],
                  onSelect: () {
                    context
                        .read<DefaultSettingBloc>()
                        .add(const DefaultSettingItemToggled(8));
                  },
                ),
                _buildDefaultSettingCustomTile(
                  name: AppLocalizations.of(context)!.preservedQuantity,
                  index: 9,
                  isEditing: state.isEditing,
                  defaultSettingItem: state.defaultSettingItems[9],
                  onSelect: () {
                    context
                        .read<DefaultSettingBloc>()
                        .add(const DefaultSettingItemToggled(9));
                  },
                ),
                _buildDefaultSettingCustomTile(
                  name: AppLocalizations.of(context)!.preservedDays,
                  index: 10,
                  isEditing: state.isEditing,
                  defaultSettingItem: state.defaultSettingItems[10],
                  onSelect: () {
                    context
                        .read<DefaultSettingBloc>()
                        .add(const DefaultSettingItemToggled(10));
                  },
                ),
                const SizedBox(
                  height: 160.0,
                ),
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

class _DefaultSettingEditFloatingActionButton extends StatelessWidget {
  const _DefaultSettingEditFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map _userFunctionMap =
        context.read<AuthenticationBloc>().state.userFunctionMap;

    Future<bool?> _showConfirmResetDialog() async {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitle_resetToDefaultSetting,
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
                              .dialogMessage_resetToDefaultSetting,
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
                  AppLocalizations.of(context)!.yes,
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

    return BlocBuilder<DefaultSettingBloc, DefaultSettingState>(
      builder: (context, state) {
        return _userFunctionMap[37]
            ? state.isEditing
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        heroTag: null,
                        elevation: 0.0,
                        backgroundColor: const Color(0x74F32121),
                        onPressed: () async {
                          bool? result = await _showConfirmResetDialog();
                          if (result != null) {
                            if (result) {
                              context
                                  .read<DefaultSettingBloc>()
                                  .add(const DefaultSettingSaved());
                              context
                                  .read<DefaultSettingBloc>()
                                  .add(const DefaultSettingRequested());
                            }
                          }
                        },
                        child: const Icon(
                          CustomIcons.check,
                        ),
                        //const Text('Save'),
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
                                .read<DefaultSettingBloc>()
                                .add(const EditModeDisabled());
                          },
                          child: const Icon(CustomIcons.cancel)),
                    ],
                  )
                : FloatingActionButton(
                    elevation: 0.0,
                    backgroundColor: const Color(0x742195F3),
                    onPressed: () {
                      context
                          .read<DefaultSettingBloc>()
                          .add(const EditModeEnabled());
                    },
                    child: const Icon(Icons.edit),
                  )
            : Container();
      },
    );
  }
}
