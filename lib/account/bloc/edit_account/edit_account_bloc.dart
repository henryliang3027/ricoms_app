import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/account/model/account.dart';
import 'package:ricoms_app/account/model/email.dart';
import 'package:ricoms_app/login/models/password.dart';
import 'package:ricoms_app/repository/account_detail.dart';
import 'package:ricoms_app/repository/account_outline.dart';
import 'package:ricoms_app/repository/account_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/models/name.dart';
part 'edit_account_event.dart';
part 'edit_account_state.dart';

class EditAccountBloc extends Bloc<EditAccountEvent, EditAccountState> {
  EditAccountBloc({
    required User user,
    required AccountRepository accountRepository,
    required bool isEditing,
    AccountOutline? accountOutline,
  })  : _user = user,
        _accountRepository = accountRepository,
        _isEditing = isEditing,
        _accountOutline = accountOutline,
        super(const EditAccountState()) {
    on<AccountDetailRequested>(_onAccountDetailRequested);
    on<AccountChanged>(_onAccountChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<PasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<NameChanged>(_onNameChanged);
    on<PermissionChanged>(_onPermissionChanged);
    on<DepartmentChanged>(_onDepartmentChanged);
    on<EmailChanged>(_onEmailChanged);
    on<MobileChanged>(_onMobileChanged);
    on<TelChanged>(_onTelChanged);
    on<ExtChanged>(_onExtChanged);
    on<AccountCreationSubmitted>(_onAccountCreationSubmitted);
    on<AccountUpdateSubmitted>(_onAccountUpdateSubmitted);

    if (isEditing) {
      if (_accountOutline != null) {
        add(AccountDetailRequested(_accountOutline!.id));
      }
    }
  }

  final User _user;
  final AccountRepository _accountRepository;
  final bool _isEditing;
  final AccountOutline? _accountOutline;

  Future<void> _onAccountDetailRequested(
    AccountDetailRequested event,
    Emitter<EditAccountState> emit,
  ) async {
    List<dynamic> result = await _accountRepository.getAccountDetail(
      user: _user,
      accountId: event.accountId,
    );

    if (result[0]) {
      AccountDetail accountDetail = result[1];

      emit(state.copyWith(
        isInitController: true,
        account: Account.dirty(accountDetail.account),
        name: Name.dirty(accountDetail.name),
        permission: int.parse(accountDetail.permission),
        department: accountDetail.department,
        email: Email.dirty(accountDetail.email ?? ''),
        mobile: accountDetail.mobile,
        tel: accountDetail.tel,
        ext: accountDetail.ext,
      ));
    } else {}
  }

  void _onAccountChanged(
    AccountChanged event,
    Emitter<EditAccountState> emit,
  ) {
    final account = Account.dirty(event.account);
    emit(
      state.copyWith(
        submissionStatus: SubmissionStatus.none,
        isInitController: false,
        account: account,
        status: Formz.validate([
          account,
          state.password,
          state.name,
          state.email,
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
        submissionStatus: SubmissionStatus.none,
        isInitController: false,
        password: password,
        status: Formz.validate([
          state.account,
          password,
          state.name,
          state.email,
        ]),
      ),
    );
  }

  void _onPasswordVisibilityChanged(
    PasswordVisibilityChanged event,
    Emitter<EditAccountState> emit,
  ) {
    emit(
      state.copyWith(
        submissionStatus: SubmissionStatus.none,
        isInitController: false,
        passwordVisibility: !state.passwordVisibility,
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
        submissionStatus: SubmissionStatus.none,
        isInitController: false,
        name: name,
        status: Formz.validate([
          state.account,
          state.password,
          name,
          state.email,
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
        submissionStatus: SubmissionStatus.none,
        isInitController: false,
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
        submissionStatus: SubmissionStatus.none,
        isInitController: false,
        department: event.department,
      ),
    );
  }

  void _onEmailChanged(
    EmailChanged event,
    Emitter<EditAccountState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        submissionStatus: SubmissionStatus.none,
        isInitController: false,
        email: email,
        status: Formz.validate([
          state.account,
          state.password,
          state.name,
          email,
        ]),
      ),
    );
  }

  void _onMobileChanged(
    MobileChanged event,
    Emitter<EditAccountState> emit,
  ) {
    emit(
      state.copyWith(
        submissionStatus: SubmissionStatus.none,
        isInitController: false,
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
        submissionStatus: SubmissionStatus.none,
        isInitController: false,
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
        submissionStatus: SubmissionStatus.none,
        isInitController: false,
        ext: event.ext,
      ),
    );
  }

  Future<void> _onAccountCreationSubmitted(
    AccountCreationSubmitted event,
    Emitter<EditAccountState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionInProgress,
      ));

      List<dynamic> result = await _accountRepository.createAccount(
        user: _user,
        account: state.account.value,
        password: state.password.value,
        name: state.name.value,
        permission: state.permission,
        department: state.department,
        email: state.email.value,
        mobile: state.mobile,
        tel: state.tel,
        ext: state.ext,
      );

      if (result[0]) {
        emit(state.copyWith(
          isModify: true,
          submissionStatus: SubmissionStatus.submissionSuccess,
          submissionMsg: result[1],
        ));
      } else {
        emit(state.copyWith(
          submissionStatus: SubmissionStatus.submissionFailure,
          submissionMsg: result[1],
        ));
      }
    }
  }

  Future<void> _onAccountUpdateSubmitted(
    AccountUpdateSubmitted event,
    Emitter<EditAccountState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionInProgress,
      ));

      List<dynamic> result = await _accountRepository.updateAccount(
        user: _user,
        accountId: _accountOutline!.id,
        account: state.account.value,
        password: state.password.value,
        name: state.name.value,
        permission: state.permission,
        department: state.department,
        email: state.email.value,
        mobile: state.mobile,
        tel: state.tel,
        ext: state.ext,
      );

      if (result[0]) {
        emit(state.copyWith(
          isModify: true,
          submissionStatus: SubmissionStatus.submissionSuccess,
          submissionMsg: result[1],
        ));
      } else {
        emit(state.copyWith(
          submissionStatus: SubmissionStatus.submissionFailure,
          submissionMsg: result[1],
        ));
      }
    }
  }
}
