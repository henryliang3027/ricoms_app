part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unauthenticated,
    this.user = const User.empty(),
    this.userFunctionMap = const {},
    this.msgTitle = '',
    this.msg = '',
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
    required String msgTitle,
    required String msg,
  }) : this._(
          status: AuthenticationStatus.unauthenticated,
          msgTitle: msgTitle,
          msg: msg,
        );

  final AuthenticationStatus status;
  final User user;
  final Map<int, bool> userFunctionMap;
  final String msgTitle;
  final String msg;

  @override
  List<Object> get props => [
        status,
        user,
        userFunctionMap,
        msgTitle,
        msg,
      ];
}
