class SearchCriteria {
  const SearchCriteria({
    this.startDate = '',
    this.endDate = '',
    this.shelf = '',
    this.slot = '',
    this.unsolvedOnly = false,
    this.queries = const [],
  });

  final String startDate;
  final String endDate;
  final String shelf;
  final String slot;
  final bool unsolvedOnly;
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
