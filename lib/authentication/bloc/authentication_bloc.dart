import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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
    _authenticationStatusSubscription = _authenticationRepository.report.listen(
      (report) => add(AuthenticationStatusChanged(report)),
    );

    final dataStream =
        Stream<int>.periodic(const Duration(seconds: 3), (count) => count);

    _permissionStatusSubscription = dataStream.listen((event) async {
      var result = await _authenticationRepository.checkUserPermission();

      if (kDebugMode) {
        print('permission change: ${result[1]}');
      }

      if (result[0]) {
        if (result[1]) {
          if (state.status == AuthenticationStatus.authenticated) {
            add(const AuthenticationStatusChanged(AuthenticationReport(
              status: AuthenticationStatus.unauthenticated,
            )));
          }
        }
      }
    });
  }

  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<AuthenticationReport>
      _authenticationStatusSubscription;

  late StreamSubscription<int> _permissionStatusSubscription;

  @override
  Future<void> close() {
    _permissionStatusSubscription.cancel();
    _authenticationStatusSubscription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  void _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    {
      switch (event.report.status) {
        case AuthenticationStatus.unauthenticated:
          return emit(AuthenticationState.unauthenticated(
            msgTitle: event.report.msgTitle,
            msg: event.report.msg,
          ));
        case AuthenticationStatus.authenticated:
          return emit(AuthenticationState.authenticated(
            event.report.user,
            event.report.userFunction,
          ));
      }
    }
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut(user: event.user);
  }
}
