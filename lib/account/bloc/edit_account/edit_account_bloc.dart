import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/account/model/account.dart';
import 'package:ricoms_app/login/models/password.dart';
import 'package:ricoms_app/repository/account_detail.dart';
import 'package:ricoms_app/repository/account_outline.dart';
import 'package:ricoms_app/repository/account_repository.dart';
import 'package:ricoms_app/repository/user.dart';
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
    on<NameChanged>(_onNameChanged);
    on<PermissionChanged>(_onPermissionChanged);
    on<DepartmentChanged>(_onDepartmentChanged);
    on<EmailChanged>(_onEmailChanged);
    on<MobileChanged>(_onMobileChanged);
    on<TelChanged>(_onTelChanged);
    on<ExtChanged>(_onExtChanged);

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
        isEditing: true,
        account: Account.dirty(accountDetail.account),
        name: Name.dirty(accountDetail.name),
        permission: int.parse(accountDetail.permission),
        department: accountDetail.department,
        email: accountDetail.email,
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
        isEditing: _isEditing,
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
        isEditing: _isEditing,
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
        isEditing: _isEditing,
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
        isEditing: _isEditing,
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
        isEditing: _isEditing,
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
        isEditing: _isEditing,
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
        isEditing: _isEditing,
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
        isEditing: _isEditing,
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
        isEditing: _isEditing,
        ext: event.ext,
      ),
    );
  }

  Future<void> _onNodeCreationSubmitted(
    AccountCreationSubmitted event,
    Emitter<EditAccountState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      // List<dynamic> msg = await _accountRepository.createNode(
      //   user: _user,
      //   parentId: _parentNode.id,
      //   type: _type,
      //   name: state.name.value,
      //   description: state.description,
      //   deviceIP: state.deviceIP.value,
      //   read: state.read,
      //   write: state.write,
      //   location: state.location,
      // );

      // if (msg[0]) {
      //   emit(state.copyWith(
      //     isInitController: false,
      //     isTestConnection: false,
      //     msg: msg[1],
      //     status: FormzStatus.submissionSuccess,
      //   ));
      // } else {
      //   emit(state.copyWith(
      //     isInitController: false,
      //     isTestConnection: false,
      //     msg: msg[1],
      //     status: FormzStatus.submissionFailure,
      //   ));
      // }
    }
  }

  Future<void> _onNodeUpdateSubmitted(
    AccountUpdateSubmitted event,
    Emitter<EditAccountState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      // List<dynamic> msg = await _rootRepository.updateNode(
      //   user: _user,
      //   currentNode: state.currentNode!,
      //   name: state.name.value,
      //   description: state.description,
      //   deviceIP: state.deviceIP.value,
      //   read: state.read,
      //   write: state.write,
      //   location: state.location,
      // );

      // if (msg[0]) {
      //   emit(state.copyWith(
      //     isInitController: false,
      //     isTestConnection: false,
      //     msg: msg[1],
      //     status: FormzStatus.submissionSuccess,
      //   ));
      // } else {
      //   emit(state.copyWith(
      //     isInitController: false,
      //     isTestConnection: false,
      //     msg: msg[1],
      //     status: FormzStatus.submissionFailure,
      //   ));
      // }
    }
  }
}
