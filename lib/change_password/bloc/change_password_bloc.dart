import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/login/models/password.dart';
import 'package:ricoms_app/repository/authentication_repository.dart';
part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const ChangePasswordState()) {
    on<CurrentPasswordChanged>(_onCurrentPasswordChanged);
    on<CurrentPasswordVisibilityChanged>(_onCurrentPasswordVisibilityChanged);
    on<NewPasswordChanged>(_onNewPasswordChanged);
    on<NewPasswordVisibilityChanged>(_onNewPasswordVisibilityChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<ConfirmPasswordVisibilityChanged>(_onConfirmPasswordVisibilityChanged);
    on<PasswordSubmitted>(_onPasswordSubmmited);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onCurrentPasswordChanged(
    CurrentPasswordChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    final currentPassword = Password.dirty(event.currentPassword);
    emit(
      state.copyWith(
        currentPassword: currentPassword,
        status: Formz.validate(
            [currentPassword, state.newPassword, state.confirmPassword]),
      ),
    );
  }

  void _onCurrentPasswordVisibilityChanged(
    CurrentPasswordVisibilityChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(
        currentPasswordVisibility: !state.currentPasswordVisibility));
  }

  void _onNewPasswordChanged(
    NewPasswordChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    final newPassword = Password.dirty(event.newPassword);
    emit(
      state.copyWith(
        newPassword: newPassword,
        status: Formz.validate(
            [state.currentPassword, newPassword, state.confirmPassword]),
      ),
    );
  }

  void _onNewPasswordVisibilityChanged(
    NewPasswordVisibilityChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(newPasswordVisibility: !state.newPasswordVisibility));
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    final confirmPassword = Password.dirty(event.confirmPassword);
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        status: Formz.validate(
            [state.currentPassword, state.newPassword, confirmPassword]),
      ),
    );
  }

  void _onConfirmPasswordVisibilityChanged(
    ConfirmPasswordVisibilityChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(
        confirmPasswordVisibility: !state.confirmPasswordVisibility));
  }

  Future<void> _onPasswordSubmmited(
    PasswordSubmitted event,
    Emitter<ChangePasswordState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      if (state.newPassword.value != state.confirmPassword.value) {
        //check if new password is the same as confirm password
        String errmsg =
            'Your confirmation password does not match the new password.';
        emit(state.copyWith(
            errmsg: errmsg, status: FormzStatus.submissionFailure));
      } else {
        // new password is the same as confirm password
        String errmsg = await _authenticationRepository.changePassword(
            currentPassword: state.currentPassword.value,
            newPassword: state.newPassword.value);

        if (errmsg == '') {
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        } else {
          emit(state.copyWith(
              errmsg: errmsg, status: FormzStatus.submissionFailure));
        }
      }
    }
  }
}
