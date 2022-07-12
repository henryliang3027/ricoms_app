part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class StartTimeChanged extends SearchEvent {
  const StartTimeChanged(this.startTime);

  final String startTime;

  @override
  List<Object?> get props => [startTime];
}

class EndTimeChanged extends SearchEvent {
  const EndTimeChanged(this.endTime);

  final String endTime;

  @override
  List<Object?> get props => [endTime];
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
  const CurrentIssueChanged(this.current);

  final bool current;

  @override
  List<Object?> get props => [current];
}

class KeywordChanged extends SearchEvent {
  const KeywordChanged(this.keyword);

  final String keyword;

  @override
  List<Object?> get props => [keyword];
}

class FilterChanged extends SearchEvent {
  const FilterChanged();

  @override
  List<Object?> get props => [];
}
