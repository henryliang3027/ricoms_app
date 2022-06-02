enum FormStatus {
  /// The form is in the process of requesting data.
  requestInProgress,

  /// The form has been requested successfully.
  requestSuccess,

  /// The form request failed.
  requestFailure,
}

enum SubmissionStatus {
  none,

  /// The form is in the process of submission data.
  submissionInProgress,

  /// The form has been submitted successfully.
  submissionSuccess,

  /// The form submission failed.
  submissionFailure,
}

extension FormStatusX on FormStatus {
  /// Indicates whether the form is in the process of being requested.
  bool get isRequestInProgress => this == FormStatus.requestInProgress;

  /// Indicates whether the form has been requested successfully.
  bool get isRequestSuccess => this == FormStatus.requestSuccess;

  /// Indicates whether the form request failed.
  bool get isrequestFailure => this == FormStatus.requestFailure;
}

extension SubmissionStatusX on SubmissionStatus {
  bool get isNone => this == SubmissionStatus.none;

  /// Indicates whether the form is in the process of being submission.
  bool get isSubmissionInProgress =>
      this == SubmissionStatus.submissionInProgress;

  /// Indicates whether the form has been submitted successfully.
  bool get isSubmissionSuccess => this == SubmissionStatus.submissionSuccess;

  /// Indicates whether the form submission failed.
  bool get isSubmissionFailure => this == SubmissionStatus.submissionFailure;
}
