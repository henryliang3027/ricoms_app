import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/batch_setting_repository.dart';
import 'package:ricoms_app/repository/module.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'select_module_event.dart';
part 'select_module_state.dart';

class SelectModuleBloc extends Bloc<SelectModuleEvent, SelectModuleState> {
  SelectModuleBloc({
    required User user,
    required BatchSettingRepository batchSettingRepository,
  })  : _user = user,
        _batchSettingRepository = batchSettingRepository,
        super(const SelectModuleState()) {
    on<ModuleDataRequested>(_onModulleDataRequested);
    on<KeywordChanged>(_onKeywordChanged);
    on<ModuleDataSearched>(_onModuleDataSearched);

    add(const ModuleDataRequested());
  }

  final User _user;
  final BatchSettingRepository _batchSettingRepository;
  final List<Module> _allModules = [];

  void _onModulleDataRequested(
    ModuleDataRequested event,
    Emitter<SelectModuleState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    List<dynamic> result =
        await _batchSettingRepository.getModuleData(user: _user);

    if (result[0]) {
      List<Module> modules = result[1];
      _allModules.addAll(modules);
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

  void _onKeywordChanged(
    KeywordChanged event,
    Emitter<SelectModuleState> emit,
  ) {
    emit(state.copyWith(
      keyword: event.keyword,
    ));
  }

  void _onModuleDataSearched(
    ModuleDataSearched event,
    Emitter<SelectModuleState> emit,
  ) {
    if (state.keyword.isNotEmpty) {
      List<Module> modules = [];

      modules = _allModules
          .where((module) =>
              module.name.toLowerCase().contains(state.keyword.toLowerCase()))
          .toList();

      emit(state.copyWith(
        modules: modules,
      ));
    } else {
      emit(state.copyWith(
        modules: _allModules,
      ));
    }
  }
}
