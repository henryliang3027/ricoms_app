part of 'edit_account_bloc.dart';

class EditAccountState extends Equatable {
  const EditAccountState({
    this.status = FormzStatus.pure,
    this.isEditing = false,
    this.account = const Account.pure(),
    this.password = const Password.pure(),
    this.passwordVisibility = false,
    this.name = const Name.pure(),
    this.permission = 3,
    this.department = '',
    this.email = '',
    this.mobile = '',
    this.tel = '',
    this.ext = '',
    this.submissionMsg = '',
  });

  final FormzStatus status;
  final bool isEditing;
  final Account account;
  final Password password;
  final Name name;
  final bool passwordVisibility;
  final int permission;
  final String department;
  final String email;
  final String mobile;
  final String tel;
  final String ext;
  final String submissionMsg;

  EditAccountState copyWith({
    FormzStatus? status,
    bool? isEditing,
    Account? account,
    Password? password,
    bool? passwordVisibility,
    Name? name,
    int? permission,
    String? department,
    String? email,
    String? mobile,
    String? tel,
    String? ext,
    String? submissionMsg,
  }) {
    return EditAccountState(
      status: status ?? this.status,
      isEditing: isEditing ?? this.isEditing,
      account: account ?? this.account,
      password: password ?? this.password,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      name: name ?? this.name,
      permission: permission ?? this.permission,
      department: department ?? this.department,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      tel: tel ?? this.tel,
      ext: ext ?? this.ext,
      submissionMsg: submissionMsg ?? this.submissionMsg,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isEditing,
        account,
        password,
        passwordVisibility,
        name,
        permission,
        department,
        email,
        mobile,
        tel,
        ext,
        submissionMsg,
      ];
}
