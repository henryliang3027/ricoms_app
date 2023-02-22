import 'package:formz/formz.dart';

enum ValidationError { formatError }

abstract class CustomInput extends FormzInput<String, ValidationError> {
  const CustomInput.pure(String value) : super.pure(value);
  const CustomInput.dirty([String value = '']) : super.dirty(value);
}

class IPv4 extends CustomInput {
  const IPv4.pure(String value) : super.pure(value);
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
  const IPv6.pure(String value) : super.pure(value);
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
  const Input6.pure(String value) : super.pure(value);
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
  const Input7.pure(String value) : super.pure(value);
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
  const Input8.pure(String value) : super.pure(value);
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
  const Input31.pure(String value) : super.pure(value);
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
  const Input63.pure(String value) : super.pure(value);
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
  const InputInfinity.pure(String value) : super.pure(value);
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
