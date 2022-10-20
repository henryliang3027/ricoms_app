import 'package:formz/formz.dart';

enum ExtValidationError { formatError }

class Ext extends FormzInput<String, ExtValidationError> {
  const Ext.pure() : super.pure('');
  const Ext.dirty([String value = '']) : super.dirty(value);

  @override
  ExtValidationError? validator(String? value) {
    RegExp extRegex = RegExp(r'^[0-9\+\- ]+$');
    if (value != null && value.isNotEmpty) {
      if (!extRegex.hasMatch(value)) {
        return ExtValidationError.formatError;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
