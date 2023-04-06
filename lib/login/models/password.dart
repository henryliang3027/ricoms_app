import 'package:formz/formz.dart';

enum PasswordValidationError { formatError }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String? value) {
    if (value == null) {
      return PasswordValidationError.formatError;
    } else {
      if (value.length < 4 || value.length > 32) {
        return PasswordValidationError.formatError;
      } else {
        return null;
      }
    }
  }
}
