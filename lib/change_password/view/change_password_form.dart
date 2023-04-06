import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/change_password/bloc/change_password_bloc.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/utils/message_localization.dart';

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
            title: Text(
              AppLocalizations.of(context)!.update,
              style: const TextStyle(
                color: CustomStyle.customGreen,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!
                        .dialogMessage_changePasswordSuccessfully,
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

    Future<void> _showFailureDialog(String errmsg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.dialogTitle_error,
                style: const TextStyle(
                  color: CustomStyle.customRed,
                )),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    getMessageLocalization(
                      msg: errmsg,
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
      child: Align(
        alignment: const Alignment(0, -0.42),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 230,
              //padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: _CurrentPasswordInput(),
            ),

            const Padding(padding: EdgeInsets.all(6)),
            SizedBox(
              width: 230,
              //padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: _NewPasswordInput(),
            ),

            const Padding(padding: EdgeInsets.all(6)),

            SizedBox(
              width: 230,
              //padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: _ConfirmPasswordInput(),
            ),

            const Padding(padding: EdgeInsets.all(16)),
            // const Expanded(
            //   child: SizedBox(),
            // ),
            _SaveButton(),
            //const Padding(padding: EdgeInsets.all(50)),
          ],
        ),
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
          style: const TextStyle(
            fontSize: CommonStyle.sizeL,
          ),
          onChanged: (password) => context
              .read<ChangePasswordBloc>()
              .add(CurrentPasswordChanged(password)),
          obscureText: !state.currentPasswordVisibility,
          obscuringCharacter: '●',
          maxLength: 32,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border: const OutlineInputBorder(),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            counterText: '',
            hintText: AppLocalizations.of(context)!.currentPassword,
            hintStyle: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
            errorMaxLines: 2,
            errorStyle: const TextStyle(fontSize: CommonStyle.sizeS),
            errorText: state.currentPassword.invalid
                ? AppLocalizations.of(context)!.passwordErrorText
                : null,
            helperText: AppLocalizations.of(context)!.currentPasswordHelperText,
            helperStyle: const TextStyle(fontSize: CommonStyle.sizeS),
            suffixIconConstraints: const BoxConstraints(
                maxHeight: 36, maxWidth: 36, minHeight: 36, minWidth: 36),
            suffixIcon: IconButton(
              iconSize: 22,
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0),
              icon: state.currentPasswordVisibility
                  ? const Icon(Icons.visibility_outlined)
                  : const Icon(Icons.visibility_off_outlined),
              onPressed: () {
                context
                    .read<ChangePasswordBloc>()
                    .add(const CurrentPasswordVisibilityChanged());
              },
            ),
          ),
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
          style: const TextStyle(
            fontSize: CommonStyle.sizeL,
          ),
          textInputAction: TextInputAction.done,
          onChanged: (password) => context
              .read<ChangePasswordBloc>()
              .add(NewPasswordChanged(password)),
          obscureText: !state.newPasswordVisibility,
          obscuringCharacter: '●',
          maxLength: 32,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5),
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              counterText: '',
              hintText: AppLocalizations.of(context)!.newPassword,
              hintStyle: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              errorMaxLines: 2,
              errorStyle: const TextStyle(fontSize: CommonStyle.sizeS),
              errorText: state.newPassword.invalid
                  ? AppLocalizations.of(context)!.passwordErrorText
                  : null,
              helperText: AppLocalizations.of(context)!.newPasswordHelperText,
              helperStyle: const TextStyle(fontSize: CommonStyle.sizeS),
              suffixIconConstraints: const BoxConstraints(
                  maxHeight: 36, maxWidth: 36, minHeight: 36, minWidth: 36),
              suffixIcon: IconButton(
                iconSize: 22,
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0),
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
          style: const TextStyle(
            fontSize: CommonStyle.sizeL,
          ),
          textInputAction: TextInputAction.done,
          onChanged: (password) => context
              .read<ChangePasswordBloc>()
              .add(ConfirmPasswordChanged(password)),
          obscureText: !state.confirmPasswordVisibility,
          obscuringCharacter: '●',
          maxLength: 32,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5),
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              counterText: '',
              hintText: AppLocalizations.of(context)!.confirmPassword,
              hintStyle: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              errorMaxLines: 2,
              errorStyle: const TextStyle(fontSize: CommonStyle.sizeS),
              errorText: state.confirmPassword.invalid
                  ? AppLocalizations.of(context)!.passwordErrorText
                  : null,
              helperText:
                  AppLocalizations.of(context)!.confirmPasswordHelperText,
              helperStyle: const TextStyle(fontSize: CommonStyle.sizeS),
              suffixIconConstraints: const BoxConstraints(
                  maxHeight: 36, maxWidth: 36, minHeight: 36, minWidth: 36),
              suffixIcon: IconButton(
                iconSize: 22,
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0),
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
                key: const Key('changePasswordForm_save_raisedButton'),
                child: Text(
                  AppLocalizations.of(context)!.update,
                  style: const TextStyle(
                    fontSize: CommonStyle.sizeM,
                  ),
                ),
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
