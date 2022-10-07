import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/change_password/bloc/change_password_bloc.dart';
import 'package:ricoms_app/change_password/view/change_password_form.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';
import 'package:ricoms_app/repository/authentication_repository.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({
    Key? key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const ChangePasswordPage());
  }

  @override
  Widget build(BuildContext context) {
    //final mq = MediaQueryData.fromWindow(window);

    return WillPopScope(
      onWillPop: () async {
        //when user tap back button
        Navigator.of(context).pop(false); // pop with bool as data
        return false; // will be pop without data if true, will not be pop if false
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.changePassword,
            style: const TextStyle(fontSize: CommonStyle.sizeXXL),
          ),
        ),
        body: Container(
          height: double.maxFinite,
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
