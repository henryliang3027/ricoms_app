import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/display_style.dart';
import 'package:ricoms_app/utils/storage_permission.dart';

class HistoryRepository {
  HistoryRepository();

  //final Dio _dio = Dio();

  //current: 1 = show open issue only, 0 = show all alarms with given datetime
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
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
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
            String rawPath = element['path'];
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
    } on DioError catch (e) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

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
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
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
            String rawPath = element['path'];
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
        return [false, 'No more result.'];
      }
    } on DioError catch (e) {
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
    } on DioError catch (e) {
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
      } on DioError catch (e) {
        return [false, CustomErrMsg.connectionFailed];
      }
    }

    return [true, ''];
  }

  Future<List> exportHistory({
    required User user,
    required List<Record> records,
  }) async {
    List<List<String>> rows = [];
    List<String> header = [];

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
    rows.add(header);

    for (Record record in records) {
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

      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);
    String timeStamp =
        DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();
    String filename = 'history_data_$timeStamp.csv';

    if (Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$filename';
      File f = File(fullWrittenPath);
      f.writeAsString(csv);
      return [
        true,
        'Export history data success',
        fullWrittenPath,
      ];
    } else if (Platform.isAndroid) {
      bool isPermit = await requestPermission();
      if (isPermit) {
        Directory? externalStorageDirectory =
            await getExternalStorageDirectory();
        if (externalStorageDirectory == null) {
          return [false, 'No Storage found'];
        } else {
          String externalStoragePath = externalStorageDirectory.path;
          List<String> externalStoragePathList = externalStoragePath.split('/');
          int indexOfAndroidDir = externalStoragePathList.indexOf('Android');
          String externalRootPath =
              externalStoragePathList.sublist(0, indexOfAndroidDir).join('/');
          String externalAppFolderPath = externalRootPath + '/RICOMS';

          //Create Directory (if not exist)
          Directory externalAppDirectory = Directory(externalAppFolderPath);
          if (!externalAppDirectory.existsSync()) {
            //Creating Directory
            try {
              await externalAppDirectory.create(recursive: true);
            } catch (e) {
              return [false, e.toString()];
            }
            //Directory Created
          } else {
            //Directory Already Existed
          }
          String fullWrittenPath = '$externalAppFolderPath/$filename';
          File file = File(fullWrittenPath);
          file.writeAsString(csv);
          return [
            true,
            'Export history data success',
            fullWrittenPath,
          ];
        }
      } else {
        openAppSettings();
        return [false, 'Please allow permission before you export your data.'];
      }
    } else {
      return [
        false,
        'write file failed, export function not implement on ${Platform.operatingSystem} '
      ];
    }
  }
}

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
