import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

class DashboardRepository {
  DashboardRepository();

  final Dio _dio = Dio();

  /// call api 取得裝置狀態統計數據
  Future<List<dynamic>> getDeviceStatusStatistics({
    required User user,
  }) async {
    // 如果是 demo 帳號, 全部為 0
    if (user.id == 'demo') {
      List deviceStatistics = [
        0,
        0,
        0,
        0,
        0,
        0,
      ];

      return [true, deviceStatistics];
    }

    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: _dio);
    _dio.options.baseUrl = 'http://' + onlineIP + '/aci/api/';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;
    String deviceStatusStatisticApiPath = '/statistics/device';

    try {
      Response response = await _dio.get(
        deviceStatusStatisticApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        var element = data['data'][0];

        List deviceStatistics = [
          element['all'],
          element['critical'],
          element['warning'],
          element['normal'],
          element['offline'],
          element['unknown'],
        ];

        return [true, deviceStatistics];
      } else {
        return [false, 'Error errno: ${data['code']} msg: ${data['msg']}'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 取得 Alarm 統計數據
  Future<List<dynamic>> getAlarmSeverityStatistics({
    required User user,
    required int type,
  }) async {
    if (user.id == 'demo') {
      List alarmStatistics = [
        0,
        0,
        1,
      ];
      return [true, alarmStatistics];
    }

    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: _dio);
    _dio.options.baseUrl = 'http://' + onlineIP + '/aci/api/';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;
    String deviceSeverityStatisticApiPath =
        '/statistics/severity?type=${type.toString()}';

    try {
      Response response = await _dio.get(
        deviceSeverityStatisticApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        var element = data['data'][0];

        if (element['critical'] == 0 &&
            element['warning'] == 0 &&
            element['normal'] == 0) {
          List alarmStatistics = [
            0,
            0,
            1,
          ];
          return [true, alarmStatistics];
        } else {
          List alarmStatistics = [
            element['critical'],
            element['warning'],
            element['normal'],
          ];
          return [true, alarmStatistics];
        }
      } else {
        return [false, 'Error errno: ${data['code']} msg: ${data['msg']}'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }
}
