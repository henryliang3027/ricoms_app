part of 'bookmarks_bloc.dart';

abstract class BookmarksEvent extends Equatable {
  const BookmarksEvent();
}

class BookmarksRequested extends BookmarksEvent {
  const BookmarksRequested();

  @override
  List<Object?> get props => [];
}

class BookmarksDeletedModeEnabled extends BookmarksEvent {
  const BookmarksDeletedModeEnabled();

  @override
  List<Object?> get props => [];
}

class BookmarksDeletedModeDisabled extends BookmarksEvent {
  const BookmarksDeletedModeDisabled();

  @override
  List<Object?> get props => [];
}

class BookmarksItemToggled extends BookmarksEvent {
  const BookmarksItemToggled(this.device);

  final Device device;

  @override
  List<Object?> get props => [device];
}

class BookmarksDeleted extends BookmarksEvent {
  const BookmarksDeleted();

  @override
  List<Object?> get props => [];
}

class DeviceStatusChecked extends BookmarksEvent {
  const DeviceStatusChecked(
    this.initialPath,
    this.path,
    this.pageController,
  );

  final List initialPath;
  final List<int> path;
  final PageController pageController;

  @override
  List<Object?> get props => [
        initialPath,
        path,
        pageController,
      ];
}
