part of 'batch_setting_bloc.dart';

abstract class BatchSettingEvent extends Equatable {
  const BatchSettingEvent();
}

class ModuleDataRequested extends BatchSettingEvent {
  const ModuleDataRequested();

  @override
  List<Object?> get props => [];
}

class KeywordChanged extends BatchSettingEvent {
  const KeywordChanged(this.keyword);

  final String keyword;

  @override
  List<Object?> get props => [keyword];
}

class ModuleDataSearched extends BatchSettingEvent {
  const ModuleDataSearched();

  @override
  List<Object?> get props => [];
}
