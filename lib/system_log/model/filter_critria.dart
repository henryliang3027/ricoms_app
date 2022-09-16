class FilterCriteria {
  const FilterCriteria({
    this.startDate = '',
    this.endDate = '',
    this.queries = const [],
  });

  final String startDate;
  final String endDate;
  final List<String> queries;
}
