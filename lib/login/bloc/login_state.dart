part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
    this.ip = const IP.pure(),
    this.username = const Username.pure(),
    this.password = const Password.pure(),
  });

  final FormzStatus status;
  final IP ip;
  final Username username;
  final Password password;

  LoginState copyWith({
    FormzStatus? status,
    IP? ip,
    Username? username,
    Password? password,
  }) {
    return LoginState(
      status: status ?? this.status,
      ip: ip ?? this.ip,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [status, ip, username, password];
}
