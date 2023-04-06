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
      // 如果在已經登入時登出 onlineServerIP 不為空字串, 則回傳 onlineServerIP
      if (MasterSlaveServerInfo.onlineServerIP != '') {
        // 如果 login ip == masterServerIP 或 slaveServerIP, 則回傳 online ip
        if (loginIP == MasterSlaveServerInfo.masterServerIP ||
            loginIP == MasterSlaveServerInfo.slaveServerIP) {
          return MasterSlaveServerInfo.onlineServerIP;
        } else {
          // 如果不是, 則回傳輸入的 loginIP (這樣才會顯示 login IP 錯誤訊息)
          return loginIP;
        }
      } else {
        // 如果是開啟app時首次登入, MasterSlaveServerInfo 都是空字串, 所以直接回傳輸入的 loginIP
        return loginIP;
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
        // 如果api取得資料失敗, 則判斷是否切換ip
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
