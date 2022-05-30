import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/repository/root_repository.dart';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc({required RootRepository rootRepository})
      : _rootRepository = rootRepository,
        super(const StatusState()) {
    on<StatusDataRequested>(_onStatusDataRequested);
  }
  final RootRepository _rootRepository;

  Future<void> _onStatusDataRequested(
    StatusDataRequested event,
    Emitter<StatusState> emit,
  ) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    dynamic data = await _rootRepository.getDeviceStatus();

    if (data is List) {
      emit(state.copyWith(status: FormzStatus.submissionSuccess, data: data));
    } else {
      emit(state.copyWith(status: FormzStatus.submissionFailure, data: [data]));
    }
  }
}
