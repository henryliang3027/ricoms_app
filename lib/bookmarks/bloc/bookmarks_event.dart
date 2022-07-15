part of 'bookmarks_bloc.dart';

abstract class BookmarksEvent extends Equatable {
  const BookmarksEvent();
}

class BookmarksRequested extends BookmarksEvent {
  const BookmarksRequested();

  @override
  List<Object?> get props => [];
}
