part of 'batch_device_setting_bloc.dart';

class BatchDeviceSettingState extends Equatable {
  const BatchDeviceSettingState({
    this.status = FormStatus.none,
    this.keyword = '',
    this.modules = const [],
    this.requestErrorMsg = '',
  });

  final FormStatus status;
  final String keyword;
  final List<Module> modules;
  final String requestErrorMsg;

  BatchDeviceSettingState copyWith({
    FormStatus? status,
    String? keyword,
    List<Module>? modules,
    String? requestErrorMsg,
  }) {
    return BatchDeviceSettingState(
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
