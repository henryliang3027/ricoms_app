import 'package:formz/formz.dart';

enum PasswordValidationError { empty }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String? value) {
    if (value == null) {
      return PasswordValidationError.empty;
    } else {
      if (value.length < 4) {
        return PasswordValidationError.empty;
      } else {
        return null;
      }
    }
    // return value?.isNotEmpty == true && value!.length >= 4
    //     ? null
    //     : PasswordValidationError.empty;
  }
}
