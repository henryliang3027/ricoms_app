import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

class SystemLogRepository {
  SystemLogRepository();

  /// call api 依據條件取得系統紀錄
  Future<List<dynamic>> getLogByFilter({
    required User user,
    String startDate = '',
    String endDate = '',
    String next = '',
    String startId = '',
    String queryData = '',
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String systemLogApiPath =
        '/records/search?uid=${user.id}&start_time=$startDate&end_time=$endDate&next=$next&start_id=$startId&q=$queryData';

    if (user.id == 'demo') {
      return [true, <Log>[]];
    }

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

  /// call api 依據條件取得更多系統紀錄, 一次最多獲取 1000 筆, next = top：上一千筆 next = button：下一千筆
  Future<List<dynamic>> getMoreLogsByFilter({
    required User user,
    String startDate = '',
    String endDate = '',
    String next = '',
    String startId = '',
    String queryData = '',
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
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

  /// 匯出目前條件下的系統記錄
  Future<List> exportLogs({
    required User user,
    required List<Log> logs,
  }) async {
    List<String> header = [];
    Excel excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

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

    sheet.insertRowIterables(header, 0);

    for (int i = 0; i < logs.length; i++) {
      Log log = logs[i];
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

      sheet.insertRowIterables(row, i + 1);
    }

    var fileBytes = excel.save();
    String timeStamp =
        DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();
    String filename = 'system_log_data_$timeStamp.xlsx';

    if (Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$filename';
      File f = File(fullWrittenPath);
      await f.writeAsBytes(fileBytes!);
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
      await f.writeAsBytes(fileBytes!);
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

/// 儲存個別的系統紀錄項目的資料結構
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
