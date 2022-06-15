import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc({
    required RootRepository rootRepository,
  })  : _rootRepository = rootRepository,
        super(const RootState()) {
    on<ChildDataRequested>(_onChildDataRequested);

    add(const ChildDataRequested(Node(
      id: 0,
      type: 1,
      name: 'Root',
    )));
  }

  final RootRepository _rootRepository;
  final List<Node> _directory = <Node>[];

  Future<void> _onChildDataRequested(
    ChildDataRequested event,
    Emitter<RootState> emit,
  ) async {
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
    ));

    dynamic data = await _rootRepository.getChilds(event.parent);

    !_directory.contains(event.parent) ? _directory.add(event.parent) : null;
    int currentIndex = _directory
        .indexOf(event.parent); // -1 represent to element does not exist
    currentIndex != -1
        ? _directory.removeRange(
            currentIndex + 1 < _directory.length
                ? currentIndex + 1
                : _directory.length,
            _directory.length)
        : null;

    if (data is List) {
      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        submissionStatus: SubmissionStatus.none,
        data: data,
        directory: _directory,
      ));
    } else {
      emit(state.copyWith(
        formStatus: FormStatus.requestFailure,
        submissionStatus: SubmissionStatus.none,
        data: [data],
      ));
    }
  }
}
