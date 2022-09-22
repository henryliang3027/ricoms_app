part of 'edit_trap_forward_bloc.dart';

class EditTrapForwardState extends Equatable {
  const EditTrapForwardState({
    this.isModify = false,
    this.status = FormzStatus.pure,
    this.submissionStatus = SubmissionStatus.none,
    this.isInitController = false,
    this.enable = false,
    this.name = const Name.pure(),
    this.ip = const DeviceIP.pure(),
    this.parameters = const [],
    this.submissionMsg = '',
  });

  final bool isModify;
  final FormzStatus status;
  final SubmissionStatus submissionStatus;
  final bool isInitController;
  final bool enable;
  final Name name;
  final DeviceIP ip;
  final List<Parameter> parameters;
  final String submissionMsg;

  EditTrapForwardState copyWith({
    bool? isModify,
    FormzStatus? status,
    SubmissionStatus? submissionStatus,
    bool? isInitController,
    bool? enable,
    Name? name,
    DeviceIP? ip,
    List<Parameter>? parameters,
    String? submissionMsg,
  }) {
    return EditTrapForwardState(
      isModify: isModify ?? this.isModify,
      status: status ?? this.status,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      isInitController: isInitController ?? this.isInitController,
      enable: enable ?? this.enable,
      name: name ?? this.name,
      ip: ip ?? this.ip,
      parameters: parameters ?? this.parameters,
      submissionMsg: submissionMsg ?? this.submissionMsg,
    );
  }

  @override
  List<Object> get props => [
        isModify,
        status,
        submissionStatus,
        isInitController,
        enable,
        name,
        ip,
        parameters,
        submissionMsg,
      ];
}
