part of 'edit_account_bloc.dart';

class EditAccountState extends Equatable {
  const EditAccountState({
    this.isModify = false,
    //determine whether account form should be update or not after creating or updating account
    this.status = FormzStatus.pure,
    this.submissionStatus = SubmissionStatus.none,
    this.isInitController = false,
    this.account = const Account.pure(),
    this.password = const AccountPassword.pure(),
    this.passwordVisibility = false,
    this.name = const Name.pure(),
    this.permission = 3,
    this.department = '',
    this.email = const Email.pure(),
    this.mobile = const Mobile.pure(),
    this.tel = const Tel.pure(),
    this.ext = const Ext.pure(),
    this.submissionMsg = '',
  });

  final bool isModify;
  final FormzStatus status;
  final SubmissionStatus submissionStatus;
  final bool isInitController;
  final Account account;
  final AccountPassword password;
  final Name name;
  final bool passwordVisibility;
  final int permission;
  final String department;
  final Email email;
  final Mobile mobile;
  final Tel tel;
  final Ext ext;
  final String submissionMsg;

  EditAccountState copyWith({
    bool? isModify,
    FormzStatus? status,
    SubmissionStatus? submissionStatus,
    bool? isInitController,
    Account? account,
    AccountPassword? password,
    bool? passwordVisibility,
    Name? name,
    int? permission,
    String? department,
    Email? email,
    Mobile? mobile,
    Tel? tel,
    Ext? ext,
    String? submissionMsg,
  }) {
    return EditAccountState(
      isModify: isModify ?? this.isModify,
      status: status ?? this.status,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      isInitController: isInitController ?? this.isInitController,
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
        isModify,
        status,
        submissionStatus,
        isInitController,
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
