import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_api.dart';
import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/user_function.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository();

  final UserApi userApi = UserApi(); // public field
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    //await Future<void>.delayed(const Duration(seconds: 1));

    User? user = userApi.getActivateUser();

    if (user == null) {
      yield AuthenticationStatus.unauthenticated;
    } else {
      await autoLogIn(user: user);
    }
    yield* _controller.stream;
  }

  Future<void> autoLogIn({
    required User user,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String loginPath = '/account/login';

    try {
      //404
      Response response = await dio.post(
        loginPath,
        data: {'account': user.name, 'pwd': user.password},
      );

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        _controller.add(AuthenticationStatus.authenticated);
      } else {
        // username or password has changed on website
        _controller.add(AuthenticationStatus.unauthenticated);
      }
    } catch (e) {
      // user activated but no internet
      bool _ = await userApi.deActivateUser(user.id);
      _controller.add(AuthenticationStatus.unknown);
    }
  }

  Future<String> logIn({
    required String ip,
    required String username,
    required String password,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String loginPath = '/account/login';

    try {
      //404
      Response response = await dio.post(
        loginPath,
        data: {'account': username, 'pwd': password},
      );

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        //print(data);
        // accunt and password are correct
        String userId = data['data']['uid'].toString();
        String accountInformationPath =
            'http://' + ip + '/aci/api/account/' + userId;

        Response infoResponse = await dio.get(accountInformationPath);
        var infoData = jsonDecode(infoResponse.data.toString());

        await userApi.addUserByKey(
          userId: userId,
          ip: ip,
          name: infoData['data'][0]['name'].toString(),
          password: password,
          email: infoData['data'][0]['email'].toString(),
          mobile: infoData['data'][0]['mobile'].toString(),
          tel: infoData['data'][0]['tel'].toString(),
          ext: infoData['data'][0]['ext'].toString(),
        );

        _controller.add(AuthenticationStatus.authenticated);
        return '';
      } else {
        _controller.add(AuthenticationStatus.unauthenticated);
        return data['msg'];
      }
    } catch (e) {
      // if ip does not exist

      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      _controller.add(AuthenticationStatus.unauthenticated);
      if (e is DioError) {
        if (e.response != null) {
          if (kDebugMode) {
            print(e.response!.data);
            print(e.response!.headers);
            print(e.response!.requestOptions);
          }

          throw Exception('Server No Response');
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          if (kDebugMode) {
            print(e.requestOptions);
            print(e.message);
          }

          throw Exception(e.message);
        }
      } else {
        throw Exception(e.toString());
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
    // need to call api ?
    bool _ = await userApi.deActivateUser(userId);
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    User? user = userApi.getActivateUser();
    if (user != null) {
      Dio dio = Dio();
      dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
      dio.options.connectTimeout = 10000; //10s
      dio.options.receiveTimeout = 10000;

      String changePasswordPath = '/account/' + user.id + '/pwd';

      try {
        //404
        Response response = await dio.put(
          changePasswordPath,
          data: {'current_pwd': currentPassword, 'new_pwd': newPassword},
        );

        //print(response.data.toString());
        var data = jsonDecode(response.data.toString());

        if (data['code'] == '200') {
          //print(data);

          return '';
        } else {
          return data['msg'];
        }
      } catch (e) {
        // if ip does not exist

        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        if (e is DioError) {
          if (e.response != null) {
            if (kDebugMode) {
              print(e.response!.data);
              print(e.response!.headers);
              print(e.response!.requestOptions);
            }

            throw Exception('Server No Response');
          } else {
            // Something happened in setting up or sending the request that triggered an Error
            if (kDebugMode) {
              print(e.requestOptions);
              print(e.message);
            }

            throw Exception(e.message);
          }
        } else {
          throw Exception(e.toString());
        }

        //print('CPE: $e');

      }
    } else {
      //print('User dose not exist when logout');
      return 'User dose not exist when logout';
    }
  }

  Future<List<dynamic>> getUserFunctions({
    String? functionId,
  }) async {
    User? user = userApi.getActivateUser();
    if (user != null) {
      Dio dio = Dio();
      dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
      dio.options.connectTimeout = 10000; //10s
      dio.options.receiveTimeout = 10000;

      String userFunctionPath;

      if (functionId != null) {
        userFunctionPath = '/account/' + user.id + '/func/' + functionId;
      } else {
        userFunctionPath = '/account/' + user.id + '/func';
      }

      try {
        //404
        Response response = await dio.get(
          userFunctionPath,
        );

        //print(response.data.toString());
        var data = jsonDecode(response.data.toString());

        if (data['code'] == '200') {
          List<UserFunction> userFunctions = List<UserFunction>.from(
              data['data']['user_func']
                  .map((element) => UserFunction.fromJson(element)));

          Map<int, bool> userFunctionMap = {};
          for (UserFunction element in userFunctions) {
            bool userFunctionStatus = element.status == 1 ? true : false;
            userFunctionMap[element.functionId] = userFunctionStatus;
          }

          return [true, userFunctionMap];
        } else {
          return [false, 'Failed to get user function'];
        }
      } catch (e) {
        // if ip does not exist

        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        if (e is DioError) {
          if (e.response != null) {
            if (kDebugMode) {
              print(e.response!.data);
              print(e.response!.headers);
              print(e.response!.requestOptions);
            }
            return [false, 'Server No Response'];
          } else {
            // Something happened in setting up or sending the request that triggered an Error
            if (kDebugMode) {
              print(e.requestOptions);
              print(e.message);
            }

            return [false, e.message];
          }
        } else {
          return [false, e.toString()];
        }
      }
    } else {
      return [false, 'User does not exist'];
    }
  }

  void dispose() => _controller.close();
}
