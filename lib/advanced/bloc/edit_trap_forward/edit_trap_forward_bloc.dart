import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_forward_repository/forward_detail.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_forward_repository/forward_outline.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_forward_repository/trap_forward_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/models/custom_input.dart';
import 'package:ricoms_app/root/models/name.dart';

part 'edit_trap_forward_event.dart';
part 'edit_trap_forward_state.dart';

class EditTrapForwardBloc
    extends Bloc<EditTrapForwardEvent, EditTrapForwardState> {
  EditTrapForwardBloc({
    required User user,
    required TrapForwardRepository trapForwardRepository,
    required bool isEditing,
    ForwardOutline? forwardOutline,
  })  : _user = user,
        _trapForwardRepository = trapForwardRepository,
        _isEditing = isEditing,
        _forwardOutline = forwardOutline,
        super(const EditTrapForwardState()) {
    on<ForwardDetailRequested>(_onForwardDetailRequested);
    on<ForwardEnabledChanged>(_onForwardEnabledChanged);
    on<NameChanged>(_onNameChanged);
    on<IPChanged>(_onIPChanged);
    on<ParametersChanged>(_onParametersChanged);
    on<ForwardDetailUpdateSubmitted>(_onForwardDetailUpdateSubmitted);
    on<ForwardDetailCreateSubmitted>(_onForwardDetailCreateSubmitted);

    if (_forwardOutline != null) {
      add(ForwardDetailRequested(_forwardOutline!.id));
    }
  }

  final User _user;
  final TrapForwardRepository _trapForwardRepository;
  final bool _isEditing;
  final ForwardOutline? _forwardOutline;

  /// 處理 Trap Forward 可編輯的資料的獲取
  Future<void> _onForwardDetailRequested(
    ForwardDetailRequested event,
    Emitter<EditTrapForwardState> emit,
  ) async {
    List<dynamic> result = await _trapForwardRepository.getForwardDetail(
      user: _user,
      id: event.id,
    );

    if (result[0]) {
      ForwardDetail forwardDetail = result[1];

      if (_isEditing) {
        final Name name = Name.dirty(forwardDetail.name);
        final IPv4 ip = IPv4.dirty(forwardDetail.ip);

        emit(state.copyWith(
          submissionStatus: SubmissionStatus.none,
          isInitController: true,
          enable: forwardDetail.enable == 0 ? false : true,
          name: Name.dirty(forwardDetail.name),
          ip: IPv4.dirty(forwardDetail.ip),
          parameters: forwardDetail.parameters,
          status: Formz.validate([
            name,
            ip,
          ]),
        ));
      } else {
        emit(state.copyWith(
          submissionStatus: SubmissionStatus.none,
          enable: forwardDetail.enable == 0 ? false : true,
          parameters: forwardDetail.parameters,
          status: Formz.validate([
            state.name,
            state.ip,
          ]),
        ));
      }
    } else {}
  }

  /// 處理 Trap Forward 的開啟/關閉
  void _onForwardEnabledChanged(
    ForwardEnabledChanged event,
    Emitter<EditTrapForwardState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitController: false,
      enable: event.enable,
    ));
  }

  /// 處理 Trap Forward 名稱的變更
  void _onNameChanged(
    NameChanged event,
    Emitter<EditTrapForwardState> emit,
  ) {
    final name = Name.dirty(event.name);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitController: false,
      name: name,
      status: Formz.validate([
        name,
        state.ip,
      ]),
    ));
  }

  /// 處理 Trap Forward ip 的變更
  void _onIPChanged(
    IPChanged event,
    Emitter<EditTrapForwardState> emit,
  ) {
    final ip = IPv4.dirty(event.ip);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitController: false,
      ip: ip,
      status: Formz.validate([
        state.name,
        ip,
      ]),
    ));
  }

  /// 處理 Trap Forward 相關參數的變更
  void _onParametersChanged(
    ParametersChanged event,
    Emitter<EditTrapForwardState> emit,
  ) {
    List<Parameter> parameters = [];

    for (int i = 0; i < state.parameters.length; i++) {
      if (event.indexOfParameter == i) {
        int check = event.value == true ? 1 : 0;
        Parameter parameter = Parameter(
          name: state.parameters[i].name,
          oid: state.parameters[i].oid,
          checked: check,
        );
        parameters.add(parameter);
      } else {
        parameters.add(state.parameters[i]);
      }
    }
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitController: false,
      parameters: parameters,
      status: Formz.validate([
        state.name,
        state.ip,
      ]),
    ));
  }

  /// 處理 Trap Forward 設定資料的更新, 向後端更新資料
  Future<void> _onForwardDetailUpdateSubmitted(
    ForwardDetailUpdateSubmitted event,
    Emitter<EditTrapForwardState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<dynamic> result = await _trapForwardRepository.updateForwardDetail(
      user: _user,
      id: _forwardOutline!.id,
      enable: state.enable,
      name: state.name.value,
      ip: state.ip.value,
      parameters: state.parameters,
    );

    if (result[0]) {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionSuccess,
        isModify: true,
        submissionMsg: result[1],
      ));
    } else {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionFailure,
        submissionMsg: result[1],
      ));
    }
  }

  /// 處理 Trap Forward 的新增, 向後端新增資料
  Future<void> _onForwardDetailCreateSubmitted(
    ForwardDetailCreateSubmitted event,
    Emitter<EditTrapForwardState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<dynamic> result = await _trapForwardRepository.createForwardDetail(
      user: _user,
      enable: state.enable,
      name: state.name.value,
      ip: state.ip.value,
      parameters: state.parameters,
    );

    if (result[0]) {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionSuccess,
        isModify: true,
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
