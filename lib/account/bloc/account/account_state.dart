part of 'account_bloc.dart';

class AccountState extends Equatable {
  const AccountState({
    this.formStatus = FormStatus.none,
    this.keyword = '',
    this.accounts = const [],
    this.requestErrorMsg = '',
  });

  final FormStatus formStatus;
  final String keyword;
  final List<AccountOutline> accounts;
  final String requestErrorMsg;

  AccountState copyWith({
    FormStatus? formStatus,
    String? keyword,
    List<AccountOutline>? accounts,
    String? requestErrorMsg,
  }) {
    return AccountState(
      formStatus: formStatus ?? this.formStatus,
      keyword: keyword ?? this.keyword,
      accounts: accounts ?? this.accounts,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        keyword,
        accounts,
        requestErrorMsg,
      ];
}
