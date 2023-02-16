import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/advanced/bloc/device_working_cycle/device_working_cycle_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/repository/device_working_cycle_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class DeviceWorkingCycleForm extends StatelessWidget {
  const DeviceWorkingCycleForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showInProgressDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitle_saving,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: const <Widget>[
              CircularProgressIndicator(),
            ],
          );
        },
      );
    }

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

    return BlocListener<DeviceWorkingCycleBloc, DeviceWorkingCycleState>(
      listener: (context, state) {
        if (state.submissionStatus.isSubmissionSuccess) {
          Navigator.of(context).pop(); // pop dialog
          _showSuccessDialog();
        } else if (state.submissionStatus.isSubmissionFailure) {
          Navigator.of(context).pop(); // pop dialog
          _showFailureDialog(state.submissionErrorMsg);
        } else if (state.submissionStatus.isSubmissionInProgress) {
          _showInProgressDialog();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.deviceWorkingCycle,
          ),
          elevation: 0.0,
        ),
        body: const _DeviceWorkingCycleContent(),
        floatingActionButton:
            const _DeviceWorkingCycleEditFloatingActionButton(),
      ),
    );
  }
}

class _DeviceWorkingCycleContent extends StatelessWidget {
  const _DeviceWorkingCycleContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceWorkingCycleBloc, DeviceWorkingCycleState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status.isRequestSuccess) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0),
              ),
              _DeviceWorkingCycleTitle(),
              _DeviceWorkingCycleDropDownMenu(),
            ],
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

class _DeviceWorkingCycleTitle extends StatelessWidget {
  const _DeviceWorkingCycleTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 14.0),
      child: Row(
        children: [
          Text(
            AppLocalizations.of(context)!.deviceWorkingCycle,
          ),
        ],
      ),
    );
  }
}

class _DeviceWorkingCycleDropDownMenu extends StatelessWidget {
  const _DeviceWorkingCycleDropDownMenu({
    Key? key,
  }) : super(key: key);

  final Map<String, int> types = const {
    'Administrator': 2,
    'Operator': 3,
    'User': 4,
    'Disabled': 5,
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceWorkingCycleBloc, DeviceWorkingCycleState>(
        buildWhen: (previous, current) =>
            previous.isEditing != current.isEditing ||
            previous.deviceWorkingCycleIndex != current.deviceWorkingCycleIndex,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SizedBox(
              //width: 230,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  alignment: AlignmentDirectional.centerEnd,
                  buttonPadding: const EdgeInsets.only(left: 5, right: 5),
                  buttonHeight: 32,
                  buttonDecoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade700,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                    color:
                        state.isEditing ? Colors.white : Colors.grey.shade300,
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconDisabledColor: Colors.grey.shade700,
                  value: state.deviceWorkingCycleIndex,
                  items: [
                    for (DeviceWorkingCycle deviceWorkingCycle
                        in state.deviceWorkingCycleList)
                      DropdownMenuItem(
                        value: deviceWorkingCycle.index,
                        child: Text(
                          deviceWorkingCycle.name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: CommonStyle.sizeL,
                            color: state.isEditing
                                ? Colors.black
                                : Colors.grey.shade700,
                          ),
                        ),
                      )
                  ],
                  onChanged: state.isEditing
                      ? (String? value) {
                          if (value != null) {
                            context
                                .read<DeviceWorkingCycleBloc>()
                                .add(DeviceWorkingCycleChanged(value));
                          }
                        }
                      : null,
                ),
              ),
            ),
          );
        });
  }
}

class _DeviceWorkingCycleEditFloatingActionButton extends StatelessWidget {
  const _DeviceWorkingCycleEditFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map _userFunctionMap =
        context.read<AuthenticationBloc>().state.userFunctionMap;

    return BlocBuilder<DeviceWorkingCycleBloc, DeviceWorkingCycleState>(
      builder: (context, state) {
        if (state.status.isRequestSuccess) {
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
                                .read<DeviceWorkingCycleBloc>()
                                .add(const DeviceWorkingCycleSaved());
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
                                  .read<DeviceWorkingCycleBloc>()
                                  .add(const EditModeDisabled());

                              context
                                  .read<DeviceWorkingCycleBloc>()
                                  .add(const DeviceWorkingCycleRequested());
                            },
                            child: const Icon(CustomIcons.cancel)),
                      ],
                    )
                  : FloatingActionButton(
                      elevation: 0.0,
                      backgroundColor: const Color(0x742195F3),
                      onPressed: () {
                        context
                            .read<DeviceWorkingCycleBloc>()
                            .add(const EditModeEnabled());
                      },
                      child: const Icon(Icons.edit),
                    )
              : Container();
        } else {
          return Container();
        }
      },
    );
  }
}
