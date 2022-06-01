import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/repository/root_repository.dart';

part 'configuration_event.dart';
part 'configuration_state.dart';

class ConfigurationBloc extends Bloc<ConfigurationEvent, ConfigurationState> {
  ConfigurationBloc({required RootRepository rootRepository})
      : _rootRepository = rootRepository,
        super(const ConfigurationState()) {
    on<ConfigurationDataRequested>(_onConfigurationDataRequested);
    on<ControllerValueChanged>(_onControllerValueChanged);
  }

  final RootRepository _rootRepository;

  Future<void> _onConfigurationDataRequested(
    ConfigurationDataRequested event,
    Emitter<ConfigurationState> emit,
  ) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    dynamic data = await _rootRepository.getDeviceConfigration();

    if (data is List) {
      emit(state.copyWith(status: FormzStatus.submissionSuccess, data: data));
    } else {
      emit(state.copyWith(status: FormzStatus.submissionFailure, data: [data]));
    }
  }

  void _onControllerValueChanged(
    ControllerValueChanged event,
    Emitter<ConfigurationState> emit,
  ) {
    emit(state.copyWith(controllerValues: event.controllerValues));
  }
}
