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

    final dataStream =
        Stream<int>.periodic(const Duration(seconds: 3), (count) => count);

    _permissionStatusSubscription = dataStream.listen((event) async {
      var result = await _authenticationRepository.checkUserPermission();

      print('permission change: ${result[1]}');

      if (result[0]) {
        if (result[1]) {
          if (state.status == AuthenticationStatus.authenticated) {
            add(const AuthenticationStatusChanged(
                AuthenticationStatus.unauthenticated));
          }
        }
      }
    });
  }

  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<AuthenticationStatus>
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
      switch (event.status) {
        case AuthenticationStatus.unauthenticated:
          return emit(const AuthenticationState.unauthenticated(errmsg: ''));
        case AuthenticationStatus.authenticated:
          //get current login user which activate flag is true
          final user = _authenticationRepository.userApi.getActivateUser();
          final resultOfUserFunctions =
              await _authenticationRepository.getUserFunctions();

          if (user != null) {
            if (resultOfUserFunctions[0]) {
              final Map<int, bool> userFunctionMap = resultOfUserFunctions[1];
              return emit(AuthenticationState.authenticated(
                user,
                userFunctionMap,
              ));
            } else {
              return emit(
                //get user function failed
                AuthenticationState.unauthenticated(
                    errmsg: resultOfUserFunctions[1]),
              );
            }
          } else {
            //user does not exist
            return emit(
              const AuthenticationState.unauthenticated(errmsg: ''),
            );
          }

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
