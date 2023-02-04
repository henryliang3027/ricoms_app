part of 'select_module_bloc.dart';

class SelectModuleState extends Equatable {
  const SelectModuleState({
    this.status = FormStatus.none,
    this.keyword = '',
    this.modules = const [],
    this.requestErrorMsg = '',
  });

  final FormStatus status;
  final String keyword;
  final List<Module> modules;
  final String requestErrorMsg;

  SelectModuleState copyWith({
    FormStatus? status,
    String? keyword,
    List<Module>? modules,
    String? requestErrorMsg,
  }) {
    return SelectModuleState(
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
