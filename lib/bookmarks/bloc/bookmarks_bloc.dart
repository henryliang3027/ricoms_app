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
    on<BookmarksDeletedModeEnabled>(_onBookmarksDeletedModeEnabled);
    on<BookmarksDeletedModeDisabled>(_onBookmarksDeletedModeDisabled);
    on<BookmarksDeleted>(_onBookmarksDeleted);
    on<BookmarksItemToggled>(_onBookmarksItemToggled);
    on<BookmarksAllItemSelected>(_onBookmarksAllItemSelected);
    on<BookmarksAllItemDeselected>(_onBookmarksAllItemDeselected);
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
      deviceDeleteStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
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

  void _onBookmarksDeletedModeEnabled(
    BookmarksDeletedModeEnabled event,
    Emitter<BookmarksState> emit,
  ) {
    if (state.devices.isNotEmpty) {
      emit(state.copyWith(
        deviceDeleteStatus: FormStatus.none,
        targetDeviceStatus: FormStatus.none,
        isDeleteMode: true,
      ));
    }
  }

  void _onBookmarksDeletedModeDisabled(
    BookmarksDeletedModeDisabled event,
    Emitter<BookmarksState> emit,
  ) {
    emit(state.copyWith(
      deviceDeleteStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      selectedDevices: const [],
      isDeleteMode: false,
    ));
  }

  Future<void> _onBookmarksDeleted(
    BookmarksDeleted event,
    Emitter<BookmarksState> emit,
  ) async {
    emit(state.copyWith(
      deviceDeleteStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      formStatus: FormStatus.requestInProgress,
    ));

    List<dynamic> resultOfDelete = await _bookmarksRepository.deleteDevices(
      user: _user,
      devices: state.selectedDevices,
    );

    if (resultOfDelete[0]) {
      List<dynamic> resultOfRetrieve =
          await _bookmarksRepository.getBookmarks(user: _user);

      if (resultOfRetrieve[0]) {
        emit(state.copyWith(
          formStatus: FormStatus.requestSuccess,
          deviceDeleteStatus: FormStatus.requestSuccess,
          devices: resultOfRetrieve[1],
          selectedDevices: const [],
          isDeleteMode: false,
        ));
      } else {
        emit(state.copyWith(
          formStatus: FormStatus.requestFailure,
          deviceDeleteStatus: FormStatus.requestSuccess,
          requestErrorMsg: resultOfRetrieve[1],
          selectedDevices: const [],
          isDeleteMode: false,
        ));
      }
    } else {
      emit(state.copyWith(
        formStatus: FormStatus.requestFailure,
        deviceDeleteStatus: FormStatus.requestFailure,
        deleteResultMsg: resultOfDelete[1],
        selectedDevices: const [],
        isDeleteMode: false,
      ));
    }
  }

  void _onBookmarksItemToggled(
    BookmarksItemToggled event,
    Emitter<BookmarksState> emit,
  ) {
    List<Device> selectedDevices = [];

    selectedDevices.addAll(state.selectedDevices);

    if (selectedDevices.contains(event.device)) {
      selectedDevices.remove(event.device);
    } else {
      selectedDevices.add(event.device);
    }

    emit(state.copyWith(
      deviceDeleteStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      selectedDevices: selectedDevices,
    ));
  }

  void _onBookmarksAllItemSelected(
    BookmarksAllItemSelected event,
    Emitter<BookmarksState> emit,
  ) {
    List<Device> selectedDevices = [];
    selectedDevices.addAll(state.devices);

    emit(state.copyWith(
      deviceDeleteStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      selectedDevices: selectedDevices,
    ));
  }

  void _onBookmarksAllItemDeselected(
    BookmarksAllItemDeselected event,
    Emitter<BookmarksState> emit,
  ) {
    emit(state.copyWith(
      deviceDeleteStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      selectedDevices: const [],
    ));
  }

  Future<void> _onDeviceStatusChecked(
    DeviceStatusChecked event,
    Emitter<BookmarksState> emit,
  ) async {
    emit(state.copyWith(
      deviceDeleteStatus: FormStatus.none,
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
