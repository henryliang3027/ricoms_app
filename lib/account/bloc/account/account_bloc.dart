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
    on<AccountDeleted>(_onAccountDeleted);

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
      deleteStatus: SubmissionStatus.none,
    ));

    List<dynamic> result = await _accountRepository.getAccountOutlineList(
      user: _user,
      keyword: state.keyword,
    );

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
      deleteStatus: SubmissionStatus.none,
      keyword: event.keyword,
    ));
  }

  // Future<void> _onAccountSearched(
  //   AccountSearched event,
  //   Emitter<AccountState> emit,
  // ) async {
  //   emit(state.copyWith(
  //     deleteStatus: SubmissionStatus.none,
  //     formStatus: FormStatus.requestInProgress,
  //   ));

  //   List<dynamic> result = await _accountRepository.getAccountByKeyword(
  //     user: _user,
  //     keyword: state.keyword,
  //   );

  //   if (result[0]) {
  //     emit(state.copyWith(
  //       formStatus: FormStatus.requestSuccess,
  //       accounts: result[1],
  //     ));
  //   } else {
  //     emit(state.copyWith(
  //       formStatus: FormStatus.requestFailure,
  //       requestErrorMsg: result[1],
  //     ));
  //   }
  // }

  Future<void> _onAccountDeleted(
    AccountDeleted event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(
      deleteStatus: SubmissionStatus.submissionInProgress,
    ));

    List<dynamic> resultOfDelete = await _accountRepository.deleteAccount(
      user: _user,
      accountId: event.accountId,
    );

    if (resultOfDelete[0]) {
      List<dynamic> resultOfRetrieve =
          await _accountRepository.getAccountOutlineList(
        user: _user,
        keyword: state.keyword,
      );

      if (resultOfRetrieve[0]) {
        emit(state.copyWith(
          deleteStatus: SubmissionStatus.submissionSuccess,
          formStatus: FormStatus.requestSuccess,
          accounts: resultOfRetrieve[1],
          deleteMsg: resultOfDelete[1],
        ));
      } else {
        emit(state.copyWith(
          deleteStatus: SubmissionStatus.submissionSuccess,
          formStatus: FormStatus.requestFailure,
          requestErrorMsg: resultOfRetrieve[1],
          deleteMsg: resultOfDelete[1],
        ));
      }
    } else {
      emit(state.copyWith(
        deleteStatus: SubmissionStatus.submissionFailure,
        deleteMsg: resultOfDelete[1],
      ));
    }
  }
}
