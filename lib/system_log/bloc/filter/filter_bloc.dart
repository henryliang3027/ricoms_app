import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/system_log/model/filter_critria.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc({
    required FilterCriteria filterCriteria,
  })  : _filterCriteria = filterCriteria,
        super(const FilterState()) {
    on<StartDateChanged>(_onStartDateChanged);
    on<EndDateChanged>(_onEndDateChanged);
    on<KeywordChanged>(_onKeywordChanged);
    on<FilterInitialized>(_onFilterInitialized);
    on<FilterDeleted>(_onFilterDeleted);
    on<FilterCleared>(_onFilterCleared);
    on<CriteriaSaved>(_onCriteriaSaved);

    add(FilterInitialized(_filterCriteria));
  }

  final FilterCriteria _filterCriteria;

  void _onKeywordChanged(
    KeywordChanged event,
    Emitter<FilterState> emit,
  ) {
    emit(state.copyWith(
      startDate: state.startDate,
      endDate: state.endDate,
      keyword: event.keyword,
      queries: state.queries,
    ));
  }

  void _onStartDateChanged(
    StartDateChanged event,
    Emitter<FilterState> emit,
  ) {
    String formattedStartDate = event.startDate.replaceAll('/', '');
    String formattedEndDate = state.endDate.replaceAll('/', '');

    if (formattedEndDate == '') {
      //if start date and end date are empty string ''
      formattedEndDate = formattedStartDate;
    }

    DateTime startDate = DateTime.parse(formattedStartDate);
    DateTime endDate = DateTime.parse(formattedEndDate);

    String displayStartDate =
        DateFormat('yyyy-MM-dd').format(startDate).toString();
    String displayEndDate = DateFormat('yyyy-MM-dd').format(endDate).toString();

    //if end date should earlier than start date, then asign start date,
    //otherwise, asign end date
    String validEndDate =
        endDate.isAfter(startDate) ? displayEndDate : displayStartDate;
    String date = '$displayStartDate - $validEndDate';
    List<String> queries = [];
    queries.addAll(state.queries); // add current queries

    _updateDateInQureies(queries, date);

    emit(state.copyWith(
      startDate: displayStartDate,
      endDate: validEndDate,
      keyword: state.keyword,
      queries: queries,
    ));
  }

  void _onEndDateChanged(
    EndDateChanged event,
    Emitter<FilterState> emit,
  ) {
    String startDate = state.startDate;
    String endDate = event.endDate;

    if (startDate == '') {
      startDate = endDate;
    }

    String date = '$startDate - $endDate';
    List<String> queries = [];
    queries.addAll(state.queries); // add current queries

    _updateDateInQureies(queries, date);

    emit(state.copyWith(
      startDate: startDate,
      endDate: endDate,
      keyword: state.keyword,
      queries: queries,
    ));
  }

  void _onFilterInitialized(
    FilterInitialized event,
    Emitter<FilterState> emit,
  ) {
    FilterCriteria initCriteria = event.filterCriteria;

    List<String> queries = [];

    //Add date additionally because queries from HistoryForm does not contain date
    if (initCriteria.startDate != '' && initCriteria.endDate != '') {
      String date = '${initCriteria.startDate} - ${initCriteria.endDate}';
      queries.add(date);
    }
    queries.addAll(initCriteria.queries);

    emit(state.copyWith(
      startDate: initCriteria.startDate,
      endDate: initCriteria.endDate,
      keyword: state.keyword,
      queries: queries,
    ));
  }

  void _onFilterDeleted(
    FilterDeleted event,
    Emitter<FilterState> emit,
  ) {
    List<String> queries = [];
    queries.addAll(state.queries); // add current queries

    if (isDateQuery(queries[event.index])) {
      queries.removeAt(event.index); // remove query by index
      emit(state.copyWith(
        startDate: '',
        endDate: '',
        keyword: state.keyword,
        queries: queries,
      ));
    } else {
      queries.removeAt(event.index); // remove query by index
      emit(state.copyWith(
        startDate: state.startDate,
        endDate: state.endDate,
        keyword: state.keyword,
        queries: queries,
      ));
    }
  }

  void _onFilterCleared(
    FilterCleared event,
    Emitter<FilterState> emit,
  ) {
    emit(state.copyWith(
      startDate: '',
      endDate: '',
      keyword: '',
      queries: [],
    ));
  }

  void _onCriteriaSaved(
    CriteriaSaved event,
    Emitter<FilterState> emit,
  ) {
    List<String> queries = [];
    queries.addAll(state.queries); // add current queries

    if (state.keyword.isNotEmpty) {
      if (!queries.contains(state.keyword)) {
        queries.add(state.keyword); // add new query from keyword
      }
    }

    List<String> keywordQueries = [];
    if (queries.isNotEmpty) {
      if (isDateQuery(queries[0])) {
        keywordQueries.addAll(queries.skip(1));
      } else {
        keywordQueries.addAll(queries);
      }
    }

    FilterCriteria filterCriteria = FilterCriteria(
      startDate: state.startDate,
      endDate: state.endDate,
      queries: keywordQueries,
    );

    Navigator.pop(event.context, filterCriteria);
  }

  // if query is date, it should be add/update in the first index
  void _updateDateInQureies(List<String> queries, String date) {
    if (queries.isNotEmpty) {
      if (isDateQuery(queries[0])) {
        //if first element is date, replace it with new date
        queries[0] = date;
      } else {
        //other keywords have existed, insert date at first index
        queries.insert(0, date);
      }
    } else {
      queries.add(date);
    }
  }
}
