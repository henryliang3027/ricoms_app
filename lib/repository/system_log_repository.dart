import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/storage_permission.dart';

class SystemLogRepository {
  SystemLogRepository();

  Future<List<dynamic>> getLogByFilter({
    required User user,
    String startDate = '',
    String endDate = '',
    String next = '',
    String startId = '',
    String queryData = '',
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String systemLogApiPath =
        '/records/search?uid=${user.id}&start_time=$startDate&end_time=$endDate&next=$next&start_id=$startId&q=$queryData';

    try {
      Response response = await dio.get(
        systemLogApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List rawDataList = data['data']['result'];
        List<Log> logDataList = [];

        for (var element in rawDataList) {
          if (element['id'] != null) {
            List<int> path = [];
            if (element['path'] != null) {
              String rawPath = element['path'] ?? '';
              List<String> nodeIdList =
                  rawPath.split(',').where((raw) => raw.isNotEmpty).toList();

              for (var nodeId in nodeIdList) {
                path.add(int.parse(nodeId));
              }
            }

            Log log = Log(
              id: element['id'],
              logType: element['log_type'] ?? '',
              account: element['account'] ?? '',
              permission: element['permission'] ?? '',
              department: element['dept'] ?? '',
              userIP: element['user_ip'] ?? '',
              startTime: element['start_time'] ?? '',
              deviceIP: element['device_ip'] ?? '',
              group: element['group'] ?? '',
              model: element['model'] ?? '',
              name: element['name'] ?? '',
              device: element['device'] ?? '',
              shelf: element['shelf'] ?? -1,
              slot: element['slot'] ?? -1,
              event: element['event'] ?? '',
              description: element['description'] ?? '',
              nodeId: element['node_id'] ?? -1,
              type: int.parse(element['type'] ?? '-1'),
              path: path,
            );

            logDataList.add(log);
          }
        }

        // sort by received time from latest to oldest
        logDataList.sort((b, a) => a.id.compareTo(b.id));

        return [true, logDataList];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<List<dynamic>> getMoreLogsByFilter({
    required User user,
    String startDate = '',
    String endDate = '',
    String next = '',
    String startId = '',
    String queryData = '',
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String systemLogApiPath =
        '/records/search?uid=${user.id}&start_time=$startDate&end_time=$endDate&next=$next&start_id=$startId&q=$queryData';

    try {
      Response response = await dio.get(
        systemLogApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List rawDataList = data['data']['result'];
        List<Log> logDataList = [];

        for (var element in rawDataList) {
          if (element['id'] != null) {
            String rawPath = element['path'] ?? '';
            List<String> nodeIdList =
                rawPath.split(',').where((raw) => raw.isNotEmpty).toList();
            List<int> path = [];
            for (var nodeId in nodeIdList) {
              path.add(int.parse(nodeId));
            }

            Log log = Log(
              id: element['id'],
              logType: element['log_type'] ?? '',
              account: element['account'] ?? '',
              permission: element['permission'] ?? '',
              department: element['dept'] ?? '',
              userIP: element['user_ip'] ?? '',
              startTime: element['start_time'] ?? '',
              deviceIP: element['device_ip'] ?? '',
              group: element['group'] ?? '',
              model: element['model'] ?? '',
              name: element['name'] ?? '',
              device: element['device'] ?? '',
              shelf: element['shelf'] ?? -1,
              slot: element['slot'] ?? -1,
              event: element['event'] ?? '',
              description: element['description'] ?? '',
              nodeId: element['node_id'] ?? -1,
              type: int.parse(element['type'] ?? '-1'),
              path: path,
            );

            logDataList.add(log);
          }
        }

        // sort by received time from latest to oldest
        logDataList.sort((b, a) => a.id.compareTo(b.id));

        return [true, logDataList];
      } else {
        return [false, 'No more result.'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<List<dynamic>> getDeviceStatus({
    required User user,
    required List<int> path,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String realTimeAlarmApiPath = '/device/' + path[0].toString();

    try {
      Response response = await dio.get(
        realTimeAlarmApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List<int> nodes = path.skip(1).toList();
        List<dynamic> verifiedResilt =
            await _checkPath(user: user, path: nodes);
        if (verifiedResilt[0]) {
          return [true, ''];
        } else {
          return verifiedResilt;
        }
      } else {
        return [false, 'The device does not respond!'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<List<dynamic>> _checkPath({
    required User user,
    required List<int> path,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;

    for (int nodeId in path) {
      String childsPath = '/net/node/' + nodeId.toString();

      try {
        Response response = await dio.get(childsPath);

        //print(response.data.toString());
        var data = jsonDecode(response.data.toString());

        if (data['code'] == '200') {
          continue;
        } else {
          return [false, 'No node'];
        }
      } on DioError catch (_) {
        return [false, CustomErrMsg.connectionFailed];
      }
    }

    return [true, ''];
  }

  Future<List> exportLogs({
    required User user,
    required List<Log> logs,
  }) async {
    List<List<String>> rows = [];
    List<String> header = [];

    header
      ..add('Type')
      ..add('Account')
      ..add('Permission')
      ..add('Dept')
      ..add('User IP')
      ..add('Time received')
      ..add('Device IP')
      ..add('Group')
      ..add('Model')
      ..add('Name')
      ..add('Event')
      ..add('Description');
    rows.add(header);

    for (Log log in logs) {
      List<String> row = [];
      String logType = log.logType;
      String account = log.account;
      String permission = log.permission;
      String depatrment = log.department;
      String userIP = log.userIP;
      String startTime = log.startTime;
      String deviceIP = log.deviceIP;
      String group = log.group;
      String model = log.model;
      String name = log.name;
      String event = log.event;
      String description = log.description;
      row
        ..add(logType)
        ..add(account)
        ..add(permission)
        ..add(depatrment)
        ..add(userIP)
        ..add(startTime)
        ..add(deviceIP)
        ..add(group)
        ..add(model)
        ..add(name)
        ..add(event)
        ..add(description);

      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);
    String timeStamp =
        DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();
    String filename = 'system_log_data_$timeStamp.csv';

    if (Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$filename';
      File f = File(fullWrittenPath);
      await f.writeAsString(csv);
      return [
        true,
        'Export system log data success',
        fullWrittenPath,
      ];
    } else if (Platform.isAndroid) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$filename';
      File f = File(fullWrittenPath);
      await f.writeAsString(csv);
      return [
        true,
        'Export system log data success',
        fullWrittenPath,
      ];
    } else {
      return [
        false,
        'write file failed, export function not implement on ${Platform.operatingSystem} '
      ];
    }
  }
}

class Log {
  const Log({
    required this.id, //log id
    this.logType = '', // 'User' or 'Device'
    this.account = '',
    this.permission = '',
    this.department = '', // device group
    this.userIP = '', // device model
    this.startTime = '', // device name
    this.deviceIP = '',
    this.group = '',
    this.model = '',
    this.name = '', // model name
    this.device = '', // device name
    this.shelf = -1,
    this.slot = -1,
    this.event = '',
    this.description = '',
    this.nodeId = -1,
    this.type = -1, // node type
    this.path = const [],
  });

  final int id;
  final String logType;
  final String account;
  final String permission;
  final String department;
  final String userIP;
  final String startTime;
  final String deviceIP;
  final String group;
  final String model;
  final String name;
  final String device;
  final int shelf;
  final int slot;
  final String event;
  final String description;
  final int nodeId;
  final int type;
  final List<int> path;
}
