part of 'trap_forward_bloc.dart';

class TrapForwardState extends Equatable {
  const TrapForwardState({
    this.status = FormStatus.none,
    this.deleteStatus = SubmissionStatus.none,
    this.forwardOutlines = const [],
    this.selectedforwardOutlines = const [],
    this.isDeleteMode = false,
    this.requestErrorMsg = '',
    this.deleteResultMsg = '',
  });

  final FormStatus status;
  final SubmissionStatus deleteStatus;
  final List<ForwardOutline> forwardOutlines;
  final List<ForwardOutline> selectedforwardOutlines;
  final bool isDeleteMode;
  final String requestErrorMsg;
  final String deleteResultMsg;

  TrapForwardState copyWith({
    FormStatus? status,
    SubmissionStatus? deleteStatus,
    List<ForwardOutline>? forwardOutlines,
    List<ForwardOutline>? selectedforwardOutlines,
    bool? isDeleteMode,
    String? requestErrorMsg,
    String? deleteResultMsg,
  }) {
    return TrapForwardState(
      status: status ?? this.status,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      forwardOutlines: forwardOutlines ?? this.forwardOutlines,
      selectedforwardOutlines:
          selectedforwardOutlines ?? this.selectedforwardOutlines,
      isDeleteMode: isDeleteMode ?? this.isDeleteMode,
      requestErrorMsg: requestErrorMsg ?? this.deleteResultMsg,
      deleteResultMsg: deleteResultMsg ?? this.deleteResultMsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        deleteStatus,
        forwardOutlines,
        selectedforwardOutlines,
        isDeleteMode,
        requestErrorMsg,
        deleteResultMsg,
      ];
}
