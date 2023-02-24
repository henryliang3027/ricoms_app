part of 'root_bloc.dart';

class RootState extends Equatable {
  const RootState({
    this.formStatus = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
    this.nodesExportStatus = FormStatus.none,
    this.nodesExportFilePath = '',
    this.dataSheetOpenStatus = FormStatus.none,
    this.dataSheetOpenPath = '',
    this.data = const [],
    this.directory = const [],
    this.isAddedToBookmarks = false,
    this.isLeafNodeDeleted = false,
    this.deleteResultMsg = '',
    this.errmsg = '',
    this.bookmarksMsg = '',
    this.nodesExportMsg = '',
    this.dataSheetOpenMsg = '',
  });

  final FormStatus formStatus;
  final SubmissionStatus submissionStatus;
  final FormStatus nodesExportStatus;
  final String nodesExportFilePath;
  final FormStatus dataSheetOpenStatus;
  final String dataSheetOpenPath;
  final List data;
  final List<Node> directory;
  final bool isAddedToBookmarks;
  final bool isLeafNodeDeleted;
  final String deleteResultMsg;
  final String errmsg;
  final String bookmarksMsg;
  final String nodesExportMsg;
  final String dataSheetOpenMsg;

  RootState copyWith({
    FormStatus? formStatus,
    SubmissionStatus? submissionStatus,
    FormStatus? nodesExportStatus,
    String? nodesExportFilePath,
    FormStatus? dataSheetOpenStatus,
    String? dataSheetOpenPath,
    List? data,
    List<Node>? directory,
    bool? isUpdateData,
    bool? isAddedToBookmarks,
    bool? isLeafNodeDeleted,
    String? deleteResultMsg,
    String? errmsg,
    String? bookmarksMsg,
    String? nodesExportMsg,
    String? dataSheetOpenMsg,
  }) {
    return RootState(
      formStatus: formStatus ?? this.formStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      nodesExportStatus: nodesExportStatus ?? this.nodesExportStatus,
      nodesExportFilePath: nodesExportFilePath ?? this.nodesExportFilePath,
      dataSheetOpenStatus: dataSheetOpenStatus ?? this.dataSheetOpenStatus,
      dataSheetOpenPath: dataSheetOpenPath ?? this.dataSheetOpenPath,
      data: data ?? this.data,
      directory: directory ?? this.directory,
      isAddedToBookmarks: isAddedToBookmarks ?? this.isAddedToBookmarks,
      isLeafNodeDeleted: isLeafNodeDeleted ?? this.isLeafNodeDeleted,
      deleteResultMsg: deleteResultMsg ?? this.deleteResultMsg,
      errmsg: errmsg ?? this.errmsg,
      bookmarksMsg: bookmarksMsg ?? this.bookmarksMsg,
      nodesExportMsg: nodesExportMsg ?? this.nodesExportMsg,
      dataSheetOpenMsg: dataSheetOpenMsg ?? this.dataSheetOpenMsg,
    );
  }

  @override
  List<Object?> get props => [
        formStatus,
        submissionStatus,
        nodesExportStatus,
        nodesExportFilePath,
        dataSheetOpenStatus,
        dataSheetOpenPath,
        data,
        directory,
        isAddedToBookmarks,
        isLeafNodeDeleted,
        deleteResultMsg,
        errmsg,
        bookmarksMsg,
        nodesExportMsg,
        dataSheetOpenMsg,
      ];
}
