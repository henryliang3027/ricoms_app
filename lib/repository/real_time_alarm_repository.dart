import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/user.dart';

class RealTimeAlarmRepository {
  RealTimeAlarmRepository();

  final Dio _dio = Dio();

  Future<List<dynamic>> getRealTimeAlarm(User user, AlarmType alarmType) async {
    _dio.options.baseUrl = 'http://' + user.ip + '/aci/api/';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;
    String realTimeAlarmApiPath = '/history/realtime?max=';

    try {
      //404
      Response response = await _dio.get(
        realTimeAlarmApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List rawData = data['data']['result'];
        List<Alarm> alarmDataList = [];

        rawData.forEach((element) {
          if (element['node_id'] != null) {
            Alarm alarm = Alarm(
              id: element['node_id'],
              event: element['event'],
              name: element['name'],
              receivedTime: element['startdate'],
              ip: element['ip'],
              severity: element['severity'],
            );

            alarmDataList.add(alarm);
          }
        });

        switch (alarmType) {
          case AlarmType.all:
            break;
          case AlarmType.critical:
            alarmDataList.removeWhere((element) => element.severity != 3);
            break;
          case AlarmType.warning:
            alarmDataList.removeWhere((element) => element.severity != 2);
            break;
          case AlarmType.normal:
            alarmDataList.removeWhere((element) => element.severity != 1);
            break;
          case AlarmType.notice:
            alarmDataList.removeWhere((element) => element.severity != 0);
            break;
          default:
            break;
        }

        return [true, alarmDataList];
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

enum AlarmType {
  all,
  critical, // 3
  warning, // 2
  normal, // 1
  notice, // 0
}

class Alarm {
  const Alarm({
    required this.id, //device id
    this.event = '',
    this.name = '', // device name
    this.receivedTime = '',
    this.ip = '', //device ip
    this.severity = -1,
  });

  final int id;
  final String event;
  final String name;
  final String receivedTime;
  final String ip;
  final int severity;
}
