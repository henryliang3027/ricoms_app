import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/repository/root_repository.dart';

part 'description_event.dart';
part 'description_state.dart';

class DescriptionBloc extends Bloc<DescriptionEvent, DescriptionState> {
  DescriptionBloc({required RootRepository rootRepository})
      : _rootRepository = rootRepository,
        super(const DescriptionState()) {
    on<DescriptionDataRequested>(_onDescriptionDataRequested);
    on<ControllerValueChanged>(_onControllerValueChanged);
  }

  final RootRepository _rootRepository;

  Future<void> _onDescriptionDataRequested(
    DescriptionDataRequested event,
    Emitter<DescriptionState> emit,
  ) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    dynamic data = await _rootRepository.getDeviceDescription();

    if (data is List) {
      emit(state.copyWith(status: FormzStatus.submissionSuccess, data: data));
    } else {
      emit(state.copyWith(status: FormzStatus.submissionFailure, data: [data]));
    }
  }

  void _onControllerValueChanged(
    ControllerValueChanged event,
    Emitter<DescriptionState> emit,
  ) {
    emit(state.copyWith(controllerValues: event.controllerValues));
  }
}
