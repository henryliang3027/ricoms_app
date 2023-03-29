part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
    this.ip = const IPv4.pure(),
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.passwordVisibility = false,
    this.errmsg = '',
  });

  final FormzStatus status;
  final IPv4 ip;
  final Username username;
  final Password password;
  final bool passwordVisibility;
  final String errmsg;

  LoginState copyWith({
    FormzStatus? status,
    IPv4? ip,
    Username? username,
    Password? password,
    bool? passwordVisibility,
    String? errmsg,
  }) {
    return LoginState(
      status: status ?? this.status,
      ip: ip ?? this.ip,
      username: username ?? this.username,
      password: password ?? this.password,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      errmsg: errmsg ?? this.errmsg,
    );
  }

  @override
  List<Object?> get props =>
      [status, ip, username, password, passwordVisibility, errmsg];
}
