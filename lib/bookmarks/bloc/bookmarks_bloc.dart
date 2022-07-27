import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
    on<BookmarksDeletedModeToggled>(_onBookmarksDeletedModeToggled);
    on<DeviceStatusChecked>(_onDeviceStatusChecked);

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
        formStatus: FormStatus.requestFailure,
        requestErrorMsg: result[1],
      ));
    }
  }

  void _onBookmarksDeletedModeToggled(
    BookmarksDeletedModeToggled event,
    Emitter<BookmarksState> emit,
  ) {
    emit(state.copyWith(
      isDeleteMode: !state.isDeleteMode,
    ));
  }

  Future<void> _onDeviceStatusChecked(
    DeviceStatusChecked event,
    Emitter<BookmarksState> emit,
  ) async {
    emit(state.copyWith(
      targetDeviceStatus: FormStatus.requestInProgress,
      isDeleteMode: false,
    ));

    List<dynamic> result = await _bookmarksRepository.getDeviceStatus(
      user: _user,
      path: event.path,
    );

    if (result[0]) {
      event.initialPath.addAll(event.path);
      event.pageController.jumpToPage(1);
    } else {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.requestFailure,
        targetDeviceMsg: result[1],
      ));
    }
  }
}
