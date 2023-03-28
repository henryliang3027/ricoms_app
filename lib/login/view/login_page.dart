import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/login/bloc/login_bloc.dart';
import 'package:ricoms_app/login/view/login_form.dart';
import 'package:ricoms_app/repository/authentication_repository/authentication_repository.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation1, animation2) => const LoginPage(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    // set system icons to white
    // system icons are top status bar clock, notitificationicon, battery icon, wifi icon etc.)
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    Future<void> _showAutoLoginFailedDialog(
      BuildContext context,
      String errTitle,
      String errmsg,
    ) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              getMessageLocalization(
                msg: errTitle,
                context: context,
              ),
              style: const TextStyle(
                color: CustomStyle.customRed,
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
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    final String errTitle = context.read<AuthenticationBloc>().state.msgTitle;
    final String errmsg = context.read<AuthenticationBloc>().state.msg;

    if (errmsg != '') {
      Future.delayed(
          Duration.zero,
          () => _showAutoLoginFailedDialog(
                context,
                errTitle,
                errmsg,
              ));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Image.asset(
              'assets/login_background_android.gif',
              fit: BoxFit.fill,
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
