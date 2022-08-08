part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = const User.empty(),
    this.userFunctionMap = const {},
    this.errmsg = '',
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(
    User user,
    Map<int, bool> userFunctionMap,
  ) : this._(
          status: AuthenticationStatus.authenticated,
          user: user,
          userFunctionMap: userFunctionMap,
        );

  const AuthenticationState.unauthenticated({
    required String errmsg,
  }) : this._(
          status: AuthenticationStatus.unauthenticated,
          errmsg: errmsg,
        );

  final AuthenticationStatus status;
  final User user;
  final Map<int, bool> userFunctionMap;

  // lost connection after login, pop message if auto login failed
  final String errmsg;

  @override
  List<Object> get props => [
        status,
        user,
        userFunctionMap,
        errmsg,
      ];
}
