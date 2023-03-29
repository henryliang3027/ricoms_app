import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/advanced_repository/server_ip_setting_repository/server_ip_setting.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

class ServerIPSettingRepository {
  ServerIPSettingRepository();

  /// call api 取得 '伺服器 ip 設定'資料
  Future<List<dynamic>> getServerIPSetting({
    required User user,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
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

  /// call api 更新 '伺服器 ip 設定'資料
  Future<List<dynamic>> setServerIPSetting({
    required User user,
    required String masterServerIP,
    required String slaveServerIP,
    required String synchronizationInterval,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
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
