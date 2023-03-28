import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/repository/system_log_repository/system_log_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/system_log/model/filter_critria.dart';

part 'system_log_event.dart';
part 'system_log_state.dart';

class SystemLogBloc extends Bloc<SystemLogEvent, SystemLogState> {
  SystemLogBloc({
    required User user,
    required SystemLogRepository systemLogRepository,
  })  : _user = user,
        _systemLogRepository = systemLogRepository,
        super(const SystemLogState()) {
    on<LogRequested>(_onLogRequested);
    on<MoreLogsRequested>(_onMoreLogsRequested);
    on<DeviceStatusChecked>(_onDeviceStatusChecked);
    on<LogsExported>(_onLogsExported);
    on<FloatingActionButtonHided>(_onFloatingActionButtonHided);
    on<FloatingActionButtonShowed>(_onFloatingActionButtonShowed);

    add(LogRequested(FilterCriteria(
      startDate: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      endDate: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
    )));
  }

  final User _user;
  final SystemLogRepository _systemLogRepository;

  Future<void> _onLogRequested(
    LogRequested event,
    Emitter<SystemLogState> emit,
  ) async {
    emit(state.copyWith(
      logExportStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      moreLogsStatus: FormStatus.none,
      status: FormStatus.requestInProgress,
      isShowFloatingActionButton: false,
    ));

    List<String> queries = event.filterCriteria.queries;
    String formattedQurey = _formatQuery(queries);

    List<dynamic> result = await _systemLogRepository.getLogByFilter(
      user: _user,
      startDate: event.filterCriteria.startDate,
      endDate: event.filterCriteria.endDate,
      queryData: formattedQurey,
    );

    if (result[0]) {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        status: FormStatus.requestSuccess,
        filterCriteria: event.filterCriteria,
        logs: result[1],
      ));
    } else {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        status: FormStatus.requestFailure,
        filterCriteria: event.filterCriteria,
        errmsg: result[1],
      ));
    }
  }

  Future<void> _onMoreLogsRequested(
    MoreLogsRequested event,
    Emitter<SystemLogState> emit,
  ) async {
    emit(state.copyWith(
      logExportStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      moreLogsStatus: FormStatus.requestInProgress,
    ));

    List<String> queries = state.filterCriteria.queries;
    String formattedQurey = _formatQuery(queries);

    List<dynamic> result = await _systemLogRepository.getMoreLogsByFilter(
      user: _user,
      startDate: state.filterCriteria.startDate,
      endDate: state.filterCriteria.endDate,
      startId: event.startId.toString(),
      next: 'top',
      queryData: formattedQurey,
    );

    if (result[0]) {
      List<Log> logs = [];
      logs.addAll(state.logs);
      logs.addAll(result[1]);

      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        moreLogsStatus: FormStatus.requestSuccess,
        logs: logs,
      ));
    } else {
      emit(state.copyWith(
        targetDeviceStatus: FormStatus.none,
        moreLogsStatus: FormStatus.requestFailure,
        moreLogsMessage: result[1],
      ));
    }
  }

  Future<void> _onDeviceStatusChecked(
    DeviceStatusChecked event,
    Emitter<SystemLogState> emit,
  ) async {
    emit(state.copyWith(
      targetDeviceStatus: FormStatus.requestInProgress,
      moreLogsStatus: FormStatus.none,
      logExportStatus: FormStatus.none,
    ));

    List<dynamic> result = await _systemLogRepository.getDeviceStatus(
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
    Emitter<SystemLogState> emit,
  ) {
    emit(state.copyWith(
      logExportStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      moreLogsStatus: FormStatus.none,
      isShowFloatingActionButton: false,
    ));
  }

  void _onFloatingActionButtonShowed(
    FloatingActionButtonShowed event,
    Emitter<SystemLogState> emit,
  ) {
    emit(state.copyWith(
      logExportStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      moreLogsStatus: FormStatus.none,
      isShowFloatingActionButton: true,
    ));
  }

  Future<void> _onLogsExported(
    LogsExported event,
    Emitter<SystemLogState> emit,
  ) async {
    emit(state.copyWith(
      moreLogsStatus: FormStatus.none,
      targetDeviceStatus: FormStatus.none,
      logExportStatus: FormStatus.none,
    ));

    List<dynamic> result = await _systemLogRepository.exportLogs(
      user: _user,
      logs: state.logs,
    );

    if (result[0]) {
      emit(state.copyWith(
        moreLogsStatus: FormStatus.none,
        targetDeviceStatus: FormStatus.none,
        logExportStatus: FormStatus.requestSuccess,
        logExportMsg: result[1],
        logExportFilePath: result[2],
      ));
    } else {
      emit(state.copyWith(
        moreLogsStatus: FormStatus.none,
        targetDeviceStatus: FormStatus.none,
        logExportStatus: FormStatus.requestFailure,
        logExportMsg: result[1],
        logExportFilePath: '',
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
