part of 'log_record_setting_bloc.dart';

abstract class LogRecordSettingEvent extends Equatable {
  const LogRecordSettingEvent();
}

class LogRecordSettingRequested extends LogRecordSettingEvent {
  const LogRecordSettingRequested();

  @override
  List<Object?> get props => [];
}

class ArchivedHistoricalRecordQuanitiyChanged extends LogRecordSettingEvent {
  const ArchivedHistoricalRecordQuanitiyChanged(
      this.archivedHistoricalRecordQuanitiy);

  final String archivedHistoricalRecordQuanitiy;

  @override
  List<Object?> get props => [archivedHistoricalRecordQuanitiy];
}

class ApiLogPreservationEnabled extends LogRecordSettingEvent {
  const ApiLogPreservationEnabled(this.enableApiLogPreservation);

  final bool enableApiLogPreservation;

  @override
  List<Object?> get props => [enableApiLogPreservation];
}

class ApiLogPreservedQuantityChanged extends LogRecordSettingEvent {
  const ApiLogPreservedQuantityChanged(this.apiLogPreservedQuantity);

  final String apiLogPreservedQuantity;

  @override
  List<Object?> get props => [apiLogPreservedQuantity];
}

class ApiLogPreservedDaysChanged extends LogRecordSettingEvent {
  const ApiLogPreservedDaysChanged(this.apiLogPreservedDays);

  final String apiLogPreservedDays;

  @override
  List<Object?> get props => [apiLogPreservedDays];
}

class UserSystemLogPreservationEnabled extends LogRecordSettingEvent {
  const UserSystemLogPreservationEnabled(this.enableUserSystemLogPreservation);

  final bool enableUserSystemLogPreservation;

  @override
  List<Object?> get props => [enableUserSystemLogPreservation];
}

class UserSystemLogPreservedQuantityChanged extends LogRecordSettingEvent {
  const UserSystemLogPreservedQuantityChanged(
      this.userSystemLogPreservedQuantity);

  final String userSystemLogPreservedQuantity;

  @override
  List<Object?> get props => [userSystemLogPreservedQuantity];
}

class UserSystemLogPreservedDaysChanged extends LogRecordSettingEvent {
  const UserSystemLogPreservedDaysChanged(this.userSystemLogPreservedDays);

  final String userSystemLogPreservedDays;

  @override
  List<Object?> get props => [userSystemLogPreservedDays];
}

class DeviceSystemLogPreservationEnabled extends LogRecordSettingEvent {
  const DeviceSystemLogPreservationEnabled(
      this.enableDeviceSystemLogPreservation);

  final bool enableDeviceSystemLogPreservation;

  @override
  List<Object?> get props => [enableDeviceSystemLogPreservation];
}

class DeviceSystemLogPreservedQuantityChanged extends LogRecordSettingEvent {
  const DeviceSystemLogPreservedQuantityChanged(
      this.deviceSystemLogPreservedQuantity);

  final String deviceSystemLogPreservedQuantity;

  @override
  List<Object?> get props => [deviceSystemLogPreservedQuantity];
}

class DeviceSystemLogPreservedDaysChanged extends LogRecordSettingEvent {
  const DeviceSystemLogPreservedDaysChanged(this.deviceSystemLogPreservedDays);

  final String deviceSystemLogPreservedDays;

  @override
  List<Object?> get props => [deviceSystemLogPreservedDays];
}

class EditModeEnabled extends LogRecordSettingEvent {
  const EditModeEnabled();

  @override
  List<Object?> get props => [];
}

class EditModeDisabled extends LogRecordSettingEvent {
  const EditModeDisabled();

  @override
  List<Object?> get props => [];
}

class LogRecordSettingSaved extends LogRecordSettingEvent {
  const LogRecordSettingSaved();

  @override
  List<Object?> get props => [];
}
