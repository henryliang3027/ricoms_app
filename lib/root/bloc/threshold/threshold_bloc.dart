import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/repository/root_repository.dart';

part 'threshold_event.dart';
part 'threshold_state.dart';

class ThresholdBloc extends Bloc<ThresholdEvent, ThresholdState> {
  ThresholdBloc({required RootRepository rootRepository})
      : _rootRepository = rootRepository,
        super(const ThresholdState()) {
    on<ThresholdDataRequested>(_onThresholdDataRequested);
    on<ControllerValueChanged>(_onControllerValueChanged);
  }

  final RootRepository _rootRepository;

  Future<void> _onThresholdDataRequested(
    ThresholdDataRequested event,
    Emitter<ThresholdState> emit,
  ) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    dynamic data = await _rootRepository.getDeviceThreshold();

    if (data is List) {
      emit(state.copyWith(status: FormzStatus.submissionSuccess, data: data));
    } else {
      emit(state.copyWith(status: FormzStatus.submissionFailure, data: [data]));
    }
  }

  void _onControllerValueChanged(
    ControllerValueChanged event,
    Emitter<ThresholdState> emit,
  ) {
    emit(state.copyWith(controllerValues: event.controllerValues));
  }
}
