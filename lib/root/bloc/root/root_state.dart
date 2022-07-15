part of 'root_bloc.dart';

class RootState extends Equatable {
  const RootState({
    this.formStatus = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
    this.data = const [],
    this.directory = const [],
    this.isAddedToBookmarks = false,
    this.deleteResultMsg = '',
    this.errmsg = '',
    this.bookmarksMsg = '',
  });

  final FormStatus formStatus;
  final SubmissionStatus submissionStatus;
  final List data;
  final List<Node> directory;
  final bool isAddedToBookmarks;
  final String deleteResultMsg;
  final String errmsg;
  final String bookmarksMsg;

  RootState copyWith({
    FormStatus? formStatus,
    SubmissionStatus? submissionStatus,
    List? data,
    List<Node>? directory,
    bool? isAddedToBookmarks,
    String? deleteResultMsg,
    String? errmsg,
    String? bookmarksMsg,
  }) {
    return RootState(
      formStatus: formStatus ?? this.formStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      data: data ?? this.data,
      directory: directory ?? this.directory,
      isAddedToBookmarks: isAddedToBookmarks ?? this.isAddedToBookmarks,
      deleteResultMsg: deleteResultMsg ?? this.deleteResultMsg,
      errmsg: errmsg ?? this.errmsg,
      bookmarksMsg: bookmarksMsg ?? this.bookmarksMsg,
    );
  }

  @override
  List<Object?> get props => [
        formStatus,
        submissionStatus,
        data,
        directory,
        isAddedToBookmarks,
        deleteResultMsg,
        errmsg,
        bookmarksMsg,
      ];
}
