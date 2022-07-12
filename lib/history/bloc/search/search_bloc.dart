import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc()
      : super(SearchState(
          startDate: DateFormat('yyyy/MM/dd').format(DateTime.now()).toString(),
          endDate: DateFormat('yyyy/MM/dd').format(DateTime.now()).toString(),
        )) {
    on<ShelfChanged>(_onShelfChanged);
    on<SlotChanged>(_onSlotChanged);
    on<KeywordChanged>(_onKeywordChanged);
  }

  void _onShelfChanged(
    ShelfChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(
      startDate: state.startDate,
      endDate: state.endDate,
      shelf: event.shelf,
      slot: state.slot,
      unsolvedOnly: state.unsolvedOnly,
      keyword: state.keyword,
      queries: state.queries,
    ));
  }

  void _onSlotChanged(
    SlotChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(
      startDate: state.startDate,
      endDate: state.endDate,
      shelf: state.shelf,
      slot: event.slot,
      unsolvedOnly: state.unsolvedOnly,
      keyword: state.keyword,
      queries: state.queries,
    ));
  }

  void _onKeywordChanged(
    KeywordChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(
      startDate: state.startDate,
      endDate: state.endDate,
      shelf: state.shelf,
      slot: state.slot,
      unsolvedOnly: state.unsolvedOnly,
      keyword: event.keyword,
      queries: state.queries,
    ));
  }
}
