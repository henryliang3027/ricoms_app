import 'package:formz/formz.dart';

enum MobileValidationError { formatError }

class Mobile extends FormzInput<String, MobileValidationError> {
  const Mobile.pure() : super.pure('');
  const Mobile.dirty([String value = '']) : super.dirty(value);

  @override
  MobileValidationError? validator(String? value) {
    RegExp mobileRegex = RegExp(r'^[0-9\+\- ]+$');
    if (value != null && value.isNotEmpty) {
      if (!mobileRegex.hasMatch(value)) {
        return MobileValidationError.formatError;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
