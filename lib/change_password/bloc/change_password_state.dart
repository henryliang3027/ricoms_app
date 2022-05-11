part of 'change_password_bloc.dart';

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.status = FormzStatus.pure,
    this.currentPassword = const Password.pure(),
    this.currentPasswordVisibility = false,
    this.newPassword = const Password.pure(),
    this.newPasswordVisibility = false,
    this.confirmPassword = const Password.pure(),
    this.confirmPasswordVisibility = false,
  });

  final FormzStatus status;
  final Password currentPassword;
  final bool currentPasswordVisibility;
  final Password newPassword;
  final bool newPasswordVisibility;
  final Password confirmPassword;
  final bool confirmPasswordVisibility;

  ChangePasswordState copyWith({
    FormzStatus? status,
    Password? currentPassword,
    bool? currentPasswordVisibility,
    Password? newPassword,
    bool? newPasswordVisibility,
    Password? confirmPassword,
    bool? confirmPasswordVisibility,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      currentPassword: currentPassword ?? this.currentPassword,
      currentPasswordVisibility:
          currentPasswordVisibility ?? this.confirmPasswordVisibility,
      newPassword: newPassword ?? this.newPassword,
      newPasswordVisibility:
          newPasswordVisibility ?? this.newPasswordVisibility,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      confirmPasswordVisibility:
          confirmPasswordVisibility ?? this.confirmPasswordVisibility,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentPassword,
        currentPasswordVisibility,
        newPassword,
        newPasswordVisibility,
        confirmPassword,
        confirmPasswordVisibility
      ];
}
