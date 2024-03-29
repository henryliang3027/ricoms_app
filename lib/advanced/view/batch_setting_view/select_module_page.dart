import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/advanced/bloc/batch_setting/select_module/select_module_bloc.dart';
import 'package:ricoms_app/advanced/view/batch_setting_view/select_module_form.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/advanced_repository/batch_setting_repository/batch_setting_repository.dart';

class SelectModulePage extends StatelessWidget {
  const SelectModulePage({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SelectModulePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectModuleBloc(
        user: context.read<AuthenticationBloc>().state.user,
        batchSettingRepository:
            RepositoryProvider.of<BatchSettingRepository>(context),
      ),
      child: const SelectModuleForm(),
    );
  }
}
