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
    dio.options.connectTimeout = 3000; //10s
    dio.options.receiveTimeout = 3000;
    String serverIPInformationPath = '/advanced/masterslave';

    try {
      Response response = await dio.get(
        serverIPInformationPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        MasterSlaveServerInfo.masterServerIP = data['data'][0]['server_master'];
        MasterSlaveServerInfo.slaveServerIP = data['data'][0]['server_slave'];
        MasterSlaveServerInfo.onlineServerIP = data['data'][0]['server_online'];
        return MasterSlaveServerInfo.onlineServerIP;
      } else {
        return loginIP;
      }
    } on DioError catch (_) {
      return MasterSlaveServerInfo.slaveServerIP;
    }
  }
}