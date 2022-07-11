import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/history_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc({
    required User user,
    required HistoryRepository historyRepository,
  })  : _user = user,
        _historyRepository = historyRepository,
        super(const HistoryState()) {
    on<HistoryRequested>(_onHistoryRequested);
    on<CheckDeviceStatus>(_onCheckDeviceStatus);

    add(const HistoryRequested());
  }

  final User _user;
  final HistoryRepository _historyRepository;

  Future<void> _onHistoryRequested(
    HistoryRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(
      targetDeviceStatus: FormStatus.none,
      status: FormStatus.requestInProgress,
    ));

    List<dynamic> result = await _historyRepository.getHistoryByFilter(
      user: _user,
    );

    if (result[0]) {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        status: FormStatus.requestSuccess,
        records: result[1],
      ));
    } else {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        status: FormStatus.requestFailure,
        errmsg: result[1],
      ));
    }
  }

  Future<void> _onCheckDeviceStatus(
    CheckDeviceStatus event,
    Emitter<HistoryState> emit,
  ) async {
    List<dynamic> result = await _historyRepository.getDeviceStatus(
      user: _user,
      nodeId: event.nodeId,
    );

    if (result[0]) {
      event.pageController.jumpToPage(1);
    } else {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.requestFailure,
        errmsg: result[1],
      ));
    }
  }
}
