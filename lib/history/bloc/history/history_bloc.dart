import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/history/model/search_critria.dart';
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
    on<MoreRecordsRequested>(_onMoreRecordsRequested);
    on<DeviceStatusChecked>(_onDeviceStatusChecked);
    on<HistoryRecordsExported>(_onHistoryRecordsExported);
    on<FloatingActionButtonHided>(_onFloatingActionButtonHided);
    on<FloatingActionButtonShowed>(_onFloatingActionButtonShowed);

    add(HistoryRequested(SearchCriteria(
      startDate: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      endDate: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
    )));
  }

  final User _user;
  final HistoryRepository _historyRepository;

  Future<void> _onHistoryRequested(
    HistoryRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(
      historyExportStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      moreRecordsStatus: FormStatus.none,
      status: FormStatus.requestInProgress,
    ));

    List<String> queries = event.searchCriteria.queries;
    String formattedQurey = _formatQuery(queries);

    List<dynamic> result = await _historyRepository.getHistoryByFilter(
      user: _user,
      startDate: event.searchCriteria.startDate,
      endDate: event.searchCriteria.endDate,
      shelf: event.searchCriteria.shelf,
      slot: event.searchCriteria.slot,
      unsolvedOnly: event.searchCriteria.unsolvedOnly == true ? '1' : '0',
      queryData: formattedQurey,
    );

    if (result[0]) {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        status: FormStatus.requestSuccess,
        currentCriteria: event.searchCriteria,
        records: result[1],
      ));
    } else {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        status: FormStatus.requestFailure,
        currentCriteria: event.searchCriteria,
        errmsg: result[1],
      ));
    }
  }

  Future<void> _onMoreRecordsRequested(
    MoreRecordsRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(
      historyExportStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      moreRecordsStatus: FormStatus.requestInProgress,
    ));

    List<String> queries = state.currentCriteria.queries;
    String formattedQurey = _formatQuery(queries);

    List<dynamic> result = await _historyRepository.getHistoryByFilter(
      user: _user,
      startDate: state.currentCriteria.startDate,
      endDate: state.currentCriteria.endDate,
      shelf: state.currentCriteria.shelf,
      slot: state.currentCriteria.slot,
      unsolvedOnly: state.currentCriteria.unsolvedOnly == true ? '1' : '0',
      trapId: event.startTrapId.toString(),
      next: 'top',
      queryData: formattedQurey,
    );

    if (result[0]) {
      List<Record> records = [];
      records.addAll(state.records);
      records.addAll(result[1]);

      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        moreRecordsStatus: FormStatus.requestSuccess,
        records: records,
      ));
    } else {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        moreRecordsStatus: FormStatus.requestFailure,
        moreRecordsMessage: result[1],
      ));
    }
  }

  Future<void> _onDeviceStatusChecked(
    DeviceStatusChecked event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(
      targetDeviceStatus: FormStatus.requestInProgress,
      moreRecordsStatus: FormStatus.none,
      historyExportStatus: FormStatus.none,
    ));

    List<dynamic> result = await _historyRepository.getDeviceStatus(
      user: _user,
      path: event.path,
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

  void _onFloatingActionButtonHided(
    FloatingActionButtonHided event,
    Emitter<HistoryState> emit,
  ) {
    emit(state.copyWith(
      historyExportStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      moreRecordsStatus: FormStatus.none,
      isShowFloatingActionButton: false,
    ));
  }

  void _onFloatingActionButtonShowed(
    FloatingActionButtonShowed event,
    Emitter<HistoryState> emit,
  ) {
    emit(state.copyWith(
      historyExportStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      moreRecordsStatus: FormStatus.none,
      isShowFloatingActionButton: true,
    ));
  }

  Future<void> _onHistoryRecordsExported(
    HistoryRecordsExported event,
    Emitter<HistoryState> emit,
  ) async {
    String formattedQuery = _formatQuery(state.currentCriteria.queries);

    List<dynamic> result = await _historyRepository.exportHistory(
        user: _user,
        startDate: state.currentCriteria.startDate,
        endDate: state.currentCriteria.endDate,
        shelf: state.currentCriteria.shelf,
        slot: state.currentCriteria.slot,
        unsolvedOnly: state.currentCriteria.unsolvedOnly == true ? '1' : '0',
        queryData: formattedQuery);

    if (result[0]) {
      emit(state.copyWith(
        moreRecordsStatus: FormStatus.none,
        targetDeviceStatus: FormStatus.none,
        historyExportStatus: FormStatus.requestSuccess,
        historyExportMsg: result[1],
        historyExportFilePath: result[2],
      ));
    } else {
      emit(state.copyWith(
        moreRecordsStatus: FormStatus.none,
        targetDeviceStatus: FormStatus.none,
        historyExportStatus: FormStatus.requestFailure,
        historyExportMsg: result[1],
        historyExportFilePath: '',
      ));
    }
  }

  String _formatQuery(List<String> queries) {
    String formattedQurey = '';

    if (queries.isNotEmpty) {
      for (int i = 0; i < queries.length - 1; i++) {
        String formattedElement = '\"${queries[i]}\"';
        formattedQurey = formattedQurey + formattedElement + '+';
      }
      formattedQurey = formattedQurey + '\"${queries[queries.length - 1]}\"';
    }
    return formattedQurey;
  }
}
