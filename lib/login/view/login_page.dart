import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/login/bloc/login_bloc.dart';
import 'package:ricoms_app/login/view/login_form.dart';
import 'package:ricoms_app/repository/authentication_repository.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQueryData.fromWindow(window);

    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            height: mq.size.height,
          ),
          child: Container(
            height: double.infinity,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: BlocProvider(
                create: (context) {
                  return LoginBloc(
                    authenticationRepository:
                        RepositoryProvider.of<AuthenticationRepository>(
                      context,
                    ),
                  );
                },
                child: const LoginForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
