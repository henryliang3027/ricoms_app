part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState({
    this.status = SubmissionStatus.none,
    this.type = 1,
    this.keyword = '',
    this.searchResult = const [],
  });

  final SubmissionStatus status;
  final int type;
  final String keyword;
  final dynamic searchResult;

  SearchState copyWith({
    SubmissionStatus? status,
    int? type,
    String? keyword,
    dynamic searchResult,
  }) {
    return SearchState(
      status: status ?? this.status,
      type: type ?? this.type,
      keyword: keyword ?? this.keyword,
      searchResult: searchResult ?? this.searchResult,
    );
  }

  @override
  List<Object?> get props => [
        status,
        type,
        keyword,
        searchResult,
      ];
}
