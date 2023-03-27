import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/log_record_setting.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

class LogRecordSettingRepository {
  LogRecordSettingRepository();

  /// call api 取得'清除記錄相關設定'資料
  Future<List<dynamic>> getLogRecordSetting({required User user}) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String logRecordSettingApiPath = '/advanced/datasave';

    try {
      Response response = await dio.get(
        logRecordSettingApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        LogRecordSetting logRecordSetting = List<LogRecordSetting>.from(
            data['data']
                .map((element) => LogRecordSetting.fromJson(element)))[0];

        return [
          true,
          logRecordSetting,
        ];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 更新'清除記錄相關設定'資料, 向後端更新設定資料
  Future<List<dynamic>> setLogRecordSetting({
    required User user,
    required LogRecordSetting logRecordSetting,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String logRecordSettingApiPath = '/advanced/datasave';

    try {
      Map<String, dynamic> requestData = logRecordSetting.toJson();
      requestData['uid'] = user.id;

      Response response = await dio.put(
        logRecordSettingApiPath,
        data: requestData,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [
          true,
          logRecordSetting,
        ];
      } else {
        return [false, data['msg']];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }
}
