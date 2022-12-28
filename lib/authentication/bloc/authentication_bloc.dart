import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ricoms_app/repository/authentication_repository.dart';
import 'package:ricoms_app/repository/trap_alarm_color_repository.dart';
import 'package:ricoms_app/repository/trap_alarm_sound_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/alarm_sound_config.dart';
import 'package:ricoms_app/utils/custom_style.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required TrapAlarmColorRepository trapAlarmColorRepository,
    required TrapAlarmSoundRepository trapAlarmSoundRepository,
  })  : _authenticationRepository = authenticationRepository,
        _trapAlarmColorRepository = trapAlarmColorRepository,
        _trapAlarmSoundRepository = trapAlarmSoundRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    _authenticationStatusSubscription = _authenticationRepository.report.listen(
      (report) => add(AuthenticationStatusChanged(report)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final TrapAlarmColorRepository _trapAlarmColorRepository;
  final TrapAlarmSoundRepository _trapAlarmSoundRepository;
  late StreamSubscription<AuthenticationReport>
      _authenticationStatusSubscription;

  StreamSubscription<int>? _permissionStatusSubscription;

  @override
  Future<void> close() {
    if (_permissionStatusSubscription != null) {
      _permissionStatusSubscription!.cancel();
    }
    _authenticationStatusSubscription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  void _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    {
      switch (event.report.status) {
        case AuthenticationStatus.unauthenticated:
          if (_permissionStatusSubscription != null) {
            // if first time login, it will be null
            _permissionStatusSubscription!.cancel();
          }
          return emit(AuthenticationState.unauthenticated(
            msgTitle: event.report.msgTitle,
            msg: event.report.msg,
          ));
        case AuthenticationStatus.authenticated:
          if (event.report.user.id != '0' && event.report.user.id != 'demo') {
            final dataStream = Stream<int>.periodic(
                const Duration(seconds: 3), (count) => count);

            _permissionStatusSubscription = dataStream.listen((event) async {
              var result =
                  await _authenticationRepository.checkUserPermission();

              if (kDebugMode) {
                print('permission change: ${result[1]}');
              }

              if (result[0]) {
                if (result[1]) {
                  if (state.status == AuthenticationStatus.authenticated) {
                    add(const AuthenticationStatusChanged(AuthenticationReport(
                      status: AuthenticationStatus.unauthenticated,
                    )));
                  }
                }
              }
            });
          }

          List<dynamic> resultOfGetColor = await _trapAlarmColorRepository
              .getTrapAlarmColor(user: event.report.user);

          if (resultOfGetColor[0]) {
            CustomStyle.setSeverityColors(resultOfGetColor[1]);
          }

          List<dynamic> resultOfGetAlarmSoundEnableValues =
              await _trapAlarmSoundRepository.getAlarmSoundEnableValues(
                  user: event.report.user);

          if (resultOfGetAlarmSoundEnableValues[0]) {
            AlarmSoundConfig.setAlarmSoundEnableValues(
                resultOfGetAlarmSoundEnableValues[1]);
          }

          return emit(AuthenticationState.authenticated(
            event.report.user,
            event.report.userFunction,
          ));
      }
    }
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut(user: event.user);
  }
}
