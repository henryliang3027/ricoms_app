import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/history/model/search_critria.dart';
import 'package:ricoms_app/repository/history_repository/history_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:ricoms_app/utils/common_list_limit.dart';
import 'package:ricoms_app/utils/common_request.dart';
import 'package:stream_transform/stream_transform.dart';

part 'history_event.dart';
part 'history_state.dart';

const throttleDuration = Duration(milliseconds: 1000);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc({
    required User user,
    required HistoryRepository historyRepository,
  })  : _user = user,
        _historyRepository = historyRepository,
        super(const HistoryState()) {
    on<HistoryRequested>(_onHistoryRequested);
    on<MoreNewerRecordsRequested>(_onMoreNewerRecordsRequested);
    on<MoreOlderRecordsRequested>(_onMoreOlderRecordsRequested);

    on<HistoryRecordsExported>(_onHistoryRecordsExported);
    on<FloatingActionButtonHided>(_onFloatingActionButtonHided);
    on<FloatingActionButtonShowed>(_onFloatingActionButtonShowed);
    on<DeviceStatusChecked>(
      _onDeviceStatusChecked,
      transformer: throttleDroppable(throttleDuration),
    );

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
      isShowFloatingActionButton: false,
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

  Future<void> _onMoreNewerRecordsRequested(
    MoreNewerRecordsRequested event,
    Emitter<HistoryState> emit,
  ) async {
    // emit(state.copyWith(
    //   historyExportStatus: FormStatus.none,
    //   targetDeviceStatus: FormStatus.none,
    //   moreRecordsStatus: FormStatus.requestInProgress,
    // ));

    List<String> queries = state.currentCriteria.queries;
    String formattedQurey = _formatQuery(queries);

    // 取得最新的 records ( api 預設回傳最多 1000 筆 ) , 用來檢查是否有新的 record 產生
    List<dynamic> resultOfNewRecords =
        await _historyRepository.getHistoryByFilter(
      user: _user,
      startDate: state.currentCriteria.startDate,
      endDate: state.currentCriteria.endDate,
      shelf: state.currentCriteria.shelf,
      slot: state.currentCriteria.slot,
      trapId: state.records[0].trapId.toString(),
      next: 'button',
      unsolvedOnly: state.currentCriteria.unsolvedOnly == true ? '1' : '0',
      queryData: formattedQurey,
    );

    if (resultOfNewRecords[0]) {
      List<Record> records = [];
      records.addAll(resultOfNewRecords[1]);
      records.addAll(state.records);

      records.length = records.length >= CommonListLimit.maximimHistoryRecords
          ? CommonListLimit.maximimHistoryRecords
          : records.length;

      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        moreRecordsStatus: FormStatus.requestSuccess,
        tapLoadNewerRecordsCount: state.tapLoadNewerRecordsCount + 1,
        records: records,
      ));
    } else {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        moreRecordsStatus: FormStatus.requestFailure,
        tapLoadNewerRecordsCount: state.tapLoadNewerRecordsCount + 1,
        moreRecordsMessage: resultOfNewRecords[1],
      ));
    }
  }

  Future<void> _onMoreOlderRecordsRequested(
    MoreOlderRecordsRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(
      historyExportStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      moreRecordsStatus: FormStatus.requestInProgress,
    ));

    List<String> queries = state.currentCriteria.queries;
    String formattedQurey = _formatQuery(queries);

    List<dynamic> resultOfMoreRecords =
        await _historyRepository.getMoreHistoryByFilter(
      user: _user,
      startDate: state.currentCriteria.startDate,
      endDate: state.currentCriteria.endDate,
      shelf: state.currentCriteria.shelf,
      slot: state.currentCriteria.slot,
      unsolvedOnly: state.currentCriteria.unsolvedOnly == true ? '1' : '0',
      trapId: state.records.last.trapId.toString(),
      next: 'top',
      queryData: formattedQurey,
    );

    if (resultOfMoreRecords[0]) {
      List<Record> records = [];
      records.addAll(state.records);
      records.addAll(resultOfMoreRecords[1]);

      records.length = records.length >= CommonListLimit.maximimHistoryRecords
          ? CommonListLimit.maximimHistoryRecords
          : records.length;

      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        moreRecordsStatus: FormStatus.requestSuccess,
        records: records,
      ));
    } else {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        moreRecordsStatus: FormStatus.requestFailure,
        moreRecordsMessage: resultOfMoreRecords[1],
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

    List<dynamic> result = await getDeviceStatus(
      user: _user,
      path: event.path,
    );

    if (result[0]) {
      event.initialPath.addAll(event.path);
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
      isShowFloatingActionButton:
          state.records.length < CommonListLimit.maximimHistoryRecords
              ? true
              : false,
    ));
  }

  Future<void> _onHistoryRecordsExported(
    HistoryRecordsExported event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(
      moreRecordsStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      historyExportStatus: FormStatus.none,
    ));

    List<dynamic> result = await _historyRepository.exportHistory(
      user: _user,
      records: state.records,
    );

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

        /// 使用 html encode 來編碼特殊字元 ex: # -> %23, " -> %22
        /// https://www.w3schools.com/tags/ref_urlencode.ASP
        formattedElement = Uri.encodeQueryComponent(formattedElement);
        formattedQurey = formattedQurey + formattedElement + '+';
      }
      String lastFormatedElement = '\"${queries[queries.length - 1]}\"';
      lastFormatedElement = Uri.encodeQueryComponent(lastFormatedElement);
      formattedQurey = formattedQurey + lastFormatedElement;
    }
    return formattedQurey;
  }
}
