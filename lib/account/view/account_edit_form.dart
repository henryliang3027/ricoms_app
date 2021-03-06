import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/account/bloc/edit_account/edit_account_bloc.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';

class AccountEditForm extends StatelessWidget {
  const AccountEditForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _accountController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _departmentController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _mobileController = TextEditingController();
    TextEditingController _telController = TextEditingController();
    TextEditingController _extController = TextEditingController();

    Future<void> _showInProgressDialog(bool isEditing) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Saving...'),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              CircularProgressIndicator(),
            ],
          );
        },
      );
    }

    Future<void> _showSuccessDialog(
      bool isEditing,
      String msg,
    ) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: isEditing
                ? Text(
                    'Saved!',
                    style: TextStyle(color: CustomStyle.severityColor[1]),
                  )
                : Text(
                    'Created!',
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
                  Navigator.of(context).pop(); // pop dialog
                  Navigator.of(context).pop(); // pop form
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
          await _showInProgressDialog(state.isEditing);
        } else if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
          _showSuccessDialog(state.isEditing, state.submissionMsg);
        } else if (state.isEditing) {
          _accountController.text = state.account.value;
          _nameController.text = state.name.value;
          _departmentController.text = state.department;
          _emailController.text = state.email;
          _mobileController.text = state.mobile;
          _telController.text = state.tel;
          _extController.text = state.ext;
        }
      },
      child: Container(
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
              const _PermissionDropDownMenu(),
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
              const _SaveButton(),
            ],
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
                labelText: 'Account',
                labelStyle: TextStyle(
                  fontSize: CommonStyle.sizeL,
                  color: Colors.grey.shade400,
                ),
                errorMaxLines: 2,
                errorStyle: const TextStyle(fontSize: CommonStyle.sizeS),
                errorText: state.account.invalid
                    ? 'The account must be between 1-32 characters long.'
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
              obscuringCharacter: '???',
              maxLength: 32,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                counterText: '',
                hintText: 'Current password',
                hintStyle: TextStyle(
                  fontSize: CommonStyle.sizeL,
                  color: Colors.grey.shade400,
                ),
                errorMaxLines: 2,
                errorStyle: const TextStyle(fontSize: CommonStyle.sizeS),
                errorText: state.password.invalid
                    ? 'Password must be between 4-32 characters.'
                    : null,
                suffixIconConstraints: const BoxConstraints(
                    maxHeight: 36, maxWidth: 36, minHeight: 36, minWidth: 36),
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
                labelText: 'Name',
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

class _PermissionDropDownMenu extends StatelessWidget {
  const _PermissionDropDownMenu({Key? key}) : super(key: key);

  final Map<String, int> types = const {
    'Operator': 3,
    'Administrator': 2,
    'User': 4,
    'Disabled': 5,
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAccountBloc, EditAccountState>(
        buildWhen: (previous, current) =>
            previous.permission != current.permission,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(CommonStyle.lineSpacing),
            child: SizedBox(
              width: 230,
              child: DropdownButtonFormField2(
                  alignment: AlignmentDirectional.centerEnd,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.all(5),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade700,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  //isDense: true,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  value: state.permission,
                  items: [
                    for (String k in types.keys)
                      DropdownMenuItem(
                        value: types[k],
                        child: Text(
                          k,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: CommonStyle.sizeL,
                            color: Colors.black,
                          ),
                        ),
                      )
                  ],
                  onChanged: (int? value) {
                    if (value != null) {
                      context
                          .read<EditAccountBloc>()
                          .add(PermissionChanged(value));
                    }
                  }),
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
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Department',
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
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (email) {
                context.read<EditAccountBloc>().add(EmailChanged(email));
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Email',
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
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (mobile) {
                context.read<EditAccountBloc>().add(MobileChanged(mobile));
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Phone',
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
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (tel) {
                context.read<EditAccountBloc>().add(TelChanged(tel));
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Tel',
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
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (ext) {
                context.read<EditAccountBloc>().add(ExtChanged(ext));
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Ext',
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

class _SaveButton extends StatelessWidget {
  const _SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAccountBloc, EditAccountState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.status != current.status,
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
            key: const Key('accountEditForm_submit_raisedButton'),
            child: state.isEditing
                ? const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: CommonStyle.sizeM,
                    ),
                  )
                : const Text(
                    'Create',
                    style: TextStyle(
                      fontSize: CommonStyle.sizeM,
                    ),
                  ),
            onPressed: state.isEditing
                ? state.status.isValidated
                    ? () {
                        // context
                        //     .read<EditAccountBloc>()
                        //     .add(const NodeUpdateSubmitted());
                      }
                    : null
                : state.status.isValidated
                    ? () {
                        // context
                        //     .read<EditAccountBloc>()
                        //     .add(const NodeCreationSubmitted());
                      }
                    : null,
          ),
        );
      },
    );
  }
}
