import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/bookmarks_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'bookmarks_event.dart';
part 'bookmarks_state.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  BookmarksBloc({
    required User user,
    required BookmarksRepository bookmarksRepository,
  })  : _user = user,
        _bookmarksRepository = bookmarksRepository,
        super(const BookmarksState()) {
    on<BookmarksRequested>(_onBookmarksRequested);

    add(const BookmarksRequested());
  }

  final User _user;
  final BookmarksRepository _bookmarksRepository;

  Future<void> _onBookmarksRequested(
    BookmarksRequested event,
    Emitter<BookmarksState> emit,
  ) async {
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
    ));

    List<dynamic> result = await _bookmarksRepository.getBookmarks(user: _user);

    if (result[0]) {
      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        devices: result[1],
      ));
    } else {
      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        errmsg: result[1],
      ));
    }
  }
}
