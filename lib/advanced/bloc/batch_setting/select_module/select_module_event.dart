part of 'select_module_bloc.dart';

abstract class SelectModuleEvent extends Equatable {
  const SelectModuleEvent();
}

class ModuleDataRequested extends SelectModuleEvent {
  const ModuleDataRequested();

  @override
  List<Object?> get props => [];
}

class KeywordSearched extends SelectModuleEvent {
  const KeywordSearched(this.keyword);

  final String keyword;

  @override
  List<Object?> get props => [keyword];
}

class KeywordCleared extends SelectModuleEvent {
  const KeywordCleared();

  @override
  List<Object?> get props => [];
}
