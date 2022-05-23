import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/login/bloc/login_bloc.dart';

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

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          _showFailureDialog(state.errmsg);
        }
      },
      child: Align(
        alignment: const Alignment(0, -0.4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0)),
            const SizedBox(
              height: 90,
              child: Image(
                image: AssetImage('assets/ricoms_logo.png'),
                fit: BoxFit.cover,
              ),
            ),
            const Padding(padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0)),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 60.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 36.0,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Image.asset('assets/login_ip_icon.png'),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 36.0,
                      child: _IPInput(),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 60.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    //height: 40.0,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Image.asset('assets/login_username_icon.png'),
                    ),
                    constraints: const BoxConstraints(
                        minHeight: 0, minWidth: 0, maxHeight: 36, maxWidth: 36),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        //height: 40.0,
                        child: _UsernameInput(),
                        constraints: const BoxConstraints(
                          minHeight: 0,
                          minWidth: 0,
                          maxHeight: 36,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 60.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    //height: 40.0,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Image.asset('assets/login_password_icon.png'),
                    ),
                    constraints: const BoxConstraints(
                        minHeight: 0, minWidth: 0, maxHeight: 36, maxWidth: 36),
                  ),
                  Expanded(
                    child: Container(
                      //height: 40.0,
                      child: _PasswordInput(),
                      constraints: const BoxConstraints(
                        minHeight: 0,
                        minWidth: 0,
                        maxHeight: 36,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
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
          textAlignVertical: TextAlignVertical.bottom,
          style: TextStyle(fontSize: 20),
          enabled: state.status.isSubmissionInProgress ? false : true,
          textInputAction: TextInputAction.done,
          onChanged: (ip) => context.read<LoginBloc>().add(LoginIPChanged(ip)),
          decoration: const InputDecoration(
            // contentPadding:
            //     const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.zero),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            hintText: 'IP',
            hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
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
          enabled: state.status.isSubmissionInProgress ? false : true,
          textInputAction: TextInputAction.done,
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.zero),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            hintText: 'User ID',
            hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
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
          enabled: state.status.isSubmissionInProgress ? false : true,
          textInputAction: TextInputAction.done,
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: !state.passwordVisibility,
          decoration: InputDecoration(
            border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            hintText: 'Password',
            hintStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            //errorText: state.password.invalid ? 'Invalid Password' : null,
            suffixIcon: IconButton(
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
