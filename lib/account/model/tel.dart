import 'package:formz/formz.dart';

enum TelValidationError { formatError }

class Tel extends FormzInput<String, TelValidationError> {
  const Tel.pure() : super.pure('');
  const Tel.dirty([String value = '']) : super.dirty(value);

  @override
  TelValidationError? validator(String? value) {
    RegExp telRegex = RegExp(r'^[0-9\+\- ]+$');
    if (value != null && value.isNotEmpty) {
      if (!telRegex.hasMatch(value)) {
        return TelValidationError.formatError;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
