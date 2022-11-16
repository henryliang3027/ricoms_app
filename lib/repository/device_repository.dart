import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/monitoring_chart_style.dart';
import 'package:ricoms_app/root/view/device_setting_style.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/storage_permission.dart';

class DeviceRepository {
  DeviceRepository();

  Future<dynamic> createDeviceBlock({
    required User user,
    required int nodeId,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deviceStatusPath = '/device/' + nodeId.toString() + '/block';

    try {
      Response response = await dio.get(deviceStatusPath);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List dataList = data['data'];
        List<DeviceBlock> deviceBlocks = [];

        dataList.removeWhere((element) => element['mobile'] == 0);

        // build two maps -> {pagename : id} and {pagename : editable}
        for (var item in dataList) {
          DeviceBlock deviceBlock = DeviceBlock(
            id: item['id'],
            name: item['name'],
            editable: item['edit'] == 1 ? true : false,
          );

          deviceBlocks.add(deviceBlock);
        }

        return deviceBlocks;
      } else {
        return 'The device does not respond!';
      }
    } on DioError catch (_) {
      return CustomErrMsg.connectionFailed;
    }
  }

  Future<dynamic> getDevicePage({
    required User user,
    required int nodeId,
    required int pageId,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;

    // if (_pageId[pageName] == null) {
    //   return 'Page id does not exist! please look up block and give a page id';
    // }

    String deviceThresholdPath =
        '/device/' + nodeId.toString() + '/block/' + pageId.toString();

    try {
      Response response = await dio.get(deviceThresholdPath);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        //List dataList = data['data'];
        //print(data['data'][0]);
        List dataList = data['data'];

        if (pageId == 200) {
          // description
          //make different id value because textfield ids are the same in json
          int autoId = 9998;

          var deviceInfo = await getDeviceDescription(
            user: user,
            nodeId: nodeId,
          );

          if (deviceInfo.runtimeType is String) {
            return deviceInfo;
          }

          //make different id value because textfield ids are the same in json
          for (int i = 0; i < dataList.length; i++) {
            for (int j = 0; j < dataList[i].length; j++) {
              if (dataList[i][j]['id'] != -1) {
                if (kDebugMode) {
                  print(dataList[i][j]['value'] +
                      '  ' +
                      dataList[i][j]['id'].toString());
                }
                dataList[i][j]['id'] = autoId;

                if (dataList[i][j]['style'] == 0) {
                  dataList[i][j]['value'] = deviceInfo[0]; // name
                } else if (dataList[i][j]['style'] == 98) {
                  dataList[i][j]['value'] = deviceInfo[1]; // description
                } else {} //do nothing
                autoId = autoId + 1;
              }
            }
          }
        }

        return data['data'];
      } else {
        return 'Error errno: ${data['code']}';
      }
    } on DioError catch (_) {
      return CustomErrMsg.connectionFailed;
    }
  }

  Future<List<dynamic>> setDeviceParams({
    required User user,
    required int nodeId,
    required List<Map<String, String>> params,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 120000; //120s
    dio.options.receiveTimeout = 120000;
    String deviceWritingPath = '/device/' + nodeId.toString() + '/write';

    try {
      Map<String, dynamic> requestData = {
        'uid': user.id,
        'data': params,
      };

      String jsonData = jsonEncode(requestData);

      Response response = await dio.put(deviceWritingPath, data: jsonData);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [true, 'Setup completed!'];
      } else {
        return [false, 'Setting failed.'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<dynamic> getDeviceDescription({
    required User user,
    required int nodeId,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;

    String deviceDescriptionPath = '/device/' + nodeId.toString();

    try {
      Response response = await dio.get(deviceDescriptionPath);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        //List dataList = data['data'];
        //print(data['data'][0]);
        List dataList = data['data'];
        List deviceInfo = <String>[];
        deviceInfo.add(dataList[0]['name']);
        deviceInfo.add(dataList[0]['description']);

        return deviceInfo;
      } else {
        return 'Error errno: ${data['code']}';
      }
    } on DioError catch (_) {
      return CustomErrMsg.connectionFailed;
    }
  }

  Future<List<dynamic>> setDeviceDescription({
    required User user,
    required int nodeId,
    required String name,
    required String description,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deviceDescriptionPath = '/device/' + nodeId.toString();
    try {
      Map<String, dynamic> requestData = {
        'uid': user.id,
        'name': name,
        'desc': description
      };

      String jsonData = jsonEncode(requestData);

      Response response = await dio.put(deviceDescriptionPath, data: jsonData);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [true, 'Setup completed!'];
      } else {
        return [false, 'Setup Failed! errno: ${data['code']}'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<List<dynamic>> getDeviceHistory({
    required User user,
    required int nodeId,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deviceStatusPath =
        '/history/search?start_time=&end_time=&shelf=&slot=&next=&trap_id=&current=0&q=&node_id=' +
            nodeId.toString();

    try {
      Response response = await dio.get(deviceStatusPath);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List rawdataList = data['data']['result'];
        List<DeviceHistoryData> deviceHistoryDataList = [];

        for (var element in rawdataList) {
          String? event = element['event'];
          String? alarmDuration = element['period_time'];
          String? fixedAlarmDuration;

          if (alarmDuration != null) {
            List<String> units;
            units = alarmDuration.split(' ');
            units.removeWhere((element) => element.isEmpty);

            fixedAlarmDuration = units.join(' ');
          }

          if (event != null) {
            if (event.isNotEmpty) {
              DeviceHistoryData deviceHistoryData = DeviceHistoryData(
                trapId: element['id'],
                event: event,
                severity: element['status'],
                timeReceived: element['start_time'],
                clearTime: element['clear_time'] ?? '',
                alarmDuration: fixedAlarmDuration ?? '',
              );
              deviceHistoryDataList.add(deviceHistoryData);
            }
          }
        }
        deviceHistoryDataList
            .sort((b, a) => a.timeReceived.compareTo(b.timeReceived));

        return [true, deviceHistoryDataList];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<List<dynamic>> getMoreDeviceHistory({
    required User user,
    required int nodeId,
    required int trapId,
    required String next,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deviceStatusPath =
        '/history/search?start_time=&end_time=&shelf=&slot=&next=$next&trap_id=${trapId.toString()}&current=0&q=&node_id=${nodeId.toString()}';

    try {
      Response response = await dio.get(deviceStatusPath);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List rawdataList = data['data']['result'];
        List<DeviceHistoryData> deviceHistoryDataList = [];

        for (var element in rawdataList) {
          String? event = element['event'];
          String? alarmDuration = element['period_time'];
          String? fixedAlarmDuration;

          if (alarmDuration != null) {
            List<String> units;
            units = alarmDuration.split(' ');
            units.removeWhere((element) => element.isEmpty);

            fixedAlarmDuration = units.join(' ');
          }

          if (event != null) {
            if (event.isNotEmpty) {
              DeviceHistoryData deviceHistoryData = DeviceHistoryData(
                trapId: element['id'],
                event: event,
                severity: element['status'],
                timeReceived: element['start_time'],
                clearTime: element['clear_time'] ?? '',
                alarmDuration: fixedAlarmDuration ?? '',
              );
              deviceHistoryDataList.add(deviceHistoryData);
            }
          }
        }
        deviceHistoryDataList
            .sort((b, a) => a.timeReceived.compareTo(b.timeReceived));

        return [true, deviceHistoryDataList];
      } else {
        return [false, 'No more result.'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<bool> checkDeviceChartDataAvailable({
    required User user,
    required String startDate,
    required String endDate,
    required int deviceId,
    required List<String> oids,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;

    int emptyCount = 0;

    for (String oid in oids) {
      String deviceChartDataPath =
          '/device/$deviceId/chart?start_time=$startDate&end_time=$endDate&oid=$oid';

      try {
        Response response = await dio.get(deviceChartDataPath);

        var data = jsonDecode(response.data.toString());

        if (data['code'] != '200') {
          emptyCount += 1;
        }
      } on DioError catch (_) {
        return false;
      }
    }

    if (emptyCount == oids.length) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<dynamic>> getDeviceChartData({
    required User user,
    required String startDate,
    required String endDate,
    required int deviceId,
    required String oid,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deviceChartDataPath =
        '/device/$deviceId/chart?start_time=$startDate&end_time=$endDate&oid=$oid';

    try {
      Response response = await dio.get(deviceChartDataPath);

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List rawdataList = data['data']['data'][0]['data'];
        List<ChartDateValuePair> chartDateValuePairs = [];

        for (var element in rawdataList) {
          String? rawDate = element['time'];
          String? rawValue = element['value'];

          if (rawDate != null &&
              rawValue != null &&
              rawDate != 'null' &&
              rawValue != 'null') {
            double value = double.parse(rawValue);
            String date = rawDate;
            chartDateValuePairs.add(ChartDateValuePair(
              dateTime: DateTime.parse(date),
              value: value,
            ));
          }
        }

        return [true, chartDateValuePairs];
      } else {
        return [false, 'No chart data.'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<List<dynamic>> getMultipleDeviceChartData({
    required User user,
    required String startDate,
    required String endDate,
    required int deviceId,
    required List<String> oids,
  }) async {
    Map<String, List<ChartDateValuePair>> chartDateValues = {};

    for (String oid in oids) {
      List<dynamic> result = await getDeviceChartData(
        user: user,
        startDate: startDate,
        endDate: endDate,
        deviceId: deviceId,
        oid: oid,
      );

      if (result[0]) {
        List<ChartDateValuePair> chartDateValuePairs = result[1];
        chartDateValues[oid] = chartDateValuePairs;
      } else {
        return [false, {}];
      }
    }

    return [true, chartDateValues];
  }

  Future<List<dynamic>> exportSingleAxisChartData({
    required String nodeName,
    required String parameterName,
    required List<ChartDateValuePair> chartDateValuePairs,
  }) async {
    List<List<String>> dataList = [];

    List<String> header = [];

    header
      ..add('Date')
      ..add(parameterName);

    dataList.add(header);

    print('start add');
    for (ChartDateValuePair chartDateValuePair in chartDateValuePairs) {
      String dateTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(chartDateValuePair.dateTime);

      String value = chartDateValuePair.value.toString();

      List<String> row = [];
      row
        ..add(dateTime)
        ..add(value);

      dataList.add(row);
    }
    print('end add');

    print('start convert');
    String csv = const ListToCsvConverter().convert(dataList);
    print('end convert');

    String timeStamp =
        DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();

    String filename = '${nodeName}_${parameterName}_$timeStamp.csv';

    if (Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$filename';
      File f = File(fullWrittenPath);
      f.writeAsString(csv);
      return [
        true,
        'Export chart data success',
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
          print('start write');
          await file.writeAsString(csv);
          print('end write');
          return [
            true,
            'Export chart data success',
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

  Future<List<dynamic>> exportMultipleAxisChartData({
    required String nodeName,
    required Map<String, CheckBoxValue> checkBoxValues,
    required Map<String, List<ChartDateValuePair>> chartDateValuePairs,
  }) async {
    List<List<String>> dataList = [];

    List<String> header = [];

    header.add('Date');

    for (String oid in checkBoxValues.keys) {
      header.add(checkBoxValues[oid]!.name);
    }

    dataList.add(header);

    int length = chartDateValuePairs.values.toList()[0].length;
    String dateTimeKey = checkBoxValues.keys.toList()[0];

    // loop datetime
    for (int i = 0; i < length; i++) {
      List<String> row = [];
      String dateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(chartDateValuePairs[dateTimeKey]![i].dateTime);
      row.add(dateTime);

      // loop each oid
      for (String oid in checkBoxValues.keys) {
        String value = chartDateValuePairs[oid]![i].value.toString();

        row.add(value);
      }
      dataList.add(row);
    }

    String csv = const ListToCsvConverter().convert(dataList);

    String timeStamp =
        DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();

    String filename = '${nodeName}_$timeStamp.csv';

    if (Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$filename';
      File f = File(fullWrittenPath);
      f.writeAsString(csv);
      return [
        true,
        'Export chart data success',
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
            'Export chart data success',
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

class DeviceBlock {
  const DeviceBlock({
    required this.id,
    required this.name,
    required this.editable,
  });

  final int id;
  final String name;
  final bool editable;
}

class DeviceHistoryData {
  const DeviceHistoryData({
    required this.trapId,
    required this.event,
    this.severity = -1,
    this.timeReceived = '',
    this.clearTime = '',
    this.alarmDuration = '',
  });

  final int severity;
  final String event;
  final int trapId;
  final String timeReceived;
  final String clearTime;
  final String alarmDuration;
}

class ChartDateValuePair {
  const ChartDateValuePair({
    required this.dateTime,
    required this.value,
  });

  final DateTime dateTime;
  final double value;
}
