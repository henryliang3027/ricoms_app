import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/account_outline.dart';
import 'package:ricoms_app/repository/account_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc({
    required User user,
    required AccountRepository accountRepository,
  })  : _user = user,
        _accountRepository = accountRepository,
        super(const AccountState()) {
    on<AccountRequested>(_onAccountRequested);
    on<KeywordChanged>(_onKeywordChanged);
    on<AccountSearched>(_onAccountSearched);

    add(const AccountRequested());
  }

  final User _user;
  final AccountRepository _accountRepository;

  Future<void> _onAccountRequested(
    AccountRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
    ));

    List<dynamic> result =
        await _accountRepository.getAccountOutlineList(user: _user);

    if (result[0]) {
      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        accounts: result[1],
      ));
    } else {
      emit(state.copyWith(
        formStatus: FormStatus.requestFailure,
        requestErrorMsg: result[1],
      ));
    }
  }

  void _onKeywordChanged(
    KeywordChanged event,
    Emitter<AccountState> emit,
  ) {
    emit(state.copyWith(
      keyword: event.keyword,
    ));
  }

  Future<void> _onAccountSearched(
    AccountSearched event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
    ));

    List<dynamic> result =
        await _accountRepository.getAccountOutlineList(user: _user);

    if (result[0]) {
      List<AccountOutline> accountOutlineList = result[1];

      List<AccountOutline> matchedAccountOutlineList = accountOutlineList
          .where((accountOutline) =>
              accountOutline.account
                  .toLowerCase()
                  .contains(state.keyword.toLowerCase()) ||
              (accountOutline.department ?? '')
                  .toLowerCase()
                  .contains(state.keyword.toLowerCase()) ||
              accountOutline.name
                  .toLowerCase()
                  .contains(state.keyword.toLowerCase()) ||
              accountOutline.permission
                  .toLowerCase()
                  .contains(state.keyword.toLowerCase()))
          .toList();

      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        accounts: matchedAccountOutlineList,
      ));
    } else {
      emit(state.copyWith(
        formStatus: FormStatus.requestFailure,
        requestErrorMsg: result[1],
      ));
    }
  }
}
