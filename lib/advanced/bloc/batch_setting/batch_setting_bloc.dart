import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'batch_setting_event.dart';
part 'batch_setting_state.dart';

class BatchSettingBloc extends Bloc<BatchSettingEvent, BatchSettingState> {
  BatchSettingBloc() : super(BatchSettingInitial()) {
    on<BatchSettingEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
