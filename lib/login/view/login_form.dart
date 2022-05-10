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
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(image: AssetImage('assets/ricoms_logo.png')),
            const Padding(padding: EdgeInsets.all(12)),
            _IPInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _UsernameInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _PasswordInput(),
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
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            labelText: 'ip',
            errorText: state.ip.invalid ? 'invalid ip' : null,
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
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            labelText: 'username',
            errorText: state.username.invalid ? 'invalid username' : null,
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
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          textInputAction: TextInputAction.done,
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            labelText: 'password',
            errorText: state.password.invalid ? 'invalid password' : null,
          ),
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
                key: const Key('loginForm_continue_raisedButton'),
                child: const Text('Login'),
                onPressed: state.status.isValidated
                    ? () {
                        context.read<LoginBloc>().add(const LoginSubmitted());
                      }
                    : null,
              );
      },
    );
  }
}
