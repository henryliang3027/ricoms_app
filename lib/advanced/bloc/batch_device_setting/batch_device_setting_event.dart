part of 'batch_device_setting_bloc.dart';

abstract class BatchDeviceSettingEvent extends Equatable {
  const BatchDeviceSettingEvent();
}

class ModuleDataRequested extends BatchDeviceSettingEvent {
  const ModuleDataRequested();

  @override
  List<Object?> get props => [];
}

class KeywordChanged extends BatchDeviceSettingEvent {
  const KeywordChanged(this.keyword);

  final String keyword;

  @override
  List<Object?> get props => [keyword];
}

class ModuleDataSearched extends BatchDeviceSettingEvent {
  const ModuleDataSearched();

  @override
  List<Object?> get props => [];
}
