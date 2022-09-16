part of 'filter_bloc.dart';

class FilterState extends Equatable {
  const FilterState({
    this.startDate = '',
    this.endDate = '',
    this.keyword = '',
    this.queries = const [],
  });

  final String startDate;
  final String endDate;
  final String keyword;
  final List<String> queries;

  FilterState copyWith({
    String? startDate,
    String? endDate,
    String? keyword,
    List<String>? queries,
  }) {
    return FilterState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      keyword: keyword ?? this.keyword,
      queries: queries ?? this.queries,
    );
  }

  @override
  List<Object> get props => [
        startDate,
        endDate,
        keyword,
        queries,
      ];
}
