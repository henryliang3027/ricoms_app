import 'dart:async';
import 'dart:convert';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_api.dart';
import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/user_function.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

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
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);

    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String loginPath = '/account/login';

    if (user.id == 'demo') {
      _controller.add(AuthenticationReport(
        status: AuthenticationStatus.authenticated,
        user: user,
        userFunction: {
          23: true,
          5: true,
          6: true,
        },
      ));
      return;
    }

    try {
      Response response = await dio.post(
        loginPath,
        data: {'account': user.account, 'pwd': user.password},
      );

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        String userId = data['data']['uid'].toString();

        List resultOfUserInfo = await setUserInfo(
          ip: user.ip,
          userId: userId,
          account: user.account,
          password: user.password,
        );

        if (resultOfUserInfo[0]) {
          final List resultOfUserFunctions = await getUserFunctions();
          final List resultOfUserAdvancedFunctions =
              await getUserFunctions(functionId: '6');
          if (resultOfUserFunctions[0]) {
            Map<int, bool> userFunction = {};
            userFunction.addAll(resultOfUserFunctions[1]);
            if (resultOfUserAdvancedFunctions[0]) {
              userFunction.addAll(resultOfUserAdvancedFunctions[1]);
            }
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
    required String account,
    required String password,
  }) async {
    Dio dio = Dio();
    String onlineIP =
        await MasterSlaveServerInfo.getOnlineServerIP(loginIP: ip, dio: dio);

    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String loginPath = '/account/login';

    if (account == 'demo' && password == 'demo') {
      List resultOfUserInfo = await setUserInfo(
        ip: ip,
        userId: 'demo',
        account: account,
        password: password,
      );

      User? user = userApi.getActivateUser();

      if (user != null) {
        // MasterSlaveServerInfo.setMasterSlaveServerIP(user: user, dio: dio);

        _controller.add(AuthenticationReport(
          status: AuthenticationStatus.authenticated,
          user: user,
          userFunction: {
            23: true,
            5: true,
            6: true,
          },
        ));

        return [true];
      }
    }

    try {
      Response response = await dio.post(
        loginPath,
        data: {'account': account, 'pwd': password},
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
          account: account,
          password: password,
        );

        if (resultOfUserInfo[0]) {
          final List resultOfUserFunctions = await getUserFunctions();
          final List resultOfUserAdvancedFunctions =
              await getUserFunctions(functionId: '6');
          if (resultOfUserFunctions[0]) {
            Map<int, bool> userFunction = {};
            userFunction.addAll(resultOfUserFunctions[1]);
            if (resultOfUserAdvancedFunctions[0]) {
              userFunction.addAll(resultOfUserAdvancedFunctions[1]);
            }

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
    } on DioError catch (_) {
      return [
        false,
        CustomErrMsg.connectionFailed,
      ];
    }
  }

  Future<void> logOut({
    required User user,
  }) async {
    // Call the api to let the server record the log out log

    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);

    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;

    String logOutPath = '/account/logout?uid=${user.id}';

    if (user.id != 'demo') {
      try {
        Response response = await dio.post(
          logOutPath,
        );

        var data = jsonDecode(response.data.toString());

        if (data['code'] == '200') {
        } else {}
      } on DioError catch (_) {}
    }

    bool _ = await userApi.deActivateUser(user.id);
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
      String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
          loginIP: user.ip, dio: dio);

      dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
      dio.options.connectTimeout = 10000; //10s
      dio.options.receiveTimeout = 10000;

      String changePasswordPath = '/account/' + user.id + '/pwd';

      try {
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
      } on DioError catch (_) {
        return CustomErrMsg.connectionFailed;
      }
    } else {
      //print('User dose not exist when logout');
      return 'User dose not exist when logout';
    }
  }

  Future<List<dynamic>> setUserInfo({
    required String ip,
    required String userId,
    required String account,
    required String password,
  }) async {
    Dio dio = Dio();
    String onlineIP =
        await MasterSlaveServerInfo.getOnlineServerIP(loginIP: ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;

    if (userId == '0') {
      // system admin
      await userApi.addUserByKey(
        userId: userId,
        ip: ip,
        name: '',
        account: account,
        password: password,
        permission: '2',
        email: '',
        mobile: '',
        tel: '',
        ext: '',
      );
      return [true];
    } else if (userId == 'demo') {
      // demo
      await userApi.addUserByKey(
        userId: userId,
        ip: ip,
        name: 'Demo',
        account: account,
        password: password,
        permission: '2',
        email: '',
        mobile: '',
        tel: '',
        ext: '',
      );
      return [true];
    } else {
      String accountInformationPath = '/accounts/' + userId;
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
            account: account,
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
      } on DioError catch (_) {
        return [false, CustomErrMsg.connectionFailed];
      }
    }
  }

  Future<List<dynamic>> checkUserPermission() async {
    User? user = userApi.getActivateUser();
    if (user != null) {
      Dio dio = Dio();
      String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
          loginIP: user.ip, dio: dio);

      print('checkUserPermission login ip: ${user.ip}');
      print('checkUserPermission online ip: ${onlineIP}');

      dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
      dio.options.connectTimeout = 10000; //10s
      dio.options.receiveTimeout = 10000;

      String accountInformationPath = '/accounts/' + user.id;

      try {
        Response response = await dio.get(
          accountInformationPath,
        );

        var data = jsonDecode(response.data.toString());

        if (data['code'] == '200') {
          String permission = data['data'][0]['permission'];

          if (user.permission == permission) {
            return [true, false];
          } else {
            return [true, true];
          }
        } else {
          // Failed to get user permission
          return [true, true];
        }
      } on DioError catch (_) {
        return [false, CustomErrMsg.connectionFailed];
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
      String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
          loginIP: user.ip, dio: dio);
      dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
      dio.options.connectTimeout = 10000; //10s
      dio.options.receiveTimeout = 10000;

      String userFunctionPath;

      if (functionId != null) {
        userFunctionPath = '/account/' + user.id + '/func/' + functionId;
      } else {
        userFunctionPath = '/account/' + user.id + '/func';
      }

      try {
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
      } on DioError catch (_) {
        return [false, CustomErrMsg.connectionFailed];
      }
    } else {
      return [false, 'User does not exist'];
    }
  }

  void dispose() => _controller.close();
}
