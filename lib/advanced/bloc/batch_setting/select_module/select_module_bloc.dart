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
    on<KeywordSearched>(_onKeywordSearched);
    on<KeywordCleared>(_onKeywordCleared);

    add(const ModuleDataRequested());
  }

  final User _user;
  final BatchSettingRepository _batchSettingRepository;
  final List<Module> _allModules = [];

  /// 處理模組資料列表的獲取
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

  /// 處理關鍵字的搜尋
  void _onKeywordSearched(
    KeywordSearched event,
    Emitter<SelectModuleState> emit,
  ) {
    if (event.keyword.isNotEmpty) {
      List<Module> modules = [];

      modules = _allModules
          .where((module) =>
              module.name.toLowerCase().contains(event.keyword.toLowerCase()))
          .toList();

      emit(state.copyWith(
        keyword: event.keyword,
        modules: modules,
      ));
    } else {
      emit(state.copyWith(
        keyword: event.keyword,
        modules: _allModules,
      ));
    }
  }

  /// 處理關鍵字的清除
  void _onKeywordCleared(
    KeywordCleared event,
    Emitter<SelectModuleState> emit,
  ) {
    emit(state.copyWith(
      keyword: '',
      modules: _allModules,
    ));
  }
}
