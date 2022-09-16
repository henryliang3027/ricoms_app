part of 'filter_bloc.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();
}

class StartDateChanged extends FilterEvent {
  const StartDateChanged(this.startDate);

  final String startDate;

  @override
  List<Object?> get props => [startDate];
}

class EndDateChanged extends FilterEvent {
  const EndDateChanged(this.endDate);

  final String endDate;

  @override
  List<Object?> get props => [endDate];
}

class KeywordChanged extends FilterEvent {
  const KeywordChanged(this.keyword);

  final String keyword;

  @override
  List<Object?> get props => [keyword];
}

class FilterInitialized extends FilterEvent {
  const FilterInitialized(this.filterCriteria);

  final FilterCriteria filterCriteria;

  @override
  List<Object?> get props => [filterCriteria];
}

class FilterAdded extends FilterEvent {
  const FilterAdded();

  @override
  List<Object?> get props => [];
}

class FilterDeleted extends FilterEvent {
  const FilterDeleted(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class FilterCleared extends FilterEvent {
  const FilterCleared();

  @override
  List<Object?> get props => [];
}

class CriteriaSaved extends FilterEvent {
  const CriteriaSaved(this.context);

  final BuildContext context;

  @override
  List<Object?> get props => [context];
}
