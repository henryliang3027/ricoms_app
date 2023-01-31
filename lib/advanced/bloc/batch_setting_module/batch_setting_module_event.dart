part of 'batch_setting_module_bloc.dart';

abstract class BatchSettingModuleEvent extends Equatable {
  const BatchSettingModuleEvent();
}

class ModuleDataRequested extends BatchSettingModuleEvent {
  const ModuleDataRequested();

  @override
  List<Object?> get props => [];
}

class KeywordChanged extends BatchSettingModuleEvent {
  const KeywordChanged(this.keyword);

  final String keyword;

  @override
  List<Object?> get props => [keyword];
}

class ModuleDataSearched extends BatchSettingModuleEvent {
  const ModuleDataSearched();

  @override
  List<Object?> get props => [];
}
