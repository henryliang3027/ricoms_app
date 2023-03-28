import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ricoms_app/repository/authentication_repository/user_function.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_api.dart';
import 'package:dio/dio.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

enum AuthenticationStatus { authenticated, unauthenticated }

/// 儲存登入的結果資料
class AuthenticationReport {
  const AuthenticationReport({
    required this.status,
    this.user = const User.empty(), // 使用者帳號資料
    this.userFunction = const {}, // 使用者帳號可以使用的 RICOMS 功能列表
    this.msgTitle = '', // 錯誤訊息標題
    this.msg = '', // 錯誤訊息內容
  });

  final AuthenticationStatus status;
  final User user;
  final Map<int, bool> userFunction;
  final String msgTitle;
  final String msg;
}

class AuthenticationRepository {
  AuthenticationRepository();

  final UserApi userApi = UserApi();
  final _controller = StreamController<AuthenticationReport>();

  /// stream 可以產生(yield) AuthenticationReport instance 給 AuthenticationBloc 裡的 StreamSubscription,
  /// yield* 產生一連串的 AuthenticationReport instance,
  /// yield or yield* 可以理解成 return, 只是 function 的執行不會馬上結束
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

    // 將 _controller 裡的 AuthenticationReport instance, 傳給 AuthenticationBloc 裡的 StreamSubscription
    yield* _controller.stream;
  }

  /// 如果已經登入過, 會自動登入
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
        // username or password has been changed on another mobile app or web
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

  /// 手動登入, 或自動登入失敗時會改為手動登入
  Future<List<dynamic>> logIn({
    required String ip,
    required String account,
    required String password,
  }) async {
    Dio dio = Dio();

    /// 如果已經登入, 接著登出再登入時, 因為會取得 online ip, 所以不一定會用 login ip 登入
    String onlineIP =
        await MasterSlaveServerInfo.getOnlineServerIP(loginIP: ip, dio: dio);

    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String loginPath = '/account/login';

    if (account == 'demo' && password == 'demo') {
      await setUserInfo(
        ip: ip,
        userId: 'demo',
        account: account,
        password: password,
      );

      User? user = userApi.getActivateUser();

      if (user != null) {
        _controller.add(AuthenticationReport(
          status: AuthenticationStatus.authenticated,
          user: user,
          userFunction: {
            23: true, // systemlog
            5: true, // account
            6: true, // advanced
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

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        // accunt and password are valid
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
              // 確定有存入手機端資料庫
              _controller.add(AuthenticationReport(
                status: AuthenticationStatus.authenticated,
                user: user,
                userFunction: userFunction,
              ));

              return [true];
            } else {
              // 沒有存入手機端資料庫
              return [
                false,
                CustomErrMsg.getActivatedUserErrMsg,
              ];
            }
          } else {
            // failed to get user function
            return [
              false,
              resultOfUserFunctions[1],
            ];
          }
        } else {
          // 使用者資料存入手機端資料庫失敗
          return [
            false,
            resultOfUserInfo[1],
          ];
        }
      } else {
        // 登入失敗
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

  /// 登出, call api 將登出的資料記錄在 system log
  Future<void> logOut({
    required User user,
  }) async {
    // Call the api to let the server record the user log out
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

  /// call api 更改使用者密碼
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

  /// 將使用者的登入資料記錄在手機端
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
      // system admin 帳號
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
      // demo 帳號
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
      // 其他帳號
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

  /// 檢查使用者帳號權限是否有被更改
  /// system admin : 1,
  /// administrator : 2,
  /// operator : 3,
  /// user : 4,
  /// disabled : 5,
  Future<List<dynamic>> checkUserPermission() async {
    User? user = userApi.getActivateUser();
    if (user != null) {
      Dio dio = Dio();
      String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
          loginIP: user.ip, dio: dio);

      if (kDebugMode) {
        print('checkUserPermission login ip: ${user.ip}');
        print('checkUserPermission online ip: ${onlineIP}');
      }

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
          // if the request hangs for too long, a code 301 will be returned
          return [false, false];
        }
      } on DioError catch (_) {
        return [false, CustomErrMsg.connectionFailed];
      }
    } else {
      return [false, 'User does not exist'];
    }
  }

  /// 取得使用者帳號可以使用的 RICOMS 功能列表
  /// {"func_id": 2, "name": "dashboard"},
  /// {"func_id": 4, "name": "history"},
  /// {"func_id": 23, "name": "systemlog"},
  /// {"func_id": 5, "name": "account"},
  /// {"func_id": 6, "name": "advanced"}, 包含很多功能 /account/${user.id}/func/6,
  /// {"func_id": 41, "name": "about"},
  /// {"func_id": 42, "name": "contact"},
  /// {"func_id": 8, "name": "New Group & Device"},
  /// {"func_id": 9, "name": "Edit Group & Device"},
  /// {"func_id": 10, "name": "Remove Group & Device"},
  /// {"func_id": 12, "name": "Device Settings(Read)"},
  /// {"func_id": 13, "name": "Tree Node List"},
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

  /// 關閉 StreamController<AuthenticationReport>
  void dispose() => _controller.close();
}
