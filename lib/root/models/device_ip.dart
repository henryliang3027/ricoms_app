import 'package:formz/formz.dart';

enum DeviceIPValidationError { formatError }

class DeviceIP extends FormzInput<String, DeviceIPValidationError> {
  const DeviceIP.pure() : super.pure('');
  const DeviceIP.dirty([String value = '']) : super.dirty(value);

  @override
  DeviceIPValidationError? validator(String? value) {
    RegExp ipRegex = RegExp(
        r'^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$');
    if (value == null) {
      return DeviceIPValidationError.formatError;
    } else {
      if (!ipRegex.hasMatch(value)) {
        return DeviceIPValidationError.formatError;
      } else {
        return null;
      }
    }
  }
}
