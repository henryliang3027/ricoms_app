import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_forward_repository/forward_outline.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_forward_repository/trap_forward_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'trap_forward_event.dart';
part 'trap_forward_state.dart';

class TrapForwardBloc extends Bloc<TrapForwardEvent, TrapForwardState> {
  TrapForwardBloc({
    required User user,
    required TrapForwardRepository trapForwardRepository,
  })  : _user = user,
        _trapForwardRepository = trapForwardRepository,
        super(const TrapForwardState()) {
    on<ForwardOutlinesRequested>(_onForwardOutlinesRequested);
    on<ForwardOutlinesDeletedModeEnabled>(_onForwardOutlinesDeletedModeEnabled);
    on<ForwardOutlinesDeletedModeDisabled>(
        _onForwardOutlinesDeletedModeDisabled);
    on<ForwardOutlinesItemToggled>(_onForwardOutlinesItemToggled);
    on<ForwardOutlineDeleted>(_onForwardOutlineDeleted);
    on<MultipleForwardOutlinesDeleted>(_onMultipleForwardOutlinesDeleted);

    add(const ForwardOutlinesRequested());
  }

  final User _user;
  final TrapForwardRepository _trapForwardRepository;

  /// 處理 Trap Forward 列表的獲取
  Future<void> _onForwardOutlinesRequested(
    ForwardOutlinesRequested event,
    Emitter<TrapForwardState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
      deleteStatus: SubmissionStatus.none,
    ));

    List<dynamic> result =
        await _trapForwardRepository.getForwardOutlineList(user: _user);

    if (result[0]) {
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        deleteStatus: SubmissionStatus.none,
        forwardOutlines: result[1],
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        deleteStatus: SubmissionStatus.none,
        requestErrorMsg: result[1],
      ));
    }
  }

  /// 處理刪除模式的開啟
  void _onForwardOutlinesDeletedModeEnabled(
    ForwardOutlinesDeletedModeEnabled event,
    Emitter<TrapForwardState> emit,
  ) {
    if (state.forwardOutlines.isNotEmpty) {
      emit(state.copyWith(
        deleteStatus: SubmissionStatus.none,
        selectedforwardOutlines: state.forwardOutlines,
        isDeleteMode: true,
      ));
    }
  }

  /// 處理刪除模式的關閉
  void _onForwardOutlinesDeletedModeDisabled(
    ForwardOutlinesDeletedModeDisabled event,
    Emitter<TrapForwardState> emit,
  ) {
    emit(state.copyWith(
      deleteStatus: SubmissionStatus.none,
      selectedforwardOutlines: const [],
      isDeleteMode: false,
    ));
  }

  /// 處理列表的選取, 刪除模式用
  void _onForwardOutlinesItemToggled(
    ForwardOutlinesItemToggled event,
    Emitter<TrapForwardState> emit,
  ) {
    List<ForwardOutline> selectedForwardOutlines = [];

    selectedForwardOutlines.addAll(state.selectedforwardOutlines);

    if (selectedForwardOutlines.contains(event.forwardOutlines)) {
      selectedForwardOutlines.remove(event.forwardOutlines);
    } else {
      selectedForwardOutlines.add(event.forwardOutlines);
    }

    emit(state.copyWith(
      selectedforwardOutlines: selectedForwardOutlines,
    ));
  }

  /// 處理單筆 Trap Forward 項目的刪除
  Future<void> _onForwardOutlineDeleted(
    ForwardOutlineDeleted event,
    Emitter<TrapForwardState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
      deleteStatus: SubmissionStatus.none,
    ));

    List<dynamic> resultOfDelete =
        await _trapForwardRepository.deleteForwardOutline(
      user: _user,
      id: event.id,
    );

    if (resultOfDelete[0]) {
      List<dynamic> resultOfRetrieve =
          await _trapForwardRepository.getForwardOutlineList(user: _user);

      if (resultOfRetrieve[0]) {
        emit(state.copyWith(
          status: FormStatus.requestSuccess,
          deleteStatus: SubmissionStatus.submissionSuccess,
          forwardOutlines: resultOfRetrieve[1],
          deleteResultMsg: resultOfDelete[1],
          selectedforwardOutlines: const [],
          isDeleteMode: false,
        ));
      } else {
        emit(state.copyWith(
          status: FormStatus.requestFailure,
          deleteStatus: SubmissionStatus.submissionSuccess,
          requestErrorMsg: resultOfRetrieve[1],
          deleteResultMsg: resultOfDelete[1],
          selectedforwardOutlines: const [],
          isDeleteMode: false,
        ));
      }
    } else {
      emit(state.copyWith(
        deleteStatus: SubmissionStatus.submissionFailure,
        deleteResultMsg: resultOfDelete[1],
      ));
    }
  }

  /// 處理多筆 Trap Forward 項目的刪除
  Future<void> _onMultipleForwardOutlinesDeleted(
    MultipleForwardOutlinesDeleted event,
    Emitter<TrapForwardState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
      deleteStatus: SubmissionStatus.none,
    ));

    List<dynamic> resultOfDelete =
        await _trapForwardRepository.deleteMultipleForwardOutlines(
      user: _user,
      forwardOutlines: state.selectedforwardOutlines,
    );

    if (resultOfDelete[0]) {
      List<dynamic> resultOfRetrieve =
          await _trapForwardRepository.getForwardOutlineList(user: _user);

      if (resultOfRetrieve[0]) {
        emit(state.copyWith(
          status: FormStatus.requestSuccess,
          deleteStatus: SubmissionStatus.submissionSuccess,
          forwardOutlines: resultOfRetrieve[1],
          deleteResultMsg: resultOfDelete[1],
          selectedforwardOutlines: const [],
          isDeleteMode: false,
        ));
      } else {
        emit(state.copyWith(
          status: FormStatus.requestFailure,
          deleteStatus: SubmissionStatus.submissionSuccess,
          requestErrorMsg: resultOfRetrieve[1],
          deleteResultMsg: resultOfDelete[1],
          selectedforwardOutlines: const [],
          isDeleteMode: false,
        ));
      }
    } else {
      emit(state.copyWith(
        deleteStatus: SubmissionStatus.submissionFailure,
        deleteResultMsg: resultOfDelete[1],
      ));
    }
  }
}
