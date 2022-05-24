import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/login/bloc/login_bloc.dart';
import 'package:ricoms_app/login/view/login_form.dart';
import 'package:ricoms_app/repository/authentication_repository.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation1, animation2) => LoginPage(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _showConnectionLostDialog(
        BuildContext context, String errmsg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Lost connection to server'),
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
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    final String errmsg = context.select(
      (AuthenticationBloc bloc) => bloc.state.errmsg,
    );

    if (errmsg != '') {
      Future.delayed(
          Duration.zero,
          () => _showConnectionLostDialog(context,
              errmsg)); //dialog should be call after finish building layout
    }

    //final mq = MediaQueryData.fromWindow(window);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            height: double.maxFinite,
            child: Image.asset(
              'assets/login_background_android.gif',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.96),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Image.asset(
                'assets/ACI.png',
                scale: 6.0,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Image.asset(
                'assets/2022.png',
                scale: 5.0,
              )
            ]),
          ),
          SizedBox(
            height: double.maxFinite,
            //color: Colors.black,
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
        ],
      ),
    );
  }
}
