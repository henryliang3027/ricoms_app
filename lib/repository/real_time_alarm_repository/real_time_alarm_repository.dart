import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

class RealTimeAlarmRepository {
  RealTimeAlarmRepository();

  final Dio _dio = Dio();

  Future<List<dynamic>> getRealTimeAlarm({
    required User user,
    required AlarmType alarmType,
  }) async {
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: _dio);
    _dio.options.baseUrl = 'http://' + onlineIP + '/aci/api/';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;
    String realTimeAlarmApiPath = '/history/realtime?max=';

    if (user.id == 'demo') {
      return [true, <Alarm>[]];
    }

    try {
      Response response = await _dio.get(
        realTimeAlarmApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List rawDataList = data['data']['result'];
        List<Alarm> alarmDataList = [];

        for (var element in rawDataList) {
          if (element['node_id'] != null) {
            String rawPath = element['path'] ?? '';
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
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
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

class Alarm extends Equatable {
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
  final List<int> path;

  @override
  List<Object?> get props => [
        id,
        event,
        name,
        receivedTime,
        ip,
        shelf,
        slot,
        severity,
        type,
        path,
      ];
}
