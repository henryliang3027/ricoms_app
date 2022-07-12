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

class HistoryRepository {
  HistoryRepository();

  final Dio _dio = Dio();

//current: 1 = show open issue only, 0 = show all alarms with given datetime
  Future<List<dynamic>> getHistoryByFilter({
    required User user,
    String startTime = '2022/07/11',
    String endTime = '2022/07/11',
    String current = '0',
    String shelf = '',
    String slot = '',
    String next = '',
    String nodeId = '',
    String trapId = '',
    String queryData = '',
  }) async {
    _dio.options.baseUrl = 'http://' + user.ip + '/aci/api/';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;
    String historyApiPath =
        '/history/search?start_time=$startTime&end_time=$endTime&node_id=$nodeId&shelf=$shelf&slot=$slot&next=$next&trap_id=$trapId&current=$current&q="$queryData"';

    try {
      Response response = await _dio.get(
        historyApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List rawDataList = data['data']['result'];
        List<Record> recordDataList = [];

        for (var element in rawDataList) {
          if (element['node_id'] != null) {
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
        recordDataList.sort((b, a) => a.receivedTime.compareTo(b.receivedTime));

        return [true, recordDataList];
      } else {
        return [false, 'There are no records to show'];
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

  Future<List<dynamic>> exportHistory({
    required User user,
    String startTime = '',
    String endTime = '',
    String shelf = '',
    String slot = '',
    String next = '',
    String nodeId = '',
    String trapId = '',
    String current = '0',
    String queryData = '',
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;

    String nodeExportApiPath =
        '/history/export?start_time=$startTime&end_time=$endTime&shelf=$shelf&slot=$slot&next=$next&trap_id=$trapId&current=$current&q="$queryData"&node_id=$nodeId&uid=${user.id}';

    try {
      //404
      Response response = await dio.get(
        nodeExportApiPath,
        queryParameters: {'uid': user.id},
      );

      String rawData = response.data;

      rawData = rawData.replaceAll('\"=\"', '');
      rawData = rawData.replaceAll('\"', '');

      List<String> rawDataList = rawData.split('\n');
      List<List<String>> dataList = [];

      for (var element in rawDataList) {
        if (element.isNotEmpty) {
          List<String> line = element.split(',');
          dataList.add(line);
        }
      }

      String csv = const ListToCsvConverter().convert(dataList);

      String timeStamp =
          DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();

      String filename = 'history_data_$timeStamp.csv';

      if (Platform.isIOS) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        File f = File('$appDocPath/$filename');
        f.writeAsString(csv);
        return [true, 'Export root data success'];
      } else if (Platform.isAndroid) {
        bool isPermit = await requestPermission();
        if (isPermit) {
          Directory? externalStorageDirectory =
              await getExternalStorageDirectory();
          if (externalStorageDirectory == null) {
            return [false, 'No Storage found'];
          } else {
            String externalStoragePath = externalStorageDirectory.path;
            List<String> externalStoragePathList =
                externalStoragePath.split('/');
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

            File f = File('$externalAppFolderPath/$filename');
            f.writeAsString(csv);
            return [true, 'Export root data success'];
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
  final List path;
}
