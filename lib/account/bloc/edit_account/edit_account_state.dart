part of 'edit_account_bloc.dart';

class EditAccountState extends Equatable {
  const EditAccountState({
    this.status = FormzStatus.pure,
    this.isInitialize = false,
    this.account = const Account.pure(),
    this.password = const Password.pure(),
    this.name = const Name.pure(),
    this.permission = 3,
    this.department = '',
    this.email = '',
    this.mobile = '',
    this.tel = '',
    this.ext = '',
  });

  final FormzStatus status;
  final bool isInitialize;
  final Account account;
  final Password password;
  final Name name;
  final int permission;
  final String department;
  final String email;
  final String mobile;
  final String tel;
  final String ext;

  EditAccountState copyWith({
    FormzStatus? status,
    bool? isInitialize,
    Account? account,
    Password? password,
    Name? name,
    int? permission,
    String? department,
    String? email,
    String? mobile,
    String? tel,
    String? ext,
  }) {
    return EditAccountState(
      status: status ?? this.status,
      isInitialize: isInitialize ?? this.isInitialize,
      account: account ?? this.account,
      password: password ?? this.password,
      name: name ?? this.name,
      permission: permission ?? this.permission,
      department: department ?? this.department,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      tel: tel ?? this.tel,
      ext: ext ?? this.ext,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isInitialize,
        account,
        password,
        name,
        permission,
        department,
        email,
        mobile,
        tel,
        ext,
      ];
}
