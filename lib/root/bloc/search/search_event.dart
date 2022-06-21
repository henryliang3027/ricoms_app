part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchTypeChanged extends SearchEvent {
  const SearchTypeChanged(this.type);

  final int type;

  @override
  List<Object?> get props => [type];
}

class KeywordChanged extends SearchEvent {
  const KeywordChanged(this.keyword);

  final String keyword;

  @override
  List<Object?> get props => [keyword];
}

class SearchDataSubmitted extends SearchEvent {
  const SearchDataSubmitted();

  @override
  List<Object?> get props => [];
}

class NodeTapped extends SearchEvent {
  const NodeTapped(this.node, this.context);

  final Node node;
  final BuildContext context;

  @override
  List<Object?> get props => [node];
}
