part of 'default_setting_bloc.dart';

abstract class DefaultSettingEvent extends Equatable {
  const DefaultSettingEvent();
}

class DefaultSettingRequested extends DefaultSettingEvent {
  const DefaultSettingRequested();

  @override
  List<Object?> get props => [];
}

class DefaultSettingItemToggled extends DefaultSettingEvent {
  const DefaultSettingItemToggled(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class AllItemsSelected extends DefaultSettingEvent {
  const AllItemsSelected();

  @override
  List<Object?> get props => [];
}

class EditModeEnabled extends DefaultSettingEvent {
  const EditModeEnabled();

  @override
  List<Object?> get props => [];
}

class EditModeDisabled extends DefaultSettingEvent {
  const EditModeDisabled();

  @override
  List<Object?> get props => [];
}

class DefaultSettingSaved extends DefaultSettingEvent {
  const DefaultSettingSaved();

  @override
  List<Object?> get props => [];
}
