import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/home/view/home_bottom_navigation_bar.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key, required this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      bottomNavigationBar: HomeBottomNavigationBar(
        pageController: widget.pageController,
        selectedIndex: 3,
      ),
      drawer: HomeDrawer(
        user: context.select(
          (AuthenticationBloc bloc) => bloc.state.user,
        ),
        pageController: widget.pageController,
      ),
      body: const Center(
        child: Text('My HistoryPage'),
      ),
    );
  }
}
