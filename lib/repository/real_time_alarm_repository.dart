import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ricoms_app/repository/user.dart';

class RealTimeAlarmRepository {
  RealTimeAlarmRepository();

  final Dio _dio = Dio();

  Future<List<dynamic>> getRealTimeAlarm({
    required User user,
    required AlarmType alarmType,
  }) async {
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
        List rawDataList = data['data']['result'];
        List<Alarm> alarmDataList = [];

        for (var element in rawDataList) {
          if (element['node_id'] != null) {
            String rawPath = element['path'];
            List<String> nodeIdList =
                rawPath.split(',').where((raw) => raw.isNotEmpty).toList();
            List<int> path = [];
            for (var nodeId in nodeIdList) {
              path.add(int.parse(nodeId));
            }

            Alarm alarm = Alarm(
              id: element['node_id'],
              event: element['event'],
              name: element['name'],
              receivedTime: element['startdate'],
              ip: element['ip'],
              shelf: element['shelf'],
              slot: element['slot'],
              severity: element['severity'],
              type: int.parse(element['type']),
              path: path,
            );

            alarmDataList.add(alarm);
          }
        }

        // sort by received time from latest to oldest
        alarmDataList.sort((b, a) => a.receivedTime.compareTo(b.receivedTime));
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
          if (kDebugMode) {
            print(e.response!.data);
            print(e.response!.headers);
            print(e.response!.requestOptions);
          }
          //throw Exception('Server No Response');
          return [false, 'Server No Response'];
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          if (kDebugMode) {
            print(e.requestOptions);
            print(e.message);
          }
          //throw Exception(e.message);
          return [false, e.message];
        }
      } else {
        //throw Exception(e.toString());
        return [false, e.toString()];
      }
    }
  }

  Future<List<dynamic>> getDeviceStatus({
    required User user,
    required int nodeId,
  }) async {
    _dio.options.baseUrl = 'http://' + user.ip + '/aci/api/';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;
    String realTimeAlarmApiPath = '/device/' + nodeId.toString();

    try {
      //404
      Response response = await _dio.get(
        realTimeAlarmApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [true, ''];
      } else {
        return [false, 'The device does not respond!'];
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e is DioError) {
        if (e.response != null) {
          if (kDebugMode) {
            print(e.response!.data);
            print(e.response!.headers);
            print(e.response!.requestOptions);
          }
          //throw Exception('Server No Response');
          return [false, 'Server No Response'];
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          if (kDebugMode) {
            print(e.requestOptions);
            print(e.message);
          }
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
    this.shelf = -1,
    this.slot = -1,
    this.severity = -1,
    this.type = -1,
    this.path = const [],
  });

  final int id;
  final String event;
  final String name;
  final String receivedTime;
  final String ip;
  final int shelf;
  final int slot;
  final int severity;
  final int type;
  final List path;
}
