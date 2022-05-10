import 'dart:async';
import 'dart:convert';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_repository.dart';
import 'package:dio/dio.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository(this.userRepository);

  final Dio dio = Dio();
  final UserRepository userRepository;
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));

    User? user = await userRepository.getActivateUser();

    if (user == null) {
      yield AuthenticationStatus.unauthenticated;
    } else {
      yield AuthenticationStatus.authenticated;
    }

    //yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String ip,
    required String username,
    required String password,
  }) async {
    String loginPath = 'http://' + ip + '/aci/api/account/login';

    try {
      //404
      Response response = await dio.post(
        loginPath,
        data: {'account': username, 'pwd': password},
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        print(data);
        // accunt and password are correct
        String userId = data['data']['uid'].toString();
        await userRepository.addUserByKey(
            userId, User(id: userId, ip: ip, isActivate: true));
        _controller.add(AuthenticationStatus.authenticated);
      } else {
        _controller.add(AuthenticationStatus.unauthenticated);
      }

      print(response.data.toString());
    } on DioError catch (e) {
      _controller
          .add(AuthenticationStatus.unauthenticated); // if ip does not exist
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response!.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }

    // await Future.delayed(
    //   const Duration(milliseconds: 300),
    //   () => _controller.add(AuthenticationStatus.authenticated),
    // );
  }

  Future<void> logOut({
    required userId,
  }) async {
    bool ret = await userRepository.deActivateUser(userId);
    print('is_logoug : ' + ret.toString());

    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
