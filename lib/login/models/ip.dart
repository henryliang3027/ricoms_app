import 'package:formz/formz.dart';

enum IPValidationError { empty }

class IP extends FormzInput<String, IPValidationError> {
  const IP.pure() : super.pure('');
  const IP.dirty([String value = '']) : super.dirty(value);

  @override
  IPValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : IPValidationError.empty;
  }
}
