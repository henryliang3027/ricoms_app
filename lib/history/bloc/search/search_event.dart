part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class StartDateChanged extends SearchEvent {
  const StartDateChanged(this.startDate);

  final String startDate;

  @override
  List<Object?> get props => [startDate];
}

class EndDateChanged extends SearchEvent {
  const EndDateChanged(this.endDate);

  final String endDate;

  @override
  List<Object?> get props => [endDate];
}

class ShelfChanged extends SearchEvent {
  const ShelfChanged(this.shelf);

  final String shelf;

  @override
  List<Object?> get props => [shelf];
}

class SlotChanged extends SearchEvent {
  const SlotChanged(this.slot);

  final String slot;

  @override
  List<Object?> get props => [slot];
}

class CurrentIssueChanged extends SearchEvent {
  const CurrentIssueChanged(this.unsolvedOnly);

  final bool unsolvedOnly;

  @override
  List<Object?> get props => [unsolvedOnly];
}

class KeywordChanged extends SearchEvent {
  const KeywordChanged(this.keyword);

  final String keyword;

  @override
  List<Object?> get props => [keyword];
}

class FilterInitialized extends SearchEvent {
  const FilterInitialized(this.searchCriteria);

  final SearchCriteria searchCriteria;

  @override
  List<Object?> get props => [searchCriteria];
}

class FilterAdded extends SearchEvent {
  const FilterAdded();

  @override
  List<Object?> get props => [];
}

class FilterDeleted extends SearchEvent {
  const FilterDeleted(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class CriteriaSaved extends SearchEvent {
  const CriteriaSaved(this.context);

  final BuildContext context;

  @override
  List<Object?> get props => [context];
}
