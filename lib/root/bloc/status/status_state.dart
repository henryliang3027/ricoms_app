part of 'status_bloc.dart';

class StatusState extends Equatable {
  const StatusState({
    this.status = FormzStatus.submissionInProgress,
    this.data = const [],
    this.editable = false,
  });

  final FormzStatus status;
  final List data;
  final bool editable;

  StatusState copyWith({
    FormzStatus? status,
    List? data,
    bool? editable,
  }) {
    return StatusState(
      status: status ?? this.status,
      data: data ?? this.data,
      editable: editable ?? this.editable,
    );
  }

  @override
  List<Object?> get props => [status, data, editable];
}
