import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/trap_forward_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'trap_forward_event.dart';
part 'trap_forward_state.dart';

class TrapForwardBloc extends Bloc<TrapForwardEvent, TrapForwardState> {
  TrapForwardBloc({
    required User user,
    required TrapForwardRepository trapForwardRepository,
  })  : _user = user,
        _trapForwardRepository = trapForwardRepository,
        super(const TrapForwardState()) {
    on<TrapForwardEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  final User _user;
  final TrapForwardRepository _trapForwardRepository;

  Future<void> _onForwardMetasRequested(
    ForwardMetasRequested event,
    Emitter<TrapForwardState> emit,
  ) async {
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
    ));

    List<dynamic> result =
        await _trapForwardRepository.getForwardMetaList(user: _user);

    if (result[0]) {
      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        forwardMetas: result[1],
      ));
    } else {
      emit(state.copyWith(
        formStatus: FormStatus.requestFailure,
        requestErrorMsg: result[1],
      ));
    }
  }

  void _onForwardMetasDeletedModeEnabled(
    ForwardMetasDeletedModeEnabled event,
    Emitter<TrapForwardState> emit,
  ) {
    if (state.forwardMetas.isNotEmpty) {
      emit(state.copyWith(
        selectedforwardMetas: state.forwardMetas,
        isDeleteMode: true,
      ));
    }
  }

  void _onForwardMetasDeletedModeDisabled(
    ForwardMetasDeletedModeDisabled event,
    Emitter<TrapForwardState> emit,
  ) {
    emit(state.copyWith(
      selectedforwardMetas: const [],
      isDeleteMode: false,
    ));
  }

  Future<void> _onBookmarksDeleted(
    ForwardMetasDeleted event,
    Emitter<TrapForwardState> emit,
  ) async {
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
    ));

    // List<dynamic> resultOfDelete = await _bookmarksRepository.deleteDevices(
    //   user: _user,
    //   devices: state.selectedDevices,
    // );

    // if (resultOfDelete[0]) {
    //   List<dynamic> resultOfRetrieve =
    //       await _bookmarksRepository.getBookmarks(user: _user);

    //   if (resultOfRetrieve[0]) {
    //     emit(state.copyWith(
    //       formStatus: FormStatus.requestSuccess,
    //       deviceDeleteStatus: FormStatus.requestSuccess,
    //       devices: resultOfRetrieve[1],
    //       selectedDevices: const [],
    //       isDeleteMode: false,
    //     ));
    //   } else {
    //     emit(state.copyWith(
    //       formStatus: FormStatus.requestFailure,
    //       deviceDeleteStatus: FormStatus.requestSuccess,
    //       requestErrorMsg: resultOfRetrieve[1],
    //       selectedDevices: const [],
    //       isDeleteMode: false,
    //     ));
    //   }
    // } else {
    //   emit(state.copyWith(
    //     formStatus: FormStatus.requestFailure,
    //     deviceDeleteStatus: FormStatus.requestFailure,
    //     deleteResultMsg: resultOfDelete[1],
    //     selectedDevices: const [],
    //     isDeleteMode: false,
    //   ));
    // }
  }

  void _onForwardMetasItemToggled(
    ForwardMetasItemToggled event,
    Emitter<TrapForwardState> emit,
  ) {
    List<ForwardMeta> selectedForwardMetas = [];

    selectedForwardMetas.addAll(state.selectedforwardMetas);

    if (selectedForwardMetas.contains(event.forwardMeta)) {
      selectedForwardMetas.remove(event.forwardMeta);
    } else {
      selectedForwardMetas.add(event.forwardMeta);
    }

    emit(state.copyWith(
      selectedforwardMetas: selectedForwardMetas,
    ));
  }
}
