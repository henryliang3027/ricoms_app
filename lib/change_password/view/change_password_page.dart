import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/change_password/bloc/change_password_bloc.dart';
import 'package:ricoms_app/change_password/view/change_password_form.dart';
import 'package:ricoms_app/repository/authentication_repository.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key, required userId})
      : _userId = userId,
        super(key: key);

  static Route route(String userId) {
    return MaterialPageRoute<void>(
        builder: (_) => ChangePasswordPage(userId: userId));
  }

  final String _title = 'Change Password';
  final String _userId;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQueryData.fromWindow(window);

    print('UserID' + _userId);

    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          height: mq.size.height,
        ),
        child: Container(
          height: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: BlocProvider(
              create: (context) {
                return ChangePasswordBloc(
                    authenticationRepository:
                        RepositoryProvider.of<AuthenticationRepository>(
                            context));
              },
              child: const ChangePasswordForm(),
            ),
          ),
        ),
      ),
    );
  }
}
