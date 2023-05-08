import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_alarm_color_repository/trap_alarm_color_repository.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_alarm_sound_repository/trap_alarm_sound_repository.dart';
import 'package:ricoms_app/repository/authentication_repository/authentication_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_api.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockTrapAlarmColorRepository extends Mock
    implements TrapAlarmColorRepository {}

class MockTrapAlarmSoundRepository extends Mock
    implements TrapAlarmSoundRepository {}

class MockHiveInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box {}

class MockUserApi extends Mock implements UserApi {}

Future<void> main() async {
  const User? user = User.empty();
  late MockHiveInterface mockHiveInterface;
  late MockHiveBox mockHiveBox;
  late MockUserApi mockUserApi;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late MockTrapAlarmColorRepository mockTrapAlarmColorRepository;
  late MockTrapAlarmSoundRepository mockTrapAlarmSoundRepository;

  setUp(() {
    mockHiveInterface = MockHiveInterface();
    mockHiveBox = MockHiveBox();
    mockUserApi = MockUserApi();
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockTrapAlarmColorRepository = MockTrapAlarmColorRepository();
    mockTrapAlarmSoundRepository = MockTrapAlarmSoundRepository();
    when(() => mockAuthenticationRepository.report)
        .thenAnswer((_) => const Stream.empty());
  });

  group('AuthenticationBloc', () {
    test('initial state is AuthenticationState.unknown', () {
      final authenticationBloc = AuthenticationBloc(
        authenticationRepository: mockAuthenticationRepository,
        trapAlarmColorRepository: mockTrapAlarmColorRepository,
        trapAlarmSoundRepository: mockTrapAlarmSoundRepository,
      );

      expect(authenticationBloc.state, const AuthenticationState.unknown());
      authenticationBloc.close();
    });

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emit [unauthenticated] when status is unauthenticated',
      setUp: () {
        when(() => mockAuthenticationRepository.report).thenAnswer(
          (_) => Stream.value(
            const AuthenticationReport(
              status: AuthenticationStatus.unauthenticated,
            ),
          ),
        );
      },
      build: () => AuthenticationBloc(
        authenticationRepository: mockAuthenticationRepository,
        trapAlarmColorRepository: mockTrapAlarmColorRepository,
        trapAlarmSoundRepository: mockTrapAlarmSoundRepository,
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(msgTitle: '', msg: ''),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emit [authenticated] when status is authenticated',
      setUp: () {
        when(() => mockAuthenticationRepository.report).thenAnswer(
          (_) => Stream.value(const AuthenticationReport(
            status: AuthenticationStatus.authenticated,
          )),
        );
        when(() => mockAuthenticationRepository.userApi)
            .thenAnswer((_) => mockUserApi);
        when(() => mockUserApi.getActivateUser()).thenAnswer((_) => user);
        when(
          () => mockAuthenticationRepository.getUserFunctions(),
        ).thenAnswer((_) async => [true, <int, bool>{}]);
        when(
          () => mockTrapAlarmColorRepository.getTrapAlarmColor(user: user),
        ).thenAnswer((_) async => [
              true,
              [
                0xff6c757d, //notice background color
                0xff28a745, //normal background color
                0xffffc107, //warning background color
                0xffdc3545, //critical background color
                0xffffffff, //notice font color
                0xffffffff, //normal font color
                0xff000000, //warning font color
                0xffffffff, //critical font color,
              ],
            ]);
        when(
          () => mockTrapAlarmSoundRepository.getAlarmSoundEnableValues(
              user: user),
        ).thenAnswer((_) async => [
              true,
              const [
                false, // activate alarm
                false, // AlarmType.notice
                false, // AlarmType.normal
                false, // AlarmType.warning
                false, // AlarmType.critical
              ],
            ]);
      },
      build: () => AuthenticationBloc(
        authenticationRepository: mockAuthenticationRepository,
        trapAlarmColorRepository: mockTrapAlarmColorRepository,
        trapAlarmSoundRepository: mockTrapAlarmSoundRepository,
      ),
      expect: () => <AuthenticationState>[
        const AuthenticationState.authenticated(user, {}),
      ],
    );
  });
}
