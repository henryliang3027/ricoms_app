part of 'root_bloc.dart';

class RootState extends Equatable {
  const RootState({
    this.formStatus = FormStatus.requestInProgress,
    this.submissionStatus = SubmissionStatus.none,
    this.saveResultMsg = '',
    this.data = const [],
    this.directory = const [],
  });

  final FormStatus formStatus;
  final SubmissionStatus submissionStatus;
  final String saveResultMsg;
  final List data;
  final List<Node> directory;

  RootState copyWith({
    FormStatus? formStatus,
    SubmissionStatus? submissionStatus,
    String? saveResultMsg,
    List? data,
    List<Node>? directory,
  }) {
    return RootState(
      formStatus: formStatus ?? this.formStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      saveResultMsg: saveResultMsg ?? this.saveResultMsg,
      data: data ?? this.data,
      directory: directory ?? this.directory,
    );
  }

  @override
  List<Object?> get props => [
        formStatus,
        submissionStatus,
        saveResultMsg,
        data,
        directory,
      ];
}
