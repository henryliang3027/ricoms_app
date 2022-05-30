part of 'status_bloc.dart';

abstract class StatusEvent extends Equatable {
  const StatusEvent();

  @override
  List<Object> get props => [];
}

class StatusDataRequested extends StatusEvent {
  const StatusDataRequested();

  @override
  List<Object> get props => [];
}
