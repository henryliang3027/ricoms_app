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

    User? user = userRepository.getActivateUser();

    if (user == null) {
      yield AuthenticationStatus.unauthenticated;
    } else {
      yield AuthenticationStatus.authenticated;
    }

    //yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<String> logIn({
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

      print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        print(data);
        // accunt and password are correct
        String userId = data['data']['uid'].toString();
        String accountInformationPath =
            'http://' + ip + '/aci/api/account/' + userId;

        Response infoResponse = await dio.get(accountInformationPath);
        var infoData = jsonDecode(infoResponse.data.toString());

        await userRepository.addUserByKey(
            userId,
            User(
                id: userId,
                ip: ip,
                name: infoData['data'][0]['name'].toString(),
                email: infoData['data'][0]['email'].toString(),
                mobile: infoData['data'][0]['mobile'].toString(),
                tel: infoData['data'][0]['tel'].toString(),
                ext: infoData['data'][0]['ext'].toString(),
                isActivate: true));

        _controller.add(AuthenticationStatus.authenticated);
        return '';
      } else {
        _controller.add(AuthenticationStatus.unauthenticated);
        return data['msg'];
      }
    } on DioError catch (e) {
      // if ip does not exist
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
      _controller.add(AuthenticationStatus.unauthenticated);
      throw Exception('Authentication Failure');
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
    print('is_logout : ' + ret.toString());

    _controller.add(AuthenticationStatus.unauthenticated);
  }

  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    User? user = userRepository.getActivateUser();
    if (user != null) {
      String loginPath =
          'http://' + user.ip + '/aci/api/account/' + user.id + '/pwd';

      try {
        //404
        Response response = await dio.put(
          loginPath,
          data: {'current_pwd': currentPassword, 'new_pwd': newPassword},
        );

        print(response.data.toString());
        var data = jsonDecode(response.data.toString());

        if (data['code'] == '200') {
          print(data);

          return '';
        } else {
          return data['msg'];
        }
      } on DioError catch (e) {
        // if ip does not exist
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

        throw Exception('Change password Failure');
      }
    } else {
      //print('User dose not exist when logout');
      return 'User dose not exist when logout';
    }
  }

  void dispose() => _controller.close();
}
