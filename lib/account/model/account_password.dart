import 'package:formz/formz.dart';

enum AccountPasswordValidationError { empty }

class AccountPassword
    extends FormzInput<String, AccountPasswordValidationError> {
  const AccountPassword.pure() : super.pure('');
  const AccountPassword.dirty([String value = '']) : super.dirty(value);

  @override
  AccountPasswordValidationError? validator(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length < 4) {
        return AccountPasswordValidationError.empty;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
