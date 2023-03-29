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
    dio.options.connectTimeout = 1000; //1s
    dio.options.receiveTimeout = 1000;
    String serverIPInformationPath = '/advanced/masterslave';

    /// 如果call api 失敗, 則取得替代 ip (master or slave),
    String _getSubstituteIP({
      required String loginIP,
    }) {
      if (MasterSlaveServerInfo.onlineServerIP != '') {
        // 如果 onlineServerIP 不為空字串, 則回傳 onlineServerIP
        return MasterSlaveServerInfo.onlineServerIP;
      } else {
        // 如果 onlineServerIP 為空字串, 則切換ip
        // 如果登入ip == masterServerIP, 則切換 slaveServerIP
        // 如果登入ip == slaveServerIP, 則切換 masterServerIP
        if (loginIP == MasterSlaveServerInfo.masterServerIP) {
          return MasterSlaveServerInfo.slaveServerIP;
        } else {
          return MasterSlaveServerInfo.masterServerIP;
        }
      }
    }

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
        return _getSubstituteIP(
          loginIP: loginIP,
        );
      }
    } on DioError catch (_) {
      return _getSubstituteIP(
        loginIP: loginIP,
      );
    }
  }
}
