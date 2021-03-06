import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/utils/display_style.dart';

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
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e is DioError) {
        if (e.response != null) {
          print('-------------------');
          print(e.response!.data);
          print('-------------------');
          print(e.response!.headers);
          print('-------------------');
          print(e.response!.requestOptions);
          print('-------------------');

          //throw Exception('Server No Response');
          return [false, 'Server No Response'];
        } else {
          // Something happened in setting up or sending the request that triggered an Error

          print('-------------------');
          print(e.requestOptions);
          print('-------------------');
          print(e.message);
          print('-------------------');

          //throw Exception(e.message);
          return [false, e.message];
        }
      } else {
        //throw Exception(e.toString());
        return [false, e.toString()];
      }
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
    required List<int> path,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String realTimeAlarmApiPath = '/device/' + path[0].toString();

    try {
      //404
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
        //404
        Response response = await dio.get(childsPath);

        //print(response.data.toString());
        var data = jsonDecode(response.data.toString());

        if (data['code'] == '200') {
          continue;
        } else {
          return [false, 'No node'];
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
        'Export root data success',
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
            'Export root data success',
            fullWrittenPath,
          ];
        }
      } else {
        openAppSettings();
        return [false, 'Please allow permission before you export your data'];
      }
    } else {
      return [
        false,
        'write file failed, export function not implement on ${Platform.operatingSystem} '
      ];
    }
  }

  Future<bool> requestPermission() async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    int sdkInt = androidInfo.version.sdkInt;
    //print("sdk version " + sdkInt.toString());
    if (sdkInt <= 28) {
      // Android 9 or older
      PermissionStatus storagePermission = await Permission.storage.request();
      if (storagePermission.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      //sdk 29, 30, (31-32), 33 Android 10, 11, 12, 13
      PermissionStatus storagePermission = await Permission.storage.request();
      PermissionStatus accessMediaLocationPermission =
          await Permission.accessMediaLocation.request();
      PermissionStatus manageExternalStoragePermission =
          await Permission.manageExternalStorage.request();
      if (storagePermission.isGranted &&
          accessMediaLocationPermission.isGranted &&
          manageExternalStoragePermission.isGranted) {
        return true;
      } else {
        return false;
      }
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
