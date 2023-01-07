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

    return BlocListener<DefaultSettingBloc, DefaultSettingState>(
      listener: (context, state) {
        if (state.status.isRequestSuccess) {
        } else if (state.status.isRequestFailure) {
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
            AppLocalizations.of(context)!.deviceWorkingCycle,
          ),
          elevation: 0.0,
        ),
        body: const SingleChildScrollView(
          child: _DefaultSettingContent(),
        ),
        floatingActionButton: const _DefaultSettingEditFloatingActionButton(),
      ),
    );
  }
}

class _SettingTitle extends StatelessWidget {
  const _SettingTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
        right: 30.0,
        top: 30.0,
        bottom: 10.0,
      ),
      child: Row(
        children: [
          Text(
            title,
          ),
        ],
      ),
    );
  }
}

class _DefaultSettingContent extends StatelessWidget {
  const _DefaultSettingContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildDefaultSettingCustomTile({
      required String name,
      required int index,
      required bool isEditing,
      required DefaultSettingItem defaultSettingItem,
      required Function onSelect,
    }) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 30.0,
          right: 30.0,
          top: 10.0,
          bottom: 10.0,
        ),
        child: Material(
          child: InkWell(
              onTap: isEditing
                  ? () {
                      context
                          .read<DefaultSettingBloc>()
                          .add(DefaultSettingItemToggled(index));
                    }
                  : null,
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
                            fontSize: CommonStyle.sizeL,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.defaultValue,
                      ),
                      Text(
                        defaultSettingItem.defaultValue,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.currentValue,
                      ),
                      Text(
                        defaultSettingItem.currentValue,
                      ),
                    ],
                  ),
                ],
              )),
        ),
      );
    }

    return BlocBuilder<DefaultSettingBloc, DefaultSettingState>(
      builder: (context, state) {
        if (state.status.isRequestSuccess) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SettingTitle(
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
              _SettingTitle(
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
              _SettingTitle(
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
              _SettingTitle(
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
              _SettingTitle(
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
            ],
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

class _DefaultSettingListItem extends StatelessWidget {
  const _DefaultSettingListItem({
    Key? key,
    required this.index,
    required this.name,
  }) : super(key: key);

  final int index;
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DefaultSettingBloc, DefaultSettingState>(
      builder: (context, state) {
        if (state.status.isRequestSuccess) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Material(
              child: InkWell(
                  onTap: state.isEditing
                      ? () {
                          context
                              .read<DefaultSettingBloc>()
                              .add(DefaultSettingItemToggled(index));
                        }
                      : null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.deviceWorkingCycle,
                            style: const TextStyle(
                              fontSize: CommonStyle.sizeL,
                            ),
                          ),
                          state.isEditing
                              ? state.defaultSettingItems[index].isSelected
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.defaultValue,
                          ),
                          Text(
                            state.defaultSettingItems[index].defaultValue,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.currentValue,
                          ),
                          Text(
                            state.defaultSettingItems[index].currentValue,
                          ),
                        ],
                      ),
                    ],
                  )),
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
                        backgroundColor: const Color(0x742195F3),
                        onPressed: () {
                          context
                              .read<DefaultSettingBloc>()
                              .add(const DefaultSettingSaved());
                        },
                        child: const Icon(CustomIcons.check),
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
                            context
                                .read<DefaultSettingBloc>()
                                .add(const DefaultSettingRequested());
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
