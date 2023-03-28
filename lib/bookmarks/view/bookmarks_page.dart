import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/bookmarks/bloc/bookmarks_bloc.dart';
import 'package:ricoms_app/bookmarks/view/bookmarks_form.dart';
import 'package:ricoms_app/repository/bookmarks_repository/bookmarks_repository.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({
    Key? key,
    required this.pageController,
    required this.initialRootPath,
  }) : super(key: key);

  final PageController pageController;
  final List initialRootPath;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookmarksBloc(
        user: context.read<AuthenticationBloc>().state.user,
        bookmarksRepository:
            RepositoryProvider.of<BookmarksRepository>(context),
      ),
      child: BookmarksForm(
        pageController: pageController,
        initialPath: initialRootPath,
      ),
    );
  }
}
