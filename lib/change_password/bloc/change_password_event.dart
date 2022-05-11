part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

/// handle current password
class CurrentPasswordChanged extends ChangePasswordEvent {
  const CurrentPasswordChanged(this.currentPassword);

  final String currentPassword;

  @override
  List<Object> get props => [currentPassword];
}

// handle current password visibility
class CurrentPasswordVisibilityChanged extends ChangePasswordEvent {
  const CurrentPasswordVisibilityChanged();
}

///

/// handle new password
class NewPasswordChanged extends ChangePasswordEvent {
  const NewPasswordChanged(this.newPassword);

  final String newPassword;

  @override
  List<Object> get props => [newPassword];
}

// handle new password visibility
class NewPasswordVisibilityChanged extends ChangePasswordEvent {
  const NewPasswordVisibilityChanged();
}

///

/// handle confirm password
class ConfirmPasswordChanged extends ChangePasswordEvent {
  const ConfirmPasswordChanged(this.confirmPassword);

  final String confirmPassword;

  @override
  List<Object> get props => [confirmPassword];
}

// handle confirm password visibility
class ConfirmPasswordVisibilityChanged extends ChangePasswordEvent {
  const ConfirmPasswordVisibilityChanged();
}

///

class PasswordSubmitted extends ChangePasswordEvent {
  const PasswordSubmitted();
}
