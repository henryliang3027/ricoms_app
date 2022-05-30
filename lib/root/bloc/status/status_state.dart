part of 'status_bloc.dart';

class StatusState extends Equatable {
  const StatusState({
    this.status = FormzStatus.submissionInProgress,
    this.data = const [],
  });

  final FormzStatus status;
  final List data;

  StatusState copyWith({
    FormzStatus? status,
    List? data,
  }) {
    return StatusState(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [status, data];
}
