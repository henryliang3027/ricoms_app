import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/user.dart';

class DashboardRepository {
  DashboardRepository();

  final Dio _dio = Dio();

  Future<List<dynamic>> getDeviceStatusStatistics({
    required User user,
  }) async {
    _dio.options.baseUrl = 'http://' + user.ip + '/aci/api/';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;
    String deviceStatusStatisticApiPath = '/statistics/device';

    try {
      //404
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
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e is DioError) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
          //throw Exception('Server No Response');
          return [false, 'Server No Response'];
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
          //throw Exception(e.message);
          return [false, e.message];
        }
      } else {
        //throw Exception(e.toString());
        return [false, e.toString()];
      }
    }
  }

  Future<List<dynamic>> getAlarmSeverityStatistics({
    required User user,
    required int type,
  }) async {
    _dio.options.baseUrl = 'http://' + user.ip + '/aci/api/';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;
    String deviceSeverityStatisticApiPath =
        '/statistics/severity?type=${type.toString()}';

    try {
      //404
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
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e is DioError) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
          //throw Exception('Server No Response');
          return [false, 'Server No Response'];
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
          //throw Exception(e.message);
          return [false, e.message];
        }
      } else {
        //throw Exception(e.toString());
        return [false, e.toString()];
      }
    }
  }
}
