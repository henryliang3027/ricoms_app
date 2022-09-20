part of 'trap_forward_bloc.dart';

class TrapForwardState extends Equatable {
  const TrapForwardState({
    this.formStatus = FormStatus.none,
    this.forwardMetas = const [],
    this.selectedforwardMetas = const [],
    this.isDeleteMode = false,
    this.requestErrorMsg = '',
    this.deleteResultMsg = '',
  });

  final FormStatus formStatus;
  final List<ForwardMeta> forwardMetas;
  final List<ForwardMeta> selectedforwardMetas;
  final bool isDeleteMode;
  final String requestErrorMsg;
  final String deleteResultMsg;

  TrapForwardState copyWith({
    FormStatus? formStatus,
    List<ForwardMeta>? forwardMetas,
    List<ForwardMeta>? selectedforwardMetas,
    bool? isDeleteMode,
    String? requestErrorMsg,
    String? deleteResultMsg,
  }) {
    return TrapForwardState(
      formStatus: formStatus ?? this.formStatus,
      forwardMetas: forwardMetas ?? this.forwardMetas,
      selectedforwardMetas: selectedforwardMetas ?? this.selectedforwardMetas,
      isDeleteMode: isDeleteMode ?? this.isDeleteMode,
      requestErrorMsg: requestErrorMsg ?? this.deleteResultMsg,
      deleteResultMsg: deleteResultMsg ?? this.deleteResultMsg,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        forwardMetas,
        selectedforwardMetas,
        isDeleteMode,
        requestErrorMsg,
        deleteResultMsg,
      ];
}
