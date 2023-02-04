part of 'select_module_bloc.dart';

abstract class SelectModuleEvent extends Equatable {
  const SelectModuleEvent();
}

class ModuleDataRequested extends SelectModuleEvent {
  const ModuleDataRequested();

  @override
  List<Object?> get props => [];
}

class KeywordChanged extends SelectModuleEvent {
  const KeywordChanged(this.keyword);

  final String keyword;

  @override
  List<Object?> get props => [keyword];
}

class ModuleDataSearched extends SelectModuleEvent {
  const ModuleDataSearched();

  @override
  List<Object?> get props => [];
}
