import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/home/view/home_bottom_navigation_bar.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      bottomNavigationBar: HomeBottomNavigationBar(
        pageController: widget.pageController,
        selectedIndex: 4,
      ),
      drawer: HomeDrawer(
        user: context.select(
          (AuthenticationBloc bloc) => bloc.state.user,
        ),
        pageController: widget.pageController,
        currentPageIndex: 4,
      ),
      body: const Center(
        child: Text('My BookmarksPage'),
      ),
    );
  }
}
