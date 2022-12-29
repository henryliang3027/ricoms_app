import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/server_ip_setting.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';

class ServerIPSettingRepository {
  ServerIPSettingRepository();

  Future<List<dynamic>> getServerIPSetting({
    required User user,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String serverIPSettingApiPath = '/advanced/masterslave/info';

    try {
      Response response = await dio.get(
        serverIPSettingApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        ServerIPSetting serverIPSetting = List<ServerIPSetting>.from(
            data['data']
                .map((element) => ServerIPSetting.fromJson(element)))[0];

        return [true, serverIPSetting];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<List<dynamic>> setServerIPSetting({
    required User user,
    required String masterServerIP,
    required String slaveServerIP,
    required String synchronizationInterval,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String serverIPSettingApiPath = '/advanced/masterslave/info';

    try {
      Map<String, String> requestData = {
        'uid': user.id,
        'server_master': masterServerIP,
        'server_slave': slaveServerIP,
        'master_wait_recovery': synchronizationInterval,
      };

      Response response = await dio.put(
        serverIPSettingApiPath,
        data: requestData,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [true, ''];
      } else {
        return [false, data['msg']];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }
}
