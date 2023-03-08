import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/root/bloc/edit_group/edit_group_bloc.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class GroupEditForm extends StatelessWidget {
  const GroupEditForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showInProgressDialog(bool isEditing) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: isEditing
                ? Text(
                    AppLocalizations.of(context)!.dialogTitle_saving,
                  )
                : Text(
                    AppLocalizations.of(context)!.dialogTitle_creating,
                  ),
            actionsAlignment: MainAxisAlignment.center,
            actions: const <Widget>[
              CircularProgressIndicator(),
            ],
          );
        },
      );
    }

    Future<void> _showSuccessDialog(bool isEditing, String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: isEditing
                ? Text(
                    AppLocalizations.of(context)!.dialogTitle_editSuccess,
                    style: const TextStyle(
                      color: CustomStyle.customGreen,
                    ),
                  )
                : Text(
                    AppLocalizations.of(context)!.dialogTitle_createSuccess,
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

                  isEditing ? null : Navigator.of(context).pop(); // // pop form
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
            title: const Text(
              CustomErrTitle.commonErrTitle,
              style: TextStyle(
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

    TextEditingController _nameController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();

    return BlocListener<EditGroupBloc, EditGroupState>(
      listener: ((context, state) async {
        if (state.status.isSubmissionInProgress) {
          await _showInProgressDialog(state.isEditing);
        } else if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
          _showSuccessDialog(state.isEditing, state.msg);
        } else if (state.status.isSubmissionFailure) {
          Navigator.of(context).pop();
          _showFailureDialog(state.msg);
        } else if (state.isInitController) {
          if (state.isEditing) {
            _nameController.text = state.name.value;
            _descriptionController.text = state.description;
          } else {}
        }
      }),
      child: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
              ),
              const _ParentName(),
              _NameInput(
                nameController: _nameController,
              ),
              _DescriptionInput(
                descriptionController: _descriptionController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _CancelButton(),
                  _SubmitButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ParentName extends StatelessWidget {
  const _ParentName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditGroupBloc, EditGroupState>(
        buildWhen: (previous, current) =>
            previous.parentName != current.parentName,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(CommonStyle.lineSpacing),
            child: SizedBox(
              width: 230,
              //padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: TextFormField(
                key: const Key('groupEditForm_parentNameInput_textField'),
                enabled: false,
                initialValue: state.parentName == 'Root'
                    ? AppLocalizations.of(context)!.root
                    : state.parentName,
                textInputAction: TextInputAction.done,
                style: const TextStyle(
                  fontSize: CommonStyle.sizeL,
                ),
                onChanged: (name) {
                  context.read<EditGroupBloc>().add(NameChanged(name));
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(5),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  labelText: AppLocalizations.of(context)!.parent,
                  labelStyle: const TextStyle(
                    fontSize: CommonStyle.sizeL,
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({Key? key, required this.nameController}) : super(key: key);

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditGroupBloc, EditGroupState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(3),
          child: SizedBox(
            width: 230,
            //padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: TextFormField(
              key: const Key('groupEditForm_nameInput_textField'),
              controller: nameController,
              textInputAction: TextInputAction.done,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (name) {
                context.read<EditGroupBloc>().add(NameChanged(name));
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                labelText: AppLocalizations.of(context)!.name,
                labelStyle: TextStyle(
                  fontSize: CommonStyle.sizeL,
                  color: Colors.grey.shade400,
                ),
                errorMaxLines: 2,
                errorStyle: const TextStyle(fontSize: CommonStyle.sizeS),
                errorText: state.name.invalid
                    ? 'The name must be between 1-64 characters long.'
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  const _DescriptionInput({Key? key, required this.descriptionController})
      : super(key: key);

  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditGroupBloc, EditGroupState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(6),
          child: SizedBox(
            width: 230,
            //padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: TextFormField(
              key: const Key('groupEditForm_descriptionInput_textField'),
              maxLength: 1024,
              controller: descriptionController,
              textInputAction: TextInputAction.done,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (description) => context
                  .read<EditGroupBloc>()
                  .add(DescriptionChanged(description)),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                labelText: AppLocalizations.of(context)!.description,
                labelStyle: TextStyle(
                  fontSize: CommonStyle.sizeL,
                  color: Colors.grey.shade400,
                ),
                counterText: '',
              ),
            ),
          ),
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
            primary: Colors.white,
            shape: const RoundedRectangleBorder(
                side: BorderSide(width: 1.0, color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          key: const Key('groupEditForm_cancel_raisedButton'),
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

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditGroupBloc, EditGroupState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(6),
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
            key: const Key('groupEditForm_submit_raisedButton'),
            child: state.isEditing
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
            onPressed: state.isEditing
                ? state.status.isValidated
                    ? () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        context
                            .read<EditGroupBloc>()
                            .add(const NodeUpdateSubmitted());
                      }
                    : null
                : state.status.isValidated
                    ? () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        context
                            .read<EditGroupBloc>()
                            .add(const NodeCreationSubmitted());
                      }
                    : null,
          ),
        );
      },
    );
  }
}
