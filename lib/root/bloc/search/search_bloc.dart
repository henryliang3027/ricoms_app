import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:ricoms_app/repository/root_repository/root_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required User user,
    required RootRepository rootRepository,
  })  : _user = user,
        _rootRepository = rootRepository,
        super(const SearchState()) {
    on<SearchTypeChanged>(_onSearchTypeChanged);
    on<KeywordChanged>(_onKeywordChanged);
    on<SearchDataSubmitted>(_onSearchDataSubmitted);
  }

  final User _user;
  final RootRepository _rootRepository;

  // 處理搜尋類型的更改
  void _onSearchTypeChanged(
    SearchTypeChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(
      status: SubmissionStatus.none,
      type: event.type,
    ));
  }

  // 處理關鍵字的更改
  void _onKeywordChanged(
    KeywordChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(
      status: SubmissionStatus.none,
      keyword: event.keyword,
    ));
  }

  // 處理搜尋條件(關鍵字, 類型)的提交, 提交給後端
  Future<void> _onSearchDataSubmitted(
    SearchDataSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(
      status: SubmissionStatus.submissionInProgress,
    ));

    List<dynamic> result = await _rootRepository.searchNodes(
      user: _user,
      type: state.type,
      keyword: state.keyword,
    );

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
}
