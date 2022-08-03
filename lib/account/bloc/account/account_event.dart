part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();
}

class AccountRequested extends AccountEvent {
  const AccountRequested();

  @override
  List<Object?> get props => [];
}

// class AccountSearched extends AccountEvent {
//   const AccountSearched();

//   @override
//   List<Object?> get props => [];
// }

class KeywordChanged extends AccountEvent {
  const KeywordChanged(this.keyword);

  final String keyword;

  @override
  List<Object?> get props => [keyword];
}

class AccountDeleted extends AccountEvent {
  const AccountDeleted(this.accountId);

  final int accountId;

  @override
  List<Object?> get props => [accountId];
}
