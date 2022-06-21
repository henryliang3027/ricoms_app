import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/view/device_setting_page.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(
      {required RootRepository rootRepository,
      required DeviceRepository deviceRepository})
      : _rootRepository = rootRepository,
        _deviceRepository = deviceRepository,
        super(const SearchState()) {
    on<SearchTypeChanged>(_onSearchTypeChanged);
    on<KeywordChanged>(_onKeywordChanged);
    on<SearchDataSubmitted>(_onSearchDataSubmitted);
    on<NodeTapped>(_onNodeTapped);
  }

  final RootRepository _rootRepository;
  final DeviceRepository _deviceRepository;

  void _onSearchTypeChanged(
    SearchTypeChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(
      status: SubmissionStatus.none,
      type: event.type,
    ));
  }

  void _onKeywordChanged(
    KeywordChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(
      status: SubmissionStatus.none,
      keyword: event.keyword,
    ));
  }

  Future<void> _onSearchDataSubmitted(
    SearchDataSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(
      status: SubmissionStatus.submissionInProgress,
    ));

    List<dynamic> result = await _rootRepository.searchNodes(
        type: state.type, keyword: state.keyword);

    if (result[0]) {
      emit(state.copyWith(
        status: SubmissionStatus.submissionSuccess,
        searchResult:
            (result[1] as List).isNotEmpty ? result[1] : 'No results found.',
      ));
    } else {
      emit(state.copyWith(
        status: SubmissionStatus.submissionFailure,
        searchResult: 'No results found.',
      ));
    }
  }

  void _onNodeTapped(
    NodeTapped event,
    Emitter<SearchState> emit,
  ) {
    _deviceRepository.deviceNodeId = event.node.id.toString();
    Navigator.push(
        event.context, DeviceSettingPage.route(_deviceRepository, event.node));
  }
}
