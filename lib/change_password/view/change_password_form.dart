import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/change_password/bloc/change_password_bloc.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showSuccessDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Please login again.'),
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

    Future<void> _showFailureDialog(String errmsg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(errmsg),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) async {
        if (state.status.isSubmissionSuccess) {
          // ScaffoldMessenger.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(
          //     const SnackBar(content: Text('Update, Please login again')),
          //   );
          await _showSuccessDialog();
          Navigator.of(context).pop(true); //pop this page
        } else if (state.status.isSubmissionFailure) {
          _showFailureDialog(state.errmsg);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CurrentPasswordInput(),
          const Padding(padding: EdgeInsets.all(12)),
          _NewPasswordInput(),
          const Padding(padding: EdgeInsets.all(12)),
          _ConfirmPasswordInput(),
          const Padding(padding: EdgeInsets.all(12)),
          // const Expanded(
          //   child: SizedBox(),
          // ),
          _SaveButton(),
          const Padding(padding: EdgeInsets.all(12)),
        ],
      ),
    );
  }
}

class _CurrentPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) =>
          previous.currentPassword != current.currentPassword ||
          previous.currentPasswordVisibility !=
              current.currentPasswordVisibility,
      builder: (context, state) {
        return TextField(
          key: const Key('changePasswordForm_currentPasswordInput_textField'),
          textInputAction: TextInputAction.done,
          onChanged: (password) => context
              .read<ChangePasswordBloc>()
              .add(CurrentPasswordChanged(password)),
          obscureText: !state.currentPasswordVisibility,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              labelText: 'Current password',
              errorText: state.currentPassword.invalid
                  ? 'invalid current password'
                  : null,
              suffixIcon: IconButton(
                icon: state.currentPasswordVisibility
                    ? const Icon(Icons.visibility_outlined)
                    : const Icon(Icons.visibility_off_outlined),
                onPressed: () {
                  context
                      .read<ChangePasswordBloc>()
                      .add(const CurrentPasswordVisibilityChanged());
                },
              )),
        );
      },
    );
  }
}

class _NewPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) =>
          previous.newPassword != current.newPassword ||
          previous.newPasswordVisibility != current.newPasswordVisibility,
      builder: (context, state) {
        return TextField(
          key: const Key('changePasswordForm_newPasswordInput_textField'),
          textInputAction: TextInputAction.done,
          onChanged: (password) => context
              .read<ChangePasswordBloc>()
              .add(NewPasswordChanged(password)),
          obscureText: !state.newPasswordVisibility,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              labelText: 'New password',
              errorText:
                  state.newPassword.invalid ? 'invalid new password' : null,
              suffixIcon: IconButton(
                icon: state.newPasswordVisibility
                    ? const Icon(Icons.visibility_outlined)
                    : const Icon(Icons.visibility_off_outlined),
                onPressed: () {
                  context
                      .read<ChangePasswordBloc>()
                      .add(const NewPasswordVisibilityChanged());
                },
              )),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) =>
          previous.confirmPassword != current.confirmPassword ||
          previous.confirmPasswordVisibility !=
              current.confirmPasswordVisibility,
      builder: (context, state) {
        return TextField(
          key: const Key('changePasswordForm_confirmPasswordInput_textField'),
          textInputAction: TextInputAction.done,
          onChanged: (password) => context
              .read<ChangePasswordBloc>()
              .add(ConfirmPasswordChanged(password)),
          obscureText: !state.confirmPasswordVisibility,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              labelText: 'Confirm password',
              errorText: state.confirmPassword.invalid
                  ? 'invalid confirm password'
                  : null,
              suffixIcon: IconButton(
                icon: state.confirmPasswordVisibility
                    ? const Icon(Icons.visibility_outlined)
                    : const Icon(Icons.visibility_off_outlined),
                onPressed: () {
                  context
                      .read<ChangePasswordBloc>()
                      .add(const ConfirmPasswordVisibilityChanged());
                },
              )),
        );
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
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
                key: const Key('changePasswordForm_save_raisedButton'),
                child: const Text('Save Change'),
                onPressed: state.status.isValidated
                    ? () {
                        context
                            .read<ChangePasswordBloc>()
                            .add(const PasswordSubmitted());
                      }
                    : null,
              );
      },
    );
  }
}
