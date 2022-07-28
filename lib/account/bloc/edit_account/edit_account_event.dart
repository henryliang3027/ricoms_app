part of 'edit_account_bloc.dart';

abstract class EditAccountEvent extends Equatable {
  const EditAccountEvent();

  @override
  List<Object> get props => [];
}

class AccountChanged extends EditAccountEvent {
  const AccountChanged(this.account);

  final String account;

  @override
  List<Object> get props => [account];
}

class PasswordChanged extends EditAccountEvent {
  const PasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class NameChanged extends EditAccountEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class PermissionChanged extends EditAccountEvent {
  const PermissionChanged(this.permission);

  final int permission;

  @override
  List<Object> get props => [permission];
}

class DepartmentChanged extends EditAccountEvent {
  const DepartmentChanged(this.department);

  final String department;

  @override
  List<Object> get props => [department];
}

class EmailChanged extends EditAccountEvent {
  const EmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class MobileChanged extends EditAccountEvent {
  const MobileChanged(this.mobile);

  final String mobile;

  @override
  List<Object> get props => [mobile];
}

class TelChanged extends EditAccountEvent {
  const TelChanged(this.tel);

  final String tel;

  @override
  List<Object> get props => [tel];
}

class ExtChanged extends EditAccountEvent {
  const ExtChanged(this.ext);

  final String ext;

  @override
  List<Object> get props => [ext];
}

class AccountSubmitted extends EditAccountEvent {
  const AccountSubmitted();
}
