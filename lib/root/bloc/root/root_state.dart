part of 'root_bloc.dart';

class RootState extends Equatable {
  const RootState({
    this.formStatus = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
    this.nodesExportStatus = FormStatus.none,
    this.nodesExportFilePath = '',
    this.data = const [],
    this.directory = const [],
    this.isAddedToBookmarks = false,
    this.deleteResultMsg = '',
    this.errmsg = '',
    this.bookmarksMsg = '',
    this.nodesExportMsg = '',
  });

  final FormStatus formStatus;
  final SubmissionStatus submissionStatus;
  final FormStatus nodesExportStatus;
  final String nodesExportFilePath;
  final List data;
  final List<Node> directory;
  final bool isAddedToBookmarks;
  final String deleteResultMsg;
  final String errmsg;
  final String bookmarksMsg;
  final String nodesExportMsg;

  RootState copyWith({
    FormStatus? formStatus,
    SubmissionStatus? submissionStatus,
    FormStatus? nodesExportStatus,
    String? nodesExportFilePath,
    List? data,
    List<Node>? directory,
    bool? isAddedToBookmarks,
    String? deleteResultMsg,
    String? errmsg,
    String? bookmarksMsg,
    String? nodesExportMsg,
  }) {
    return RootState(
      formStatus: formStatus ?? this.formStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      nodesExportStatus: nodesExportStatus ?? this.nodesExportStatus,
      nodesExportFilePath: nodesExportFilePath ?? this.nodesExportFilePath,
      data: data ?? this.data,
      directory: directory ?? this.directory,
      isAddedToBookmarks: isAddedToBookmarks ?? this.isAddedToBookmarks,
      deleteResultMsg: deleteResultMsg ?? this.deleteResultMsg,
      errmsg: errmsg ?? this.errmsg,
      bookmarksMsg: bookmarksMsg ?? this.bookmarksMsg,
      nodesExportMsg: nodesExportMsg ?? this.nodesExportMsg,
    );
  }

  @override
  List<Object?> get props => [
        formStatus,
        submissionStatus,
        nodesExportStatus,
        nodesExportFilePath,
        data,
        directory,
        isAddedToBookmarks,
        deleteResultMsg,
        errmsg,
        bookmarksMsg,
        nodesExportMsg,
      ];
}
