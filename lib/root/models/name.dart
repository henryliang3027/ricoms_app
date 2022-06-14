import 'package:formz/formz.dart';

enum NameValidationError { formatError }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String? value) {
    if (value == null) {
      return NameValidationError.formatError;
    } else {
      if (value.isEmpty) {
        return NameValidationError.formatError;
      } else {
        return null;
      }
    }
  }
}
