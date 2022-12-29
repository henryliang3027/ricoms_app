part of 'server_ip_setting_bloc.dart';

abstract class ServerIPSettingEvent extends Equatable {
  const ServerIPSettingEvent();
}

class ServerIPSettingRequested extends ServerIPSettingEvent {
  const ServerIPSettingRequested();

  @override
  List<Object?> get props => [];
}

class MasterServerIPChanged extends ServerIPSettingEvent {
  const MasterServerIPChanged(this.masterServerIP);

  final String masterServerIP;

  @override
  List<Object?> get props => [masterServerIP];
}

class SlaveServerIPChanged extends ServerIPSettingEvent {
  const SlaveServerIPChanged(this.slaveServerIP);

  final String slaveServerIP;

  @override
  List<Object?> get props => [slaveServerIP];
}

class SynchronizationIntervalChanged extends ServerIPSettingEvent {
  const SynchronizationIntervalChanged(this.synchronizationInterval);

  final String synchronizationInterval;

  @override
  List<Object?> get props => [synchronizationInterval];
}

class OnlineServerIPChanged extends ServerIPSettingEvent {
  const OnlineServerIPChanged(this.onlineServerIP);

  final String onlineServerIP;

  @override
  List<Object?> get props => [onlineServerIP];
}

class EditModeEnabled extends ServerIPSettingEvent {
  const EditModeEnabled();

  @override
  List<Object?> get props => [];
}

class EditModeDisabled extends ServerIPSettingEvent {
  const EditModeDisabled();

  @override
  List<Object?> get props => [];
}

class ServerIPSettingSaved extends ServerIPSettingEvent {
  const ServerIPSettingSaved();

  @override
  List<Object?> get props => [];
}
