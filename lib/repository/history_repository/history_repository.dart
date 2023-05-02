import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/display_style.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

class HistoryRepository {
  HistoryRepository();

  /// call api 依據條件取得歷史紀錄清單
  Future<List<dynamic>> getHistoryByFilter({
    required User user,
    String startDate = '',
    String endDate = '',
    String unsolvedOnly = '0',
    String shelf = '',
    String slot = '',
    String next = '',
    String nodeId = '',
    String trapId = '',
    String queryData = '',
  }) async {
    if (user.id == 'demo') {
      return [true, <Record>[]];
    }

    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;

    // current = 1 : show open issue only,
    // current = 0 : show all alarms with given datetime
    String historyApiPath =
        '/history/search?start_time=$startDate&end_time=$endDate&node_id=$nodeId&shelf=$shelf&slot=$slot&next=$next&trap_id=$trapId&current=$unsolvedOnly&q=$queryData';

    try {
      Response response = await dio.get(
        historyApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List rawDataList = data['data']['result'];
        List<Record> recordDataList = [];

        for (var element in rawDataList) {
          if (element['node_id'] != null && element['id'] != null) {
            String rawPath = element['path'] ?? '';
            List<String> nodeIdList =
                rawPath.split(',').where((raw) => raw.isNotEmpty).toList();
            List<int> path = [];
            for (var nodeId in nodeIdList) {
              path.add(int.parse(nodeId));
            }

            String? alarmDuration = element['period_time'];
            String? fixedAlarmDuration;

            if (alarmDuration != null) {
              List<String> units;
              units = alarmDuration.split(' ');
              units.removeWhere((element) => element.isEmpty);

              fixedAlarmDuration = units.join(' ');
            }

            Record record = Record(
              id: element['node_id'],
              trapId: element['id'],
              event: element['event'] ?? '',
              value: element['value'] ?? '',
              group: element['group'] ?? '',
              model: element['model'] ?? '',
              name: element['name'] ?? '',
              receivedTime: element['start_time'] ?? '',
              clearTime: element['clear_time'] ?? '',
              alarmDuration: fixedAlarmDuration ?? '',
              ip: element['ip'] ?? '',
              severity: element['status'] ?? -1,
              type: int.parse(element['type'] ?? -1),
              shelf: element['shelf'] ?? -1,
              slot: element['slot'] ?? -1,
              path: path,
            );

            recordDataList.add(record);
          }
        }

        // sort by received time from latest to oldest
        recordDataList.sort((b, a) => a.trapId.compareTo(b.trapId));

        return [true, recordDataList];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 依據條件取得更多歷史紀錄清單, 一次最多獲取 1000 筆, next = top：上一千筆(越舊) next = button：下一千筆(越新)
  Future<List<dynamic>> getMoreHistoryByFilter({
    required User user,
    String startDate = '',
    String endDate = '',
    String unsolvedOnly = '0',
    String shelf = '',
    String slot = '',
    String next = '',
    String nodeId = '',
    String trapId = '',
    String queryData = '',
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String historyApiPath =
        '/history/search?start_time=$startDate&end_time=$endDate&node_id=$nodeId&shelf=$shelf&slot=$slot&next=$next&trap_id=$trapId&current=$unsolvedOnly&q=$queryData';

    try {
      Response response = await dio.get(
        historyApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List rawDataList = data['data']['result'];
        List<Record> recordDataList = [];

        for (var element in rawDataList) {
          if (element['node_id'] != null && element['id'] != null) {
            String rawPath = element['path'] ?? '';
            List<String> nodeIdList =
                rawPath.split(',').where((raw) => raw.isNotEmpty).toList();
            List<int> path = [];
            for (var nodeId in nodeIdList) {
              path.add(int.parse(nodeId));
            }

            String? alarmDuration = element['period_time'];
            String? fixedAlarmDuration;

            if (alarmDuration != null) {
              List<String> units;
              units = alarmDuration.split(' ');
              units.removeWhere((element) => element.isEmpty);

              fixedAlarmDuration = units.join(' ');
            }

            Record record = Record(
              id: element['node_id'],
              trapId: element['id'],
              event: element['event'] ?? '',
              value: element['value'] ?? '',
              group: element['group'] ?? '',
              model: element['model'] ?? '',
              name: element['name'] ?? '',
              receivedTime: element['start_time'] ?? '',
              clearTime: element['clear_time'] ?? '',
              alarmDuration: fixedAlarmDuration ?? '',
              ip: element['ip'] ?? '',
              severity: element['status'] ?? -1,
              type: int.parse(element['type'] ?? -1),
              shelf: element['shelf'] ?? -1,
              slot: element['slot'] ?? -1,
              path: path,
            );

            recordDataList.add(record);
          }
        }
        Stopwatch stopwatch = Stopwatch()..start();
        // sort by received time from latest to oldest
        recordDataList.sort((b, a) => a.trapId.compareTo(b.trapId));

        print('sort time ${stopwatch.elapsed.inSeconds}');

        return [true, recordDataList];
      } else {
        return [false, 'No more result.'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// 匯出基於目前條件下的歷史紀錄清單
  Future<List> exportHistory({
    required User user,
    required List<Record> records,
  }) async {
    List<String> header = [];
    Excel excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    header
      ..add('Severity')
      ..add('IP')
      ..add('Group')
      ..add('Model')
      ..add('Name')
      ..add('Event')
      ..add('Value')
      ..add('Time Received')
      ..add('Clear Time')
      ..add('Alarm Duration');

    sheet.insertRowIterables(header, 0);

    for (int i = 0; i < records.length; i++) {
      Record record = records[i];
      List<String> row = [];
      String severity = CustomStyle.severityName[record.severity] ?? '';
      String ip = record.ip;
      String group = record.group;
      String model = record.model;
      String name = DisplayStyle.getDeviceDisplayName(record);
      String event = record.event;
      String value = record.value;
      String timeReceived = record.receivedTime;
      String clearTime = record.clearTime;
      String alarmDuration = record.alarmDuration;
      row
        ..add(severity)
        ..add(ip)
        ..add(group)
        ..add(model)
        ..add(name)
        ..add(event)
        ..add(value)
        ..add(timeReceived)
        ..add(clearTime)
        ..add(alarmDuration);

      sheet.insertRowIterables(row, i + 1);
    }

    var fileBytes = excel.save();

    String timeStamp =
        DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();
    String filename = 'history_data_$timeStamp.xlsx';

    if (Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$filename';
      File f = File(fullWrittenPath);
      await f.writeAsBytes(fileBytes!);
      return [
        true,
        'Export history data success',
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
        'Export history data success',
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

/// 儲存個別的歷史紀錄項目的資料結構
class Record {
  const Record({
    required this.id, //device id
    this.trapId = -1,
    this.event = '',
    this.value = '',
    this.group = '', // device group
    this.model = '', // device model
    this.name = '', // device name
    this.receivedTime = '',
    this.clearTime = '',
    this.alarmDuration = '',
    this.ip = '', //device ip
    this.severity = -1,
    this.type = -1,
    this.shelf = -1,
    this.slot = -1,
    this.path = const [],
  });

  final int id;
  final int trapId;
  final String event;
  final String value;
  final String group;
  final String model;
  final String name;
  final String receivedTime;
  final String clearTime;
  final String alarmDuration;
  final String ip;
  final int severity;
  final int type;
  final int shelf;
  final int slot;
  final List<int> path;
}
