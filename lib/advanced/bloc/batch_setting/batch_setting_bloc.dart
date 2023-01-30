import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/batch_setting_repository.dart';
import 'package:ricoms_app/repository/module.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'batch_setting_event.dart';
part 'batch_setting_state.dart';

class BatchSettingBloc extends Bloc<BatchSettingEvent, BatchSettingState> {
  BatchSettingBloc({
    required User user,
    required BatchSettingRepository batchSettingRepository,
  })  : _user = user,
        _batchSettingRepository = batchSettingRepository,
        super(const BatchSettingState()) {
    on<ModuleDataRequested>(_onModulleDataRequested);

    add(const ModuleDataRequested());
  }

  final User _user;
  final BatchSettingRepository _batchSettingRepository;

  void _onModulleDataRequested(
    ModuleDataRequested event,
    Emitter<BatchSettingState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    List<dynamic> result =
        await _batchSettingRepository.getModuleData(user: _user);

    if (result[0]) {
      List<Module> modules = result[1];
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        modules: modules,
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        modules: [],
        requestErrorMsg: result[1],
      ));
    }
  }
}
