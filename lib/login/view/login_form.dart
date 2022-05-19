import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/login/bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errmsg)),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(image: AssetImage('assets/ricoms_logo.png')),
            const Padding(padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0)),

            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 51.0,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Image.asset('assets/login_ip_icon.png'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: _IPInput(),
                    ),
                  ),
                ],
              ),
            ),

            const Padding(padding: EdgeInsets.all(12)),

            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 51.0,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Image.asset('assets/login_username_icon.png'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: _UsernameInput(),
                    ),
                  ),
                ],
              ),
            ),

            const Padding(padding: EdgeInsets.all(12)),

            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 51.0,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Image.asset('assets/login_password_icon.png'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: _PasswordInput(),
                    ),
                  ),
                ],
              ),
            ),

            const Padding(padding: EdgeInsets.all(12)),
            // _LanguageDropDownButton(),
            // const Padding(padding: EdgeInsets.all(12)),
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
      buildWhen: (previous, current) => previous.ip != current.ip,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_ipInput_textField'),
          textInputAction: TextInputAction.done,
          onChanged: (ip) => context.read<LoginBloc>().add(LoginIPChanged(ip)),
          decoration: InputDecoration(
            border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            labelText: 'IP',
            labelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            errorText: state.ip.invalid ? 'Invalid IP' : null,
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
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_usernameInput_textField'),
          textInputAction: TextInputAction.done,
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
          decoration: InputDecoration(
            border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            labelText: 'User ID',
            labelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            errorText: state.username.invalid ? 'Invalid User ID' : null,
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
          previous.passwordVisibility != current.passwordVisibility,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          textInputAction: TextInputAction.done,
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: !state.passwordVisibility,
          decoration: InputDecoration(
              border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              labelText: 'Password',
              labelStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              errorText: state.password.invalid ? 'Invalid Password' : null,
              suffixIcon: IconButton(
                icon: state.passwordVisibility
                    ? const Icon(Icons.visibility_outlined)
                    : const Icon(Icons.visibility_off_outlined),
                onPressed: () {
                  context
                      .read<LoginBloc>()
                      .add(const LoginPasswordVisibilityChanged());
                },
              )),
        );
      },
    );
  }
}

class _LanguageDropDownButton extends StatelessWidget {
  final String _dropdownValue = "English";
  final List<String> dropDownOptions = [
    "English",
    "Chinese (Traditional)",
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: dropDownOptions.map<DropdownMenuItem<String>>((String language) {
        return DropdownMenuItem<String>(child: Text(language), value: language);
      }).toList(),
      // Alternative way to pass items
      /*items: const [
                DropdownMenuItem(child: Text("Dash"), value: "Dash"),
                DropdownMenuItem(child: Text("Sparky"), value: "Sparky"),
                DropdownMenuItem(child: Text("Snoo"), value: "Snoo"),
                DropdownMenuItem(child: Text("Clippy"), value: "Clippy"),
              ],*/
      value: _dropdownValue,
      onChanged: (String? newValue) {},
      // Customizatons
      //iconSize: 42.0,
      //iconEnabledColor: Colors.green,
      //icon: const Icon(Icons.flutter_dash),
      //isExpanded: true,

      style: const TextStyle(
        color: Colors.white,
      ),
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
                height: 80,
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
