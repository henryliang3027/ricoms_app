part of 'account_bloc.dart';

class AccountState extends Equatable {
  const AccountState({
    this.formStatus = FormStatus.none,
    this.deleteStatus = SubmissionStatus.none,
    this.keyword = '',
    this.accounts = const [],
    this.requestErrorMsg = '',
    this.deleteMsg = '',
  });

  final FormStatus formStatus;
  final SubmissionStatus deleteStatus;
  final String keyword;
  final List<AccountOutline> accounts;
  final String requestErrorMsg;
  final String deleteMsg;

  AccountState copyWith({
    FormStatus? formStatus,
    SubmissionStatus? deleteStatus,
    String? keyword,
    List<AccountOutline>? accounts,
    String? requestErrorMsg,
    String? deleteMsg,
  }) {
    return AccountState(
      formStatus: formStatus ?? this.formStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      keyword: keyword ?? this.keyword,
      accounts: accounts ?? this.accounts,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
      deleteMsg: deleteMsg ?? this.deleteMsg,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        deleteStatus,
        keyword,
        accounts,
        requestErrorMsg,
        deleteMsg,
      ];
}
