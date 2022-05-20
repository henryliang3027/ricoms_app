import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/login/bloc/login_bloc.dart';
import 'package:ricoms_app/login/view/login_form.dart';
import 'package:ricoms_app/repository/authentication_repository.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

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
    Future<void> _showConnectionLostDialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Lost connection to server'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Please try to login again.'),
                  Text('Make sure you are on the same domain as the server.')
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

    final AuthenticationStatus status = context.select(
      (AuthenticationBloc bloc) => bloc.state.status,
    );

    if (status == AuthenticationStatus.unknown) {
      Future.delayed(
          Duration.zero,
          () => _showConnectionLostDialog(
              context)); //dialog should be call after finish building layout
    }

    //final mq = MediaQueryData.fromWindow(window);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: double.maxFinite,
            child: Image.asset(
              'assets/login_background_android.png',
              fit: BoxFit.cover,
            ),
          ),

          Container(
            height: double.maxFinite,
            child: GifPlayer(),
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
          Container(
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
          // ConstrainedBox(
          //   constraints: BoxConstraints.tightFor(
          //     height: mq.size.height,
          //   ),
          //   child: Container(
          //     height: double.infinity,
          //     //color: Colors.black,
          //     child: Padding(
          //       padding: const EdgeInsets.all(12),
          //       child: BlocProvider(
          //         create: (context) {
          //           return LoginBloc(
          //             authenticationRepository:
          //                 RepositoryProvider.of<AuthenticationRepository>(
          //               context,
          //             ),
          //           );
          //         },
          //         child: const LoginForm(),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class GifPlayer extends StatefulWidget {
  const GifPlayer({Key? key}) : super(key: key);

  @override
  State<GifPlayer> createState() => _GifPlayerState();
}

class _GifPlayerState extends State<GifPlayer>
    with SingleTickerProviderStateMixin {
  late final GifController controller;

  @override
  void initState() {
    controller = GifController(vsync: this);
    controller.repeat(
        min: 0, max: 90, period: const Duration(milliseconds: 3000));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GifImage(
      controller: controller,
      image: const AssetImage('assets/login_background_android.gif'),
      fit: BoxFit.cover,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
