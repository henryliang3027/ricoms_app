import 'package:formz/formz.dart';

enum ValidationError { formatError }

abstract class CustomInput extends FormzInput<String, ValidationError> {
  const CustomInput.pure() : super.pure('');
  const CustomInput.dirty([String value = '']) : super.dirty(value);
}

class IPv4 extends CustomInput {
  const IPv4.pure() : super.pure();
  const IPv4.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    RegExp ipRegex = RegExp(
        r'^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$');

    if (value.isEmpty) {
      return null;
    } else {
      if (!ipRegex.hasMatch(value)) {
        return ValidationError.formatError;
      } else {
        return null;
      }
    }
  }

  @override
  String toString() {
    return value;
  }
}

class IPv6 extends CustomInput {
  const IPv6.pure() : super.pure();
  const IPv6.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    if (value.length > 23) {
      return ValidationError.formatError;
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return value;
  }
}

class Input6 extends CustomInput {
  const Input6.pure() : super.pure();
  const Input6.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    if (value.length > 6) {
      return ValidationError.formatError;
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return value;
  }
}

class Input7 extends CustomInput {
  const Input7.pure() : super.pure();
  const Input7.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    if (value.length > 7) {
      return ValidationError.formatError;
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return value;
  }
}

class Input8 extends CustomInput {
  const Input8.pure() : super.pure();
  const Input8.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    if (value.length > 8) {
      return ValidationError.formatError;
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return value;
  }
}

class Input31 extends CustomInput {
  const Input31.pure() : super.pure();
  const Input31.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    if (value.length > 31) {
      return ValidationError.formatError;
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return value;
  }
}

class Input63 extends CustomInput {
  const Input63.pure() : super.pure();
  const Input63.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    if (value.length > 63) {
      return ValidationError.formatError;
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return value;
  }
}

class InputInfinity extends CustomInput {
  const InputInfinity.pure() : super.pure();
  const InputInfinity.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    return null;
  }

  @override
  String toString() {
    return value;
  }
}
