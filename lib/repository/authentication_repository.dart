import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_api.dart';
import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/user_function.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';

enum AuthenticationStatus { authenticated, unauthenticated }

class AuthenticationReport {
  const AuthenticationReport({
    required this.status,
    this.user = const User.empty(),
    this.userFunction = const {},
    this.msgTitle = '',
    this.msg = '',
  });

  final AuthenticationStatus status;
  final User user;
  final Map<int, bool> userFunction;
  final String msgTitle;
  final String msg;
}

class AuthenticationRepository {
  AuthenticationRepository();

  final UserApi userApi = UserApi(); // public field
  final _controller = StreamController<AuthenticationReport>();

  Stream<AuthenticationReport> get report async* {
    User? user = userApi.getActivateUser();

    if (user == null) {
      yield const AuthenticationReport(
        status: AuthenticationStatus.unauthenticated,
        msg: '',
      );
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
        String userId = data['data']['uid'].toString();

        List resultOfUserInfo = await setUserInfo(
          ip: user.ip,
          userId: userId,
          password: user.password,
        );

        if (resultOfUserInfo[0]) {
          final List resultOfUserFunctions = await getUserFunctions();
          if (resultOfUserFunctions[0]) {
            Map<int, bool> userFunction = resultOfUserFunctions[1];
            _controller.add(AuthenticationReport(
              status: AuthenticationStatus.authenticated,
              user: user,
              userFunction: userFunction,
            ));
          } else {
            //maybe receive 'Failed to get user function' from server
            bool _ = await userApi.deActivateUser(user.id);
            _controller.add(AuthenticationReport(
              status: AuthenticationStatus.unauthenticated,
              msgTitle: CustomErrTitle.commonErrTitle,
              msg: resultOfUserFunctions[1],
            ));
          }
        } else {
          //maybe receive 'invalid User' message from server
          bool _ = await userApi.deActivateUser(user.id);
          _controller.add(AuthenticationReport(
            status: AuthenticationStatus.unauthenticated,
            msgTitle: CustomErrTitle.commonErrTitle,
            msg: resultOfUserInfo[1],
          ));
        }
      } else {
        // username or password has changed on website
        bool _ = await userApi.deActivateUser(user.id);
        _controller.add(AuthenticationReport(
          status: AuthenticationStatus.unauthenticated,
          msgTitle: CustomErrTitle.commonErrTitle,
          msg: data['msg'],
        ));
      }
    } catch (e) {
      // user activated but no internet connection
      bool _ = await userApi.deActivateUser(user.id);
      _controller.add(
        const AuthenticationReport(
          status: AuthenticationStatus.unauthenticated,
          msgTitle: CustomErrTitle.lostConnectionTitle,
          msg: CustomErrMsg.lostConnectionMsg,
        ),
      );
    }
  }

  Future<List<dynamic>> logIn({
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

        List resultOfUserInfo = await setUserInfo(
          ip: ip,
          userId: userId,
          password: password,
        );

        if (resultOfUserInfo[0]) {
          final List resultOfUserFunctions = await getUserFunctions();
          if (resultOfUserFunctions[0]) {
            Map<int, bool> userFunction = resultOfUserFunctions[1];
            User? user = userApi.getActivateUser();

            if (user != null) {
              _controller.add(AuthenticationReport(
                status: AuthenticationStatus.authenticated,
                user: user,
                userFunction: userFunction,
              ));

              return [true];
            } else {
              // _controller.add(const AuthenticationReport(
              //   status: AuthenticationStatus.unauthenticated,
              //   msg: 'failed to get activated user from local database.',
              // ));

              return [
                false,
                CustomErrMsg.getActivatedUserErrMsg,
              ];
            }
          } else {
            //maybe receive 'Failed to get user function' from server
            // _controller.add(AuthenticationReport(
            //   status: AuthenticationStatus.unauthenticated,
            //   msg: resultOfUserFunctions[1],
            // ));

            return [
              false,
              resultOfUserFunctions[1],
            ];
          }
        } else {
          //may receive invalid User message from server
          // _controller.add(AuthenticationReport(
          //   status: AuthenticationStatus.unauthenticated,
          //   msg: resultOfUserInfo[1],
          // ));

          return [
            false,
            resultOfUserInfo[1],
          ];
        }
      } else {
        // _controller.add(AuthenticationReport(
        //   status: AuthenticationStatus.unauthenticated,
        //   msg: data['msg'],
        // ));

        return [
          false,
          data['msg'],
        ];
      }
    } catch (e) {
      // if ip does not exist

      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      //_controller.add(AuthenticationStatus.unauthenticated);
      if (e is DioError) {
        if (e.response != null) {
          if (kDebugMode) {
            print(e.response!.data);
            print(e.response!.headers);
            print(e.response!.requestOptions);
          }

          // _controller.add(const AuthenticationReport(
          //   status: AuthenticationStatus.unauthenticated,
          //   msg: 'Server no response',
          // ));

          return [
            false,
            'Server no response',
          ];
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          if (kDebugMode) {
            print(e.requestOptions);
            print(e.message);
          }

          // _controller.add(AuthenticationReport(
          //   status: AuthenticationStatus.unauthenticated,
          //   msg: e.message,
          // ));

          return [
            false,
            e.message,
          ];
        }
      } else {
        // _controller.add(AuthenticationReport(
        //   status: AuthenticationStatus.unauthenticated,
        //   msg: e.toString(),
        // ));

        return [
          false,
          e.toString(),
        ];
      }
    }
  }

  Future<void> logOut({
    required userId,
  }) async {
    // need to call api ?
    bool _ = await userApi.deActivateUser(userId);
    _controller.add(const AuthenticationReport(
      status: AuthenticationStatus.unauthenticated,
    ));
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

  Future<List<dynamic>> setUserInfo({
    required String ip,
    required String userId,
    required String password,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;

    if (userId == '0') {
      // system admin
      await userApi.addUserByKey(
        userId: userId,
        ip: ip,
        name: 'support@admin',
        password: password,
        permission: '2',
        email: '',
        mobile: '',
        tel: '',
        ext: '',
      );
      return [true];
    } else {
      String accountInformationPath =
          'http://' + ip + '/aci/api/accounts/' + userId;
      try {
        Response response = await dio.get(
          accountInformationPath,
        );

        var data = jsonDecode(response.data.toString());

        if (data['code'] == '200') {
          Response infoResponse = await dio.get(accountInformationPath);
          var infoData = jsonDecode(infoResponse.data.toString());

          await userApi.addUserByKey(
            userId: userId,
            ip: ip,
            name: infoData['data'][0]['name'].toString(),
            password: password,
            permission: infoData['data'][0]['permission'].toString(),
            email: infoData['data'][0]['email'].toString(),
            mobile: infoData['data'][0]['mobile'].toString(),
            tel: infoData['data'][0]['tel'].toString(),
            ext: infoData['data'][0]['ext'].toString(),
          );
          return [true];
        } else {
          return [false, data['msg']];
        }
      } catch (e) {
        // if ip does not exist

        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        if (e is DioError) {
          return [false, e.message];
        } else {
          return [false, e.toString()];
        }
      }
    }
  }

  Future<List<dynamic>> checkUserPermission() async {
    User? user = userApi.getActivateUser();
    if (user != null) {
      Dio dio = Dio();
      dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
      dio.options.connectTimeout = 10000; //10s
      dio.options.receiveTimeout = 10000;

      String accountInformationPath =
          'http://' + user.ip + '/aci/api/accounts/' + user.id;

      try {
        //404
        Response response = await dio.get(
          accountInformationPath,
        );

        //print(response.data.toString());
        var data = jsonDecode(response.data.toString());

        if (data['code'] == '200') {
          String permission = data['data'][0]['permission'];

          if (user.permission == permission) {
            return [true, false];
          } else {
            return [true, true];
          }
        } else {
          return [false, 'Failed to get user permission'];
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
