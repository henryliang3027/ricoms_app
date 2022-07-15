import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/authentication_repository.dart';
import 'package:ricoms_app/repository/user.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  void _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    {
      switch (event.status) {
        case AuthenticationStatus.unauthenticated:
          return emit(const AuthenticationState.unauthenticated(errmsg: ''));
        case AuthenticationStatus.authenticated:
          final user = _authenticationRepository.userApi
              .getActivateUser(); //get current login user, activate is true

          // print(user!.id);
          return emit(
            user != null
                ? AuthenticationState.authenticated(user)
                : const AuthenticationState.unauthenticated(errmsg: ''),
          );
        case AuthenticationStatus.unknown:
          return emit(const AuthenticationState.unauthenticated(
              errmsg:
                  'Please try to login again. Make sure you are on the same domain as the server.'));
      }
    }
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut(userId: event.userId);
  }
}
