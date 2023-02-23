import 'package:ricoms_app/repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:ricoms_app/login/models/username.dart';
import 'package:ricoms_app/login/models/password.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/root/models/custom_input.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginIPChanged>(_onLoginIPChanged);
    on<LoginUsernameChanged>(_onLoginUsernameChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
    on<LoginPasswordVisibilityChanged>(_onLoginPasswordVisibilityChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onLoginIPChanged(
    LoginIPChanged event,
    Emitter<LoginState> emit,
  ) {
    final ip = IPv4.dirty(event.ip);
    emit(
      state.copyWith(
        ip: ip,
        status: Formz.validate([ip, state.username, state.password]),
      ),
    );
  }

  void _onLoginUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        status: Formz.validate([state.ip, username, state.password]),
      ),
    );
  }

  void _onLoginPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([state.ip, state.username, password]),
      ),
    );
  }

  void _onLoginPasswordVisibilityChanged(
    LoginPasswordVisibilityChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
        status: Formz.validate([state.ip, state.username, state.password]),
        passwordVisibility: !state.passwordVisibility));
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      List<dynamic> resultOfLogIn = await _authenticationRepository.logIn(
        ip: state.ip.value,
        account: state.username.value,
        password: state.password.value,
      );

      if (!resultOfLogIn[0]) {
        String errmsg = resultOfLogIn[1];
        emit(state.copyWith(
            status: FormzStatus.submissionFailure, errmsg: errmsg));
      }
    }
  }
}
