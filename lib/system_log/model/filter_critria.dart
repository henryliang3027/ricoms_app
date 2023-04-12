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

bool isDateQuery(String query) {
  RegExp dateRegex = RegExp(r'^([0-9]+-[0-9]+-[0-9]+ - [0-9]+-[0-9]+-[0-9]+)$');
  if (dateRegex.hasMatch(query)) {
    return true;
  } else {
    return false;
  }
}
