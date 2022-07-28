import 'package:formz/formz.dart';

enum AccountValidationError { formatError }

class Account extends FormzInput<String, AccountValidationError> {
  const Account.pure() : super.pure('');
  const Account.dirty([String value = '']) : super.dirty(value);

  @override
  AccountValidationError? validator(String? value) {
    if (value == null) {
      return AccountValidationError.formatError;
    } else {
      if (value.isEmpty) {
        return AccountValidationError.formatError;
      } else {
        return null;
      }
    }
  }
}
