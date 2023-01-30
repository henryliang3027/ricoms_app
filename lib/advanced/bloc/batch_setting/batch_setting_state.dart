part of 'batch_setting_bloc.dart';

class BatchSettingState extends Equatable {
  const BatchSettingState({
    this.status = FormStatus.none,
    this.keyword = '',
    this.modules = const [],
    this.requestErrorMsg = '',
  });

  final FormStatus status;
  final String keyword;
  final List<Module> modules;
  final String requestErrorMsg;

  BatchSettingState copyWith({
    FormStatus? status,
    String? keyword,
    List<Module>? modules,
    String? requestErrorMsg,
  }) {
    return BatchSettingState(
      status: status ?? this.status,
      keyword: keyword ?? this.keyword,
      modules: modules ?? this.modules,
      requestErrorMsg: requestErrorMsg ?? this.requestErrorMsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        keyword,
        modules,
        requestErrorMsg,
      ];
}
