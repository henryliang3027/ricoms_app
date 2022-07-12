part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState({
    this.startDate = '',
    this.endDate = '',
    this.shelf = '',
    this.slot = '',
    this.unsolvedOnly = false,
    this.keyword = '',
    this.queries = const [],
  });

  final String startDate;
  final String endDate;
  final String shelf;
  final String slot;
  final bool unsolvedOnly;
  final String keyword;
  final List<String> queries;

  SearchState copyWith({
    String? startDate,
    String? endDate,
    String? shelf,
    String? slot,
    bool? unsolvedOnly,
    String? keyword,
    List<String>? queries,
  }) {
    return SearchState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      shelf: shelf ?? this.shelf,
      slot: slot ?? this.slot,
      unsolvedOnly: unsolvedOnly ?? this.unsolvedOnly,
      keyword: keyword ?? this.keyword,
      queries: queries ?? this.queries,
    );
  }

  @override
  List<Object> get props => [
        startDate,
        endDate,
        shelf,
        slot,
        unsolvedOnly,
        keyword,
        queries,
      ];
}
