part of 'bookmarks_bloc.dart';

class BookmarksState extends Equatable {
  const BookmarksState({
    this.formStatus = FormStatus.none,
    this.devices = const [],
    this.errmsg = '',
  });

  final FormStatus formStatus;
  final List<Device> devices;
  final String errmsg;

  BookmarksState copyWith({
    FormStatus? formStatus,
    List<Device>? devices,
    String? errmsg,
  }) {
    return BookmarksState(
      formStatus: formStatus ?? this.formStatus,
      devices: devices ?? this.devices,
      errmsg: errmsg ?? this.errmsg,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        devices,
        errmsg,
      ];
}
