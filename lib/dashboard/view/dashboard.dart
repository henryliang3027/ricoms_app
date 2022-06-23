import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/home/view/home_bottom_navigation_bar.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      bottomNavigationBar: HomeBottomNavigationBar(
        pageController: widget.pageController,
        selectedIndex: 2,
      ),
      drawer: HomeDrawer(
        user: context.select(
          (AuthenticationBloc bloc) => bloc.state.user,
        ),
        pageController: widget.pageController,
      ),
      body: const Center(
        child: Text('My DashboardPage'),
      ),
    );
  }
}
