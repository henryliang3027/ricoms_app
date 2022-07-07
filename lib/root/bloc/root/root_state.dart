part of 'root_bloc.dart';

class RootState extends Equatable {
  const RootState({
    this.formStatus = FormStatus.requestInProgress,
    this.submissionStatus = SubmissionStatus.none,
    this.data = const [],
    this.directory = const [],
    this.deleteResultMsg = '',
    this.errmsg = '',
  });

  final FormStatus formStatus;
  final SubmissionStatus submissionStatus;
  final List data;
  final List<Node> directory;
  final String deleteResultMsg;
  final String errmsg;

  RootState copyWith({
    FormStatus? formStatus,
    SubmissionStatus? submissionStatus,
    List? data,
    List<Node>? directory,
    String? deleteResultMsg,
    String? errmsg,
  }) {
    return RootState(
      formStatus: formStatus ?? this.formStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      data: data ?? this.data,
      directory: directory ?? this.directory,
      deleteResultMsg: deleteResultMsg ?? this.deleteResultMsg,
      errmsg: errmsg ?? this.errmsg,
    );
  }

  @override
  List<Object?> get props => [
        formStatus,
        submissionStatus,
        data,
        directory,
        deleteResultMsg,
        errmsg,
      ];
}
