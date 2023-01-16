import 'dart:convert';
import 'package:dio/dio.dart';

class MasterSlaveServerInfo {
  static String masterServerIP = '';
  static String slaveServerIP = '';
  static String onlineServerIP = '';

  static Future<String> getOnlineServerIP({
    required String loginIP,
    required Dio dio,
  }) async {
    dio.options.baseUrl = 'http://' + loginIP + '/aci/api';
    dio.options.connectTimeout = 1000; //10s
    dio.options.receiveTimeout = 1000;
    String serverIPInformationPath = '/advanced/masterslave';

    try {
      Response response = await dio.get(
        serverIPInformationPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        int model = data['data'][0]['model'];
        MasterSlaveServerInfo.masterServerIP = data['data'][0]['server_master'];
        MasterSlaveServerInfo.slaveServerIP = data['data'][0]['server_slave'];
        MasterSlaveServerInfo.onlineServerIP = data['data'][0]['server_online'];
        if (model == 1) {
          return MasterSlaveServerInfo.onlineServerIP;
        } else {
          return loginIP;
        }
      } else {
        return loginIP;
      }
    } on DioError catch (_) {
      return MasterSlaveServerInfo.slaveServerIP;
    }
  }
}
