import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/authentication_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_api.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockHiveInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box {}

class MockUserApi extends Mock implements UserApi {}

Future<void> main() async {
  const User? user = User.empty();
  MockHiveInterface mockHiveInterface;
  MockHiveBox mockHiveBox;
  late MockUserApi mockUserApi;
  late AuthenticationRepository authenticationRepository;

  setUp(() {
    mockHiveInterface = MockHiveInterface();
    mockHiveBox = MockHiveBox();
    mockUserApi = MockUserApi();
    authenticationRepository = MockAuthenticationRepository();
    when(() => authenticationRepository.status)
        .thenAnswer((_) => const Stream.empty());
    when(() => authenticationRepository.userApi).thenAnswer((_) => mockUserApi);
  });

  group('AuthenticationBloc', () {
    test('initial state is AuthenticationState.unknown', () {
      final authenticationBloc = AuthenticationBloc(
          authenticationRepository: authenticationRepository);

      expect(authenticationBloc.state, const AuthenticationState.unknown());
      authenticationBloc.close();
    });

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emit [unauthenticated] when status is unauthenticated',
      setUp: () {
        when(() => authenticationRepository.status).thenAnswer(
          (_) => Stream.value(AuthenticationStatus.unauthenticated),
        );
      },
      build: () => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(errmsg: '')
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emit [authenticated] when status is authenticated',
      setUp: () {
        when(() => authenticationRepository.status).thenAnswer(
          (_) => Stream.value(AuthenticationStatus.authenticated),
        );
        when(() => authenticationRepository.userApi)
            .thenAnswer((_) => mockUserApi);
        when(() => authenticationRepository.userApi.getActivateUser())
            .thenAnswer((_) => user);
        when(
          () => authenticationRepository.getUserFunctions(),
        ).thenAnswer((_) async => []);
      },
      build: () => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
      ),
      expect: () => <AuthenticationState>[
        const AuthenticationState.authenticated(user, {}),
      ],
    );
  });
}
