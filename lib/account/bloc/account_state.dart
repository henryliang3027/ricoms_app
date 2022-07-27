part of 'account_bloc.dart';

class AccountState extends Equatable {
  const AccountState({
    this.formStatus = FormStatus.none,
    this.accounts = const [],
    this.requestErrorMsg = '',
  });

  final FormStatus formStatus;
  final List<AccountOutline> accounts;
  final String requestErrorMsg;

  AccountState copyWith({
    FormStatus? formStatus,
    List<AccountOutline>? accounts,
    String? requestErrorMsg,
  }) {
    return AccountState(
      formStatus: formStatus ?? this.formStatus,
      accounts: accounts ?? this.accounts,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        accounts,
        requestErrorMsg,
      ];
}
