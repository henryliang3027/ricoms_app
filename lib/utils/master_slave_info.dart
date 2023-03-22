import 'dart:convert';
import 'package:dio/dio.dart';

class MasterSlaveServerInfo {
  static String masterServerIP = '';
  static String slaveServerIP = '';
  static String onlineServerIP = '';

  /// 取得目前 online server ip
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

        if (model == 1) {
          // 主從模式
          MasterSlaveServerInfo.masterServerIP =
              data['data'][0]['server_master'];
          MasterSlaveServerInfo.slaveServerIP = data['data'][0]['server_slave'];
          MasterSlaveServerInfo.onlineServerIP =
              data['data'][0]['server_online'];
          return MasterSlaveServerInfo.onlineServerIP;
        } else {
          // 非主從模式
          // 全部設定為 login ip
          MasterSlaveServerInfo.masterServerIP = loginIP;
          MasterSlaveServerInfo.slaveServerIP = loginIP;
          MasterSlaveServerInfo.onlineServerIP = loginIP;
          return loginIP;
        }
      } else {
        // 如果api取得資料失敗, 判斷 online server ip 是否不為空
        // 不為空則回傳 onlineServerIP
        return onlineServerIP != '' ? onlineServerIP : loginIP;
      }
    } on DioError catch (_) {
      return MasterSlaveServerInfo.slaveServerIP;
    }
  }
}
