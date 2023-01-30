import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/module.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

class BatchSettingRepository {
  Future<dynamic> getModuleData({
    required User user,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String batchSettingApiPath = '/advanced/modulebatch';

    try {
      Response response = await dio.get(
        batchSettingApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List<Module> modules = List<Module>.from(
            data['data'].map((element) => Module.fromJson(element)));

        return [
          true,
          modules,
        ];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<bool> setDeviceParameter({
    required User user,
  }) async {
    await Future.delayed(const Duration(seconds: 3));
    return true;
    // Dio dio = Dio();
    // dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    // dio.options.connectTimeout = 10000; //10s
    // dio.options.receiveTimeout = 10000;
    // String trapForwardListApiPath = '/advanced/forward';

    // try {
    //   Response response = await dio.get(
    //     trapForwardListApiPath,
    //   );

    //   var data = jsonDecode(response.data.toString());

    //   if (data['code'] == '200') {
    //     // List<ForwardOutline> forwardOutlineList = List<ForwardOutline>.from(
    //     //     data['data'].map((element) => ForwardOutline.fromJson(element)));

    //     return [true, []];
    //   } else {
    //     return [false, 'There are no records to show'];
    //   }
    // } on DioError catch (_) {
    //   return [false, CustomErrMsg.connectionFailed];
    // }
  }
}
