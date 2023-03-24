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
import 'package:ricoms_app/utils/request_interval.dart';
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

    // 註冊 AuthenticationRepository 的 AuthenticationReport
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

  /// 處理登入認證
  void _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    {
      switch (event.report.status) {
        case AuthenticationStatus.unauthenticated:
          if (_permissionStatusSubscription != null) {
            // 如果是第一次開啟app, _permissionStatusSubscription = null
            // 如果是從登入狀態中登出, 蓻會停止檢查 user permission
            _permissionStatusSubscription!.cancel();
          }
          return emit(AuthenticationState.unauthenticated(
            msgTitle: event.report.msgTitle,
            msg: event.report.msg,
          ));
        case AuthenticationStatus.authenticated:
          if (event.report.user.id != '0' && event.report.user.id != 'demo') {
            // 如果不是 system admin or demo 使用者帳號, 才需要定時檢查 user permission
            final dataStream = Stream<int>.periodic(
                const Duration(seconds: RequestInterval.userPermissionCheck),
                (count) => count);

            _permissionStatusSubscription = dataStream.listen((event) async {
              var result =
                  await _authenticationRepository.checkUserPermission();

              if (kDebugMode) {
                print('permission change: ${result[1]}');
              }

              if (result[0]) {
                if (result[1]) {
                  if (state.status == AuthenticationStatus.authenticated) {
                    print('AuthenticationStatus.unauthenticated');
                    add(const AuthenticationStatusChanged(AuthenticationReport(
                      status: AuthenticationStatus.unauthenticated,
                    )));
                  }
                }
              }
            });
          }

          // 取得使用者個人的 alarm color 設定
          List<dynamic> resultOfGetColor = await _trapAlarmColorRepository
              .getTrapAlarmColor(user: event.report.user);

          // 套用使用者個人的 alarm color 到 CustomStyle (global 變數) 中
          if (resultOfGetColor[0]) {
            CustomStyle.setSeverityColors(resultOfGetColor[1]);
          }

          // 取得使用者個人的 alarm sound 啟用/停用設定
          List<dynamic> resultOfGetAlarmSoundEnableValues =
              await _trapAlarmSoundRepository.getAlarmSoundEnableValues(
                  user: event.report.user);

          // 套用使用者個人的 alarm sound 啟用/停用設定 到 AlarmSoundConfig (global 變數) 中
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

  /// 處理登出
  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut(user: event.user);
  }
}
