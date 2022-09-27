import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chart_filter_event.dart';
part 'chart_filter_state.dart';

class ChartFilterBloc extends Bloc<ChartFilterEvent, ChartFilterState> {
  ChartFilterBloc() : super(const ChartFilterState()) {
    on<ChartFilterEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
