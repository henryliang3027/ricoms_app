import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/account/bloc/edit_account/edit_account_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/account_outline.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountEditForm extends StatelessWidget {
  const AccountEditForm({
    Key? key,
    required bool isEditing,
    AccountOutline? accountOutline,
  })  : _isEditing = isEditing,
        _accountOutline = accountOutline,
        super(key: key);

  final bool _isEditing;
  final AccountOutline? _accountOutline;

  @override
  Widget build(BuildContext context) {
    TextEditingController _accountController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _departmentController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _mobileController = TextEditingController();
    TextEditingController _telController = TextEditingController();
    TextEditingController _extController = TextEditingController();

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
                    style: TextStyle(color: CustomStyle.severityColor[1]),
                  )
                : Text(
                    AppLocalizations.of(context)!
                        .dialogTitle_addAccountSuccessfully,
                    style: TextStyle(color: CustomStyle.severityColor[1]),
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

    return BlocListener<EditAccountBloc, EditAccountState>(
      listener: (context, state) async {
        if (state.status.isSubmissionInProgress) {
          await _showInProgressDialog();
        } else if (state.submissionStatus.isSubmissionSuccess) {
          _showSuccessDialog(state.submissionMsg);
        } else if (state.submissionStatus.isSubmissionFailure) {
          _showFailureDialog(state.submissionMsg);
        } else if (state.isInitController) {
          _accountController.text = state.account.value;
          _nameController.text = state.name.value;
          _departmentController.text = state.department;
          _emailController.text = state.email.value;
          _mobileController.text = state.mobile.value;
          _telController.text = state.tel.value;
          _extController.text = state.ext.value;
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          bool isModify = context.read<EditAccountBloc>().state.isModify;
          Navigator.of(context).pop(isModify);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            title: _isEditing
                ? Text(
                    AppLocalizations.of(context)!.editAccount,
                  )
                : Text(
                    AppLocalizations.of(context)!.addAccount,
                  ),
          ),
          body: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                  ),
                  _AccountInput(
                    accountController: _accountController,
                  ),
                  const _PasswordInput(),
                  _NameInput(
                    nameController: _nameController,
                  ),
                  _PermissionDropDownMenu(
                    isEditing: _isEditing,
                    accountOutline: _accountOutline,
                  ),
                  _DepartmentInput(
                    departmentController: _departmentController,
                  ),
                  _EmailInput(
                    emailController: _emailController,
                  ),
                  _MobileInput(
                    mobileController: _mobileController,
                  ),
                  _TelInput(
                    telController: _telController,
                  ),
                  _ExtInput(
                    extController: _extController,
                  ),
                  _SaveButton(
                    isEditing: _isEditing,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountInput extends StatelessWidget {
  const _AccountInput({Key? key, required this.accountController})
      : super(key: key);

  final TextEditingController accountController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAccountBloc, EditAccountState>(
      buildWhen: (previous, current) => previous.account != current.account,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(CommonStyle.lineSpacing),
          child: SizedBox(
            width: 230,
            child: TextFormField(
              key: const Key('accountEditForm_accountInput_textField'),
              controller: accountController,
              textInputAction: TextInputAction.done,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (account) {
                context.read<EditAccountBloc>().add(AccountChanged(account));
              },
              maxLength: 32,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                counterText: '',
                labelText: AppLocalizations.of(context)!.account,
                labelStyle: TextStyle(
                  fontSize: CommonStyle.sizeL,
                  color: Colors.grey.shade400,
                ),
                errorMaxLines: 2,
                errorStyle: const TextStyle(fontSize: CommonStyle.sizeS),
                errorText: state.account.invalid
                    ? AppLocalizations.of(context)!.accountErrorText
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAccountBloc, EditAccountState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.passwordVisibility != current.passwordVisibility,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(CommonStyle.lineSpacing),
          child: SizedBox(
            width: 230,
            child: TextField(
              key: const Key('changePasswordForm_PasswordInput_textField'),
              textInputAction: TextInputAction.done,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (password) => context
                  .read<EditAccountBloc>()
                  .add(PasswordChanged(password)),
              obscureText: !state.passwordVisibility,
              obscuringCharacter: '●',
              maxLength: 32,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                counterText: '',
                hintText: AppLocalizations.of(context)!.password,
                hintStyle: TextStyle(
                  fontSize: CommonStyle.sizeL,
                  color: Colors.grey.shade400,
                ),
                errorMaxLines: 2,
                errorStyle: const TextStyle(fontSize: CommonStyle.sizeS),
                errorText: state.password.invalid
                    ? AppLocalizations.of(context)!.passwordErrorText
                    : null,
                suffixIconConstraints: const BoxConstraints(
                    maxHeight: 28, maxWidth: 28, minHeight: 28, minWidth: 28),
                suffixIcon: IconButton(
                  iconSize: 22,
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0),
                  icon: state.passwordVisibility
                      ? const Icon(Icons.visibility_outlined)
                      : const Icon(Icons.visibility_off_outlined),
                  onPressed: () {
                    context
                        .read<EditAccountBloc>()
                        .add(const PasswordVisibilityChanged());
                  },
                ),
              ),
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
    return BlocBuilder<EditAccountBloc, EditAccountState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(CommonStyle.lineSpacing),
          child: SizedBox(
            width: 230,
            child: TextFormField(
              key: const Key('nameEditForm_accountInput_textField'),
              controller: nameController,
              textInputAction: TextInputAction.done,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (name) {
                context.read<EditAccountBloc>().add(NameChanged(name));
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

class _PermissionDropDownMenu extends StatelessWidget {
  const _PermissionDropDownMenu({
    Key? key,
    required bool isEditing,
    AccountOutline? accountOutline,
  })  : _isEditing = isEditing,
        _accountOutline = accountOutline,
        super(key: key);

  final bool _isEditing;
  final AccountOutline? _accountOutline;

  final Map<String, int> types = const {
    'Administrator': 2,
    'Operator': 3,
    'User': 4,
    'Disabled': 5,
  };

  @override
  Widget build(BuildContext context) {
    int currentUserId =
        int.parse(context.read<AuthenticationBloc>().state.user.id);

    bool _isMatchCurrentUser() {
      return _isEditing && currentUserId == _accountOutline!.id;
    }

    return BlocBuilder<EditAccountBloc, EditAccountState>(
        buildWhen: (previous, current) =>
            previous.permission != current.permission,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(CommonStyle.lineSpacing),
            child: SizedBox(
              width: 230,
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
                    color: _isMatchCurrentUser()
                        ? Colors.grey.shade500
                        : Colors.white,
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconDisabledColor: Colors.grey.shade700,
                  value: state.permission,
                  items: [
                    for (String k in types.keys)
                      DropdownMenuItem(
                        value: types[k],
                        child: Text(
                          k,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: CommonStyle.sizeL,
                            color: _isMatchCurrentUser()
                                ? Colors.grey.shade700
                                : Colors.black,
                          ),
                        ),
                      )
                  ],
                  onChanged: _isMatchCurrentUser()
                      ? null
                      : (int? value) {
                          if (value != null) {
                            context
                                .read<EditAccountBloc>()
                                .add(PermissionChanged(value));
                          }
                        },
                ),
              ),
            ),
          );
        });
  }
}

class _DepartmentInput extends StatelessWidget {
  const _DepartmentInput({Key? key, required this.departmentController})
      : super(key: key);

  final TextEditingController departmentController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAccountBloc, EditAccountState>(
      buildWhen: (previous, current) =>
          previous.department != current.department,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(CommonStyle.lineSpacing),
          child: SizedBox(
            width: 230,
            child: TextFormField(
              key: const Key('departmentEditForm_departmentInput_textField'),
              controller: departmentController,
              textInputAction: TextInputAction.done,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (department) {
                context
                    .read<EditAccountBloc>()
                    .add(DepartmentChanged(department));
              },
              maxLength: 64,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                counterText: '',
                labelText: AppLocalizations.of(context)!.department,
                labelStyle: TextStyle(
                  fontSize: CommonStyle.sizeL,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({Key? key, required this.emailController})
      : super(key: key);

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAccountBloc, EditAccountState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(CommonStyle.lineSpacing),
          child: SizedBox(
            width: 230,
            child: TextFormField(
              key: const Key('emailEditForm_emailInput_textField'),
              controller: emailController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (email) {
                context.read<EditAccountBloc>().add(EmailChanged(email));
              },
              maxLength: 64,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                counterText: '',
                labelText: AppLocalizations.of(context)!.email,
                labelStyle: TextStyle(
                  fontSize: CommonStyle.sizeL,
                  color: Colors.grey.shade400,
                ),
                errorMaxLines: 2,
                errorStyle: const TextStyle(fontSize: CommonStyle.sizeS),
                errorText: state.email.invalid
                    ? AppLocalizations.of(context)!.emailErrorText
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MobileInput extends StatelessWidget {
  const _MobileInput({Key? key, required this.mobileController})
      : super(key: key);

  final TextEditingController mobileController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAccountBloc, EditAccountState>(
      buildWhen: (previous, current) => previous.mobile != current.mobile,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(CommonStyle.lineSpacing),
          child: SizedBox(
            width: 230,
            child: TextFormField(
              key: const Key('mobileEditForm_mobileInput_textField'),
              controller: mobileController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (mobile) {
                context.read<EditAccountBloc>().add(MobileChanged(mobile));
              },
              maxLength: 32,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                counterText: '',
                labelText: AppLocalizations.of(context)!.phone,
                labelStyle: TextStyle(
                  fontSize: CommonStyle.sizeL,
                  color: Colors.grey.shade400,
                ),
                errorMaxLines: 2,
                errorStyle: const TextStyle(fontSize: CommonStyle.sizeS),
                errorText: state.mobile.invalid
                    ? AppLocalizations.of(context)!.mobileErrorText
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TelInput extends StatelessWidget {
  const _TelInput({Key? key, required this.telController}) : super(key: key);

  final TextEditingController telController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAccountBloc, EditAccountState>(
      buildWhen: (previous, current) => previous.tel != current.tel,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(CommonStyle.lineSpacing),
          child: SizedBox(
            width: 230,
            child: TextFormField(
              key: const Key('telEditForm_telInput_textField'),
              controller: telController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (tel) {
                context.read<EditAccountBloc>().add(TelChanged(tel));
              },
              maxLength: 32,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                counterText: '',
                labelText: AppLocalizations.of(context)!.tel,
                labelStyle: TextStyle(
                  fontSize: CommonStyle.sizeL,
                  color: Colors.grey.shade400,
                ),
                errorMaxLines: 2,
                errorStyle: const TextStyle(fontSize: CommonStyle.sizeS),
                errorText: state.tel.invalid
                    ? AppLocalizations.of(context)!.telErrorText
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ExtInput extends StatelessWidget {
  const _ExtInput({Key? key, required this.extController}) : super(key: key);

  final TextEditingController extController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAccountBloc, EditAccountState>(
      buildWhen: (previous, current) => previous.ext != current.ext,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(CommonStyle.lineSpacing),
          child: SizedBox(
            width: 230,
            child: TextFormField(
              key: const Key('extEditForm_extInput_textField'),
              controller: extController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (ext) {
                context.read<EditAccountBloc>().add(ExtChanged(ext));
              },
              maxLength: 32,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                counterText: '',
                labelText: AppLocalizations.of(context)!.ext,
                labelStyle: TextStyle(
                  fontSize: CommonStyle.sizeL,
                  color: Colors.grey.shade400,
                ),
                errorMaxLines: 2,
                errorStyle: const TextStyle(fontSize: CommonStyle.sizeS),
                errorText: state.ext.invalid
                    ? AppLocalizations.of(context)!.extErrorText
                    : null,
              ),
            ),
          ),
        );
      },
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
    return BlocBuilder<EditAccountBloc, EditAccountState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(CommonStyle.lineSpacing),
          child: ElevatedButton(
            key: const Key('accountEditForm_submit_raisedButton'),
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
                            .read<EditAccountBloc>()
                            .add(const AccountUpdateSubmitted());
                      }
                    : null
                : state.status.isValidated
                    ? () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        context
                            .read<EditAccountBloc>()
                            .add(const AccountCreationSubmitted());
                      }
                    : null,
          ),
        );
      },
    );
  }
}
