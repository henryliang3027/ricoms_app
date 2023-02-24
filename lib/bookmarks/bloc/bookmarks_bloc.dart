import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/bookmarks_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

part 'bookmarks_event.dart';
part 'bookmarks_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  BookmarksBloc({
    required User user,
    required BookmarksRepository bookmarksRepository,
  })  : _user = user,
        _bookmarksRepository = bookmarksRepository,
        super(const BookmarksState()) {
    on<BookmarksRequested>(_onBookmarksRequested);
    on<MoreBookmarksRequested>(
      _onMoreBookmarksRequested,
      transformer: throttleDroppable(throttleDuration),
    );
    on<BookmarksDeletedModeEnabled>(_onBookmarksDeletedModeEnabled);
    on<BookmarksDeletedModeDisabled>(_onBookmarksDeletedModeDisabled);
    on<BookmarksDeleted>(_onBookmarksDeleted);
    on<MultipleBookmarksDeleted>(_onMultipleBookmarksDeleted);
    on<BookmarksItemToggled>(_onBookmarksItemToggled);
    on<DeviceStatusChecked>(
      _onDeviceStatusChecked,
      transformer: throttleDroppable(throttleDuration),
    );

    add(const BookmarksRequested());
  }

  final User _user;
  final BookmarksRepository _bookmarksRepository;
  final List<DeviceMeta> _deviceMetas = [];

  Future<void> _onBookmarksRequested(
    BookmarksRequested event,
    Emitter<BookmarksState> emit,
  ) async {
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
      deviceDeleteStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
    ));

    _deviceMetas.addAll(_bookmarksRepository.getDeviceMetas(user: _user));

    List<dynamic> result = await _bookmarksRepository.getBookmarks(
        user: _user,
        deviceMetas: _deviceMetas,
        startIndex: state.devices.length);

    bool hasReachedMax = false;

    if (result[0]) {
      List<Device> devices = result[1];
      if (devices.isNotEmpty) {
        if (devices.length < _deviceMetas.length) {
          hasReachedMax = false;
        } else {
          hasReachedMax = true;
        }
        emit(state.copyWith(
          formStatus: FormStatus.requestSuccess,
          devices: devices,
          hasReachedMax: hasReachedMax,
        ));
      } else {
        emit(state.copyWith(
          formStatus: FormStatus.requestFailure,
          requestErrorMsg: 'There are no records to show',
          hasReachedMax: true,
        ));
      }
    } else {
      // connection failed
      emit(state.copyWith(
        formStatus: FormStatus.requestFailure,
        requestErrorMsg: result[1],
        hasReachedMax: true,
      ));
    }
  }

  Future<void> _onMoreBookmarksRequested(
    MoreBookmarksRequested event,
    Emitter<BookmarksState> emit,
  ) async {
    // emit(state.copyWith(
    //   loadMoreDevicesStatus: FormStatus.requestInProgress,
    //   deviceDeleteStatus: FormStatus.none,
    //   targetDeviceStatus: FormStatus.none,
    // ));

    List<dynamic> result = await _bookmarksRepository.getBookmarks(
        user: _user,
        deviceMetas: _deviceMetas,
        startIndex: state.devices.length);

    if (result[0]) {
      List<Device> originalDevices = List.of(state.devices);
      List<Device> remainDevices = result[1];
      bool hasReachMax = false;

      if (remainDevices.isEmpty) {
        hasReachMax = true;
      } else {
        originalDevices.addAll(remainDevices);
      }

      emit(state.copyWith(
        loadMoreDeviceStatus: FormStatus.requestSuccess,
        hasReachedMax: hasReachMax,
        devices: originalDevices,
      ));
    } else {
      // connection failed
      emit(state.copyWith(
        loadMoreDeviceStatus: FormStatus.requestFailure,
        hasReachedMax: true,
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
        loadMoreDeviceStatus: FormStatus.none,
        deviceDeleteStatus: FormStatus.none,
        targetDeviceStatus: FormStatus.none,
        selectedDevices: state.devices,
        isDeleteMode: true,
      ));
    }
  }

  void _onBookmarksDeletedModeDisabled(
    BookmarksDeletedModeDisabled event,
    Emitter<BookmarksState> emit,
  ) {
    emit(state.copyWith(
      loadMoreDeviceStatus: FormStatus.none,
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
      loadMoreDeviceStatus: FormStatus.none,
      deviceDeleteStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      formStatus: FormStatus.requestInProgress,
    ));

    List<dynamic> resultOfDelete = await _bookmarksRepository.deleteDevices(
      user: _user,
      devices: [event.device],
    );

    if (resultOfDelete[0]) {
      List<Device> devices = [];
      devices.addAll(state.devices);
      devices.remove(event.device);

      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        deviceDeleteStatus: FormStatus.requestSuccess,
        devices: devices,
        selectedDevices: const [],
        isDeleteMode: false,
      ));

      // List<dynamic> resultOfRetrieve =
      //     await _bookmarksRepository.getBookmarks(user: _user);

      // if (resultOfRetrieve[0]) {
      //   emit(state.copyWith(
      //     formStatus: FormStatus.requestSuccess,
      //     deviceDeleteStatus: FormStatus.requestSuccess,
      //     devices: resultOfRetrieve[1],
      //     selectedDevices: const [],
      //     isDeleteMode: false,
      //   ));
      // } else {
      //   emit(state.copyWith(
      //     formStatus: FormStatus.requestFailure,
      //     deviceDeleteStatus: FormStatus.requestSuccess,
      //     requestErrorMsg: resultOfRetrieve[1],
      //     selectedDevices: const [],
      //     isDeleteMode: false,
      //   ));
      // }
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

  Future<void> _onMultipleBookmarksDeleted(
    MultipleBookmarksDeleted event,
    Emitter<BookmarksState> emit,
  ) async {
    emit(state.copyWith(
      loadMoreDeviceStatus: FormStatus.none,
      deviceDeleteStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      formStatus: FormStatus.requestInProgress,
    ));

    List<dynamic> resultOfDelete = await _bookmarksRepository.deleteDevices(
      user: _user,
      devices: state.selectedDevices,
    );

    if (resultOfDelete[0]) {
      List<Device> devices = [];
      devices.addAll(state.devices);

      for (Device device in state.selectedDevices) {
        devices.remove(device);
      }

      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        deviceDeleteStatus: FormStatus.requestSuccess,
        devices: devices,
        selectedDevices: const [],
        isDeleteMode: false,
      ));

      // List<dynamic> resultOfRetrieve =
      //     await _bookmarksRepository.getBookmarks(user: _user);

      // if (resultOfRetrieve[0]) {
      //   emit(state.copyWith(
      //     formStatus: FormStatus.requestSuccess,
      //     deviceDeleteStatus: FormStatus.requestSuccess,
      //     devices: resultOfRetrieve[1],
      //     selectedDevices: const [],
      //     isDeleteMode: false,
      //   ));
      // } else {
      //   emit(state.copyWith(
      //     formStatus: FormStatus.requestFailure,
      //     deviceDeleteStatus: FormStatus.requestSuccess,
      //     requestErrorMsg: resultOfRetrieve[1],
      //     selectedDevices: const [],
      //     isDeleteMode: false,
      //   ));
      // }
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
      loadMoreDeviceStatus: FormStatus.none,
      deviceDeleteStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      selectedDevices: selectedDevices,
    ));
  }

  Future<void> _onDeviceStatusChecked(
    DeviceStatusChecked event,
    Emitter<BookmarksState> emit,
  ) async {
    emit(state.copyWith(
      loadMoreDeviceStatus: FormStatus.none,
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
