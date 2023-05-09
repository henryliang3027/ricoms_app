part of 'account_bloc.dart';

class AccountState extends Equatable {
  const AccountState({
    this.formStatus = FormStatus.none,
    this.accountExportStatus = FormStatus.none,
    this.deleteStatus = SubmissionStatus.none,
    this.keyword = '',
    this.accounts = const [],
    this.accountExportPath = '',
    this.accountExportMsg = '',
    this.requestErrorMsg = '',
    this.deleteMsg = '',
  });

  final FormStatus formStatus;
  final FormStatus accountExportStatus;
  final SubmissionStatus deleteStatus;
  final String keyword;
  final List<AccountOutline> accounts;
  final String accountExportPath;
  final String accountExportMsg;
  final String requestErrorMsg;
  final String deleteMsg;

  AccountState copyWith({
    FormStatus? formStatus,
    FormStatus? accountExportStatus,
    SubmissionStatus? deleteStatus,
    String? keyword,
    List<AccountOutline>? accounts,
    String? accountExportPath,
    String? accountExportMsg,
    String? requestErrorMsg,
    String? deleteMsg,
  }) {
    return AccountState(
      formStatus: formStatus ?? this.formStatus,
      accountExportStatus: accountExportStatus ?? this.accountExportStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      keyword: keyword ?? this.keyword,
      accounts: accounts ?? this.accounts,
      accountExportPath: accountExportPath ?? this.accountExportPath,
      accountExportMsg: accountExportMsg ?? this.accountExportMsg,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
      deleteMsg: deleteMsg ?? this.deleteMsg,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        accountExportStatus,
        deleteStatus,
        keyword,
        accounts,
        accountExportPath,
        accountExportMsg,
        requestErrorMsg,
        deleteMsg,
      ];
}
