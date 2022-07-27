part of 'bookmarks_bloc.dart';

abstract class BookmarksEvent extends Equatable {
  const BookmarksEvent();
}

class BookmarksRequested extends BookmarksEvent {
  const BookmarksRequested();

  @override
  List<Object?> get props => [];
}

class BookmarksDeletedModeToggled extends BookmarksEvent {
  const BookmarksDeletedModeToggled();

  @override
  List<Object?> get props => [];
}

class BookmarksNodeSelected extends BookmarksEvent {
  const BookmarksNodeSelected(this.nodeId);

  final int nodeId;

  @override
  List<Object?> get props => [nodeId];
}

class BookmarksAllNodeSelected extends BookmarksEvent {
  const BookmarksAllNodeSelected();

  @override
  List<Object?> get props => [];
}

class BookmarksDeleted extends BookmarksEvent {
  const BookmarksDeleted(this.nodeIds);

  final List<int> nodeIds;

  @override
  List<Object?> get props => [nodeIds];
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
