import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/account/model/account.dart';
import 'package:ricoms_app/login/models/password.dart';
import 'package:ricoms_app/repository/account_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/models/name.dart';
part 'edit_account_event.dart';
part 'edit_account_state.dart';

class EditAccountBloc extends Bloc<EditAccountEvent, EditAccountState> {
  EditAccountBloc({
    required User user,
    required AccountRepository accountRepository,
  })  : _user = user,
        _accountRepository = accountRepository,
        super(const EditAccountState()) {
    on<AccountChanged>(_onAccountChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<NameChanged>(_onNameChanged);
    on<PermissionChanged>(_onPermissionChanged);
    on<DepartmentChanged>(_onDepartmentChanged);
    on<EmailChanged>(_onEmailChanged);
    on<MobileChanged>(_onMobileChanged);
    on<TelChanged>(_onTelChanged);
    on<ExtChanged>(_onExtChanged);
  }

  final User _user;
  final AccountRepository _accountRepository;

  void _onAccountChanged(
    AccountChanged event,
    Emitter<EditAccountState> emit,
  ) {
    final account = Account.dirty(event.account);
    emit(
      state.copyWith(
        isInitialize: false,
        account: account,
        status: Formz.validate([
          account,
          state.password,
          state.name,
        ]),
      ),
    );
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<EditAccountState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        isInitialize: false,
        password: password,
        status: Formz.validate([
          state.account,
          password,
          state.name,
        ]),
      ),
    );
  }

  void _onNameChanged(
    NameChanged event,
    Emitter<EditAccountState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(
      state.copyWith(
        isInitialize: false,
        name: name,
        status: Formz.validate([
          state.account,
          state.password,
          name,
        ]),
      ),
    );
  }

  void _onPermissionChanged(
    PermissionChanged event,
    Emitter<EditAccountState> emit,
  ) {
    emit(
      state.copyWith(
        isInitialize: false,
        permission: event.permission,
      ),
    );
  }

  void _onDepartmentChanged(
    DepartmentChanged event,
    Emitter<EditAccountState> emit,
  ) {
    emit(
      state.copyWith(
        isInitialize: false,
        department: event.department,
      ),
    );
  }

  void _onEmailChanged(
    EmailChanged event,
    Emitter<EditAccountState> emit,
  ) {
    emit(
      state.copyWith(
        isInitialize: false,
        email: event.email,
      ),
    );
  }

  void _onMobileChanged(
    MobileChanged event,
    Emitter<EditAccountState> emit,
  ) {
    emit(
      state.copyWith(
        isInitialize: false,
        mobile: event.mobile,
      ),
    );
  }

  void _onTelChanged(
    TelChanged event,
    Emitter<EditAccountState> emit,
  ) {
    emit(
      state.copyWith(
        isInitialize: false,
        tel: event.tel,
      ),
    );
  }

  void _onExtChanged(
    ExtChanged event,
    Emitter<EditAccountState> emit,
  ) {
    emit(
      state.copyWith(
        isInitialize: false,
        ext: event.ext,
      ),
    );
  }
}
