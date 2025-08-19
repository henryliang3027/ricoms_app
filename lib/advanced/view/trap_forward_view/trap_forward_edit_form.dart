import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/advanced/bloc/edit_trap_forward/edit_trap_forward_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_forward_repository/forward_detail.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_forward_repository/forward_outline.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class TrapForwardEditForm extends StatelessWidget {
  const TrapForwardEditForm({
    Key? key,
    required bool isEditing,
    ForwardOutline? forwardOutline,
  })  : _isEditing = isEditing,
        super(key: key);

  final bool _isEditing;

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _ipController = TextEditingController();

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

    Future<void> _showSuccessDialog(
      String msg,
    ) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: _isEditing
                ? Text(
                    AppLocalizations.of(context)!
                        .dialogTitle_editAccountSuccessfully,
                    style: const TextStyle(color: CustomStyle.customGreen),
                  )
                : Text(
                    AppLocalizations.of(context)!
                        .dialogTitle_addAccountSuccessfully,
                    style: const TextStyle(color: CustomStyle.customGreen),
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
                  if (_isEditing) {
                    Navigator.of(context).pop(); // pop dialog
                  } else {
                    Navigator.of(context).pop(); // pop dialog
                    Navigator.of(context).pop(true); // pop form
                  }
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

    return BlocListener<EditTrapForwardBloc, EditTrapForwardState>(
      listener: (context, state) async {
        if (state.status.isSubmissionInProgress) {
          await _showInProgressDialog();
        } else if (state.submissionStatus.isSubmissionSuccess) {
          _showSuccessDialog(state.submissionMsg);
        } else if (state.submissionStatus.isSubmissionFailure) {
          _showFailureDialog(state.submissionMsg);
        } else if (state.isInitController) {
          _nameController.text = state.name.value;
          _ipController.text = state.ip.value;
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          bool isModify = context.read<EditTrapForwardBloc>().state.isModify;
          Navigator.of(context).pop(isModify);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            title: _isEditing
                ? Text(
                    AppLocalizations.of(context)!.editTrapForward,
                  )
                : Text(
                    AppLocalizations.of(context)!.addTrapForward,
                  ),
          ),
          body: SafeArea(
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    const _EnableSwitchListTile(),
                    _NameInput(nameController: _nameController),
                    _IPInput(nameController: _ipController),
                    const _ParametersSwitchListTile(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _CancelButton(),
                        _SaveButton(
                          isEditing: _isEditing,
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EnableSwitchListTile extends StatelessWidget {
  const _EnableSwitchListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTrapForwardBloc, EditTrapForwardState>(
      buildWhen: (previous, current) => previous.enable != current.enable,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(CommonStyle.lineSpacing),
          child: Container(
            width: 320,
            decoration: BoxDecoration(
                color: const Color(0xfffbfbfb),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0)),
            child: SwitchListTile(
              title: const Text('Enable'),
              visualDensity: const VisualDensity(vertical: -4.0),
              contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              value: state.enable,
              onChanged: (bool value) {
                context
                    .read<EditTrapForwardBloc>()
                    .add(ForwardEnabledChanged(value));
              },
            ),
          ),
        );
      },
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({Key? key, required this.nameController}) : super(key: key);

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTrapForwardBloc, EditTrapForwardState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(CommonStyle.lineSpacing),
          child: SizedBox(
            width: 320,
            child: TextFormField(
              key: const Key('trapForwardEditForm_nameInput_textField'),
              controller: nameController,
              textInputAction: TextInputAction.done,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (name) {
                context.read<EditTrapForwardBloc>().add(NameChanged(name));
              },
              maxLength: 64,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                counterText: '',
                labelText: AppLocalizations.of(context)!.name,
                labelStyle: TextStyle(
                  fontSize: CommonStyle.sizeL,
                  color: Colors.grey.shade400,
                ),
                errorMaxLines: 2,
                errorStyle: const TextStyle(fontSize: CommonStyle.sizeS),
                errorText: state.name.invalid
                    ? AppLocalizations.of(context)!.nameErrorText
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _IPInput extends StatelessWidget {
  const _IPInput({Key? key, required this.nameController}) : super(key: key);

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTrapForwardBloc, EditTrapForwardState>(
      buildWhen: (previous, current) => previous.ip != current.ip,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(CommonStyle.lineSpacing),
          child: SizedBox(
            width: 320,
            child: TextFormField(
              key: const Key('trapForwardEditForm_ipInput_textField'),
              controller: nameController,
              textInputAction: TextInputAction.done,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (ip) {
                context.read<EditTrapForwardBloc>().add(IPChanged(ip));
              },
              maxLength: 64,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                counterText: '',
                labelText: AppLocalizations.of(context)!.ip,
                labelStyle: TextStyle(
                  fontSize: CommonStyle.sizeL,
                  color: Colors.grey.shade400,
                ),
                errorMaxLines: 2,
                errorStyle: const TextStyle(fontSize: CommonStyle.sizeS),
                errorText: state.ip.invalid
                    ? AppLocalizations.of(context)!.ipErrorText
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ParametersSwitchListTile extends StatelessWidget {
  const _ParametersSwitchListTile({Key? key}) : super(key: key);

  Widget _buildParameterSwitchTile(
    BuildContext context,
    Parameter parameter,
    int indexOfParameter,
  ) {
    bool isChecked = parameter.checked == 0 ? false : true;

    return Padding(
      padding: const EdgeInsets.all(CommonStyle.lineSpacing),
      child: Container(
        width: 320,
        decoration: BoxDecoration(
            color: const Color(0xfffbfbfb),
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4.0)),
        child: SwitchListTile(
          title: Text(parameter.name),
          visualDensity: const VisualDensity(vertical: -4.0),
          value: isChecked,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          onChanged: (bool value) {
            context
                .read<EditTrapForwardBloc>()
                .add(ParametersChanged(indexOfParameter, value));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTrapForwardBloc, EditTrapForwardState>(
      buildWhen: (previous, current) =>
          previous.parameters != current.parameters,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < state.parameters.length; i++) ...[
              _buildParameterSwitchTile(
                context,
                state.parameters[i],
                i,
              )
            ]
          ],
        );
      },
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(CommonStyle.lineSpacing),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                side: BorderSide(width: 1.0, color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          key: const Key('trapForwardEditForm_cancel_raisedButton'),
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: const TextStyle(
              fontSize: CommonStyle.sizeM,
              color: Colors.black,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    Key? key,
    required this.isEditing,
  }) : super(key: key);

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTrapForwardBloc, EditTrapForwardState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(CommonStyle.lineSpacing),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.blue;
                  } else if (states.contains(MaterialState.disabled)) {
                    return Colors.grey;
                  }
                  return null; // Use the component's default.
                },
              ),
            ),
            key: const Key('trapForwardEditForm_submit_raisedButton'),
            child: state.submissionStatus.isSubmissionInProgress
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : isEditing
                    ? Text(
                        AppLocalizations.of(context)!.save,
                        style: const TextStyle(
                          fontSize: CommonStyle.sizeM,
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context)!.create,
                        style: const TextStyle(
                          fontSize: CommonStyle.sizeM,
                        ),
                      ),
            onPressed: isEditing
                ? state.status.isValidated
                    ? () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        context
                            .read<EditTrapForwardBloc>()
                            .add(const ForwardDetailUpdateSubmitted());
                      }
                    : null
                : state.status.isValidated
                    ? () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        context
                            .read<EditTrapForwardBloc>()
                            .add(const ForwardDetailCreateSubmitted());
                      }
                    : null,
          ),
        );
      },
    );
  }
}
