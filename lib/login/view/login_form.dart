import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/login/bloc/login_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showFailureDialog(String errmsg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitle_error,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
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

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          _showFailureDialog(state.errmsg);
        }
      },
      child: Align(
        alignment: const Alignment(0, -0.32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //const Padding(padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0)),
            const SizedBox(
              height: 90,
              child: Image(
                image: AssetImage('assets/ricoms_logo.png'),
                fit: BoxFit.cover,
              ),
            ),
            const Padding(padding: EdgeInsets.all(22)),
            SizedBox(
              width: 230,
              //padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 32.0,
                    child: Image.asset('assets/login_ip_icon.png'),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 32.0,
                      child: _IPInput(),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            SizedBox(
              width: 230,
              //padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 32.0,
                    child: Image.asset('assets/login_username_icon.png'),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 32.0,
                      child: _UsernameInput(),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            SizedBox(
              width: 230,
              //padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 32.0,
                    child: Image.asset('assets/login_password_icon.png'),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 32.0,
                      child: _PasswordInput(),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(20)),
            _LoginButton(),
          ],
        ),
      ),
    );
  }
}

class _IPInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.ip != current.ip ||
          previous.status !=
              current.status /*isSubmissionInProgress -> disable*/,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_ipInput_textField'),
          style: const TextStyle(fontSize: 16),
          enabled: state.status.isSubmissionInProgress ? false : true,
          textInputAction: TextInputAction.done,
          onChanged: (ip) => context.read<LoginBloc>().add(LoginIPChanged(ip)),
          decoration: InputDecoration(
            border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            contentPadding: const EdgeInsets.all(5),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            hintText: AppLocalizations.of(context)!.loginServerIP,
            hintStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            //errorText: state.ip.invalid ? 'Invalid IP' : null,
          ),
        );
      },
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.username != current.username ||
          previous.status !=
              current.status /*isSubmissionInProgress -> disable*/,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_usernameInput_textField'),
          style: const TextStyle(fontSize: 16),
          enabled: state.status.isSubmissionInProgress ? false : true,
          textInputAction: TextInputAction.done,
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
          decoration: InputDecoration(
            border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            contentPadding: const EdgeInsets.all(5),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            hintText: AppLocalizations.of(context)!.loginUserID,
            hintStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            //errorText: state.username.invalid ? 'Invalid User ID' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.passwordVisibility != current.passwordVisibility ||
          previous.status !=
              current.status /*isSubmissionInProgress -> disable*/,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          style: const TextStyle(fontSize: 16),
          enabled: state.status.isSubmissionInProgress ? false : true,
          textInputAction: TextInputAction.done,
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: !state.passwordVisibility,
          decoration: InputDecoration(
            border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            contentPadding: const EdgeInsets.all(5),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            hintText: AppLocalizations.of(context)!.loginPassword,
            hintStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            //errorText: state.password.invalid ? 'Invalid Password' : null,
            suffixIconConstraints: const BoxConstraints(
                maxHeight: 30, maxWidth: 30, minHeight: 30, minWidth: 30),
            suffixIcon: IconButton(
              iconSize: 20,
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0),
              icon: state.passwordVisibility
                  ? const Icon(Icons.visibility_outlined)
                  : const Icon(Icons.visibility_off_outlined),
              onPressed: () {
                context
                    .read<LoginBloc>()
                    .add(const LoginPasswordVisibilityChanged());
              },
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: 200,
                height: 50,
                child: IconButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  icon: state.status.isValidated
                      ? Image.asset('assets/login_button_icon.png')
                      : Image.asset('assets/login_button_disable.png'),
                  onPressed: state.status.isValidated
                      ? () {
                          context.read<LoginBloc>().add(const LoginSubmitted());
                        }
                      : null,
                ),
              );
      },
    );
  }
}
