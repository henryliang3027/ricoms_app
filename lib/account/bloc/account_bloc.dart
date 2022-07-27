import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/account_outline.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountState()) {
    on<AccountEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
