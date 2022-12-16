import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/batch_setting_repository.dart';
import 'package:ricoms_app/repository/user.dart';

class BatchSettingResultPage extends StatelessWidget {
  const BatchSettingResultPage({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const BatchSettingResultPage(),
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.batchSettingResult,
        ),
        elevation: 0.0,
      ),
      body: _SettingList(
        settingList: List<String>.generate(100, (index) => 'Item $index'),
      ),
    );
  }
}

class _SettingList extends StatelessWidget {
  const _SettingList({Key? key, required this.settingList}) : super(key: key);

  final List<String> settingList;

  @override
  Widget build(BuildContext context) {
    BatchSettingRepository batchSettingRepository =
        RepositoryProvider.of<BatchSettingRepository>(context);
    User user = context.read<AuthenticationBloc>().state.user;

    return ListView.builder(
      cacheExtent: settingList.length * 100.0,
      itemCount: settingList.length,
      prototypeItem: ListTile(
        title: Text(settingList.first),
      ),
      itemBuilder: (context, index) {
        return FutureBuilder(
          future: batchSettingRepository.setDeviceParameter(user: user),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListTile(
                leading: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: Text(settingList[index]),
                onTap: () {},
              );
            } else {
              return ListTile(
                leading: CircularProgressIndicator(),
                title: Text(settingList[index]),
                onTap: () {},
              );
            }
          },
        );
      },
    );
  }
}
