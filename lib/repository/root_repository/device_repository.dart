import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/view/device_monitoting_chart/monitoring_chart_style.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';
import 'package:excel/excel.dart';

class DeviceRepository {
  DeviceRepository();

  /// call api 取得 device 的所有分頁表
  Future<dynamic> createDeviceBlock({
    required User user,
    required int nodeId,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deviceStatusPath = '/device/' + nodeId.toString() + '/block';

    try {
      Response response = await dio.get(deviceStatusPath);

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List dataList = data['data'];
        List<DeviceBlock> deviceBlocks = [];

        dataList.removeWhere((element) => element['mobile'] == 0);

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

  /// call api 取得 device 的特定分頁的內容, 藉由 page id 來取得分頁內容
  Future<dynamic> getDevicePage({
    required User user,
    required int nodeId,
    required int pageId,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;

    String devicePagePath =
        '/device/' + nodeId.toString() + '/block/' + pageId.toString();

    try {
      Response response = await dio.get(devicePagePath);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List dataList = data['data'];

        if (pageId == 200) {
          // 如果是取得 dedcription 分頁的內容
          // 分別給 name 欄位 id = 9998, description 欄位 id = 9999, 來分辨兩者, 方便做 name or description 內容更新
          // 因為 api 回傳的 json 把兩者都定義同一個 id
          int autoId = 9998;

          var deviceInfo = await _getDeviceDescription(
            user: user,
            nodeId: nodeId,
          );

          if (deviceInfo.runtimeType is String) {
            return deviceInfo;
          }

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
        return 'Get Device Page Error, Error code: ${data['code']}, Msg: ${data['msg']}';
      }
    } on DioError catch (_) {
      return CustomErrMsg.connectionFailed;
    }
  }

  /// call api refresh device (機器上的)資料, 才能在 getDevicePage 時取得最新資料
  Future<void> refreshDeice({
    required User user,
    required int nodeId,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 120000; //120s
    dio.options.receiveTimeout = 120000;
    String deviceRefreshPath = '/device/' + nodeId.toString() + '/refresh';

    try {
      Response response = await dio.post(deviceRefreshPath);

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return;
      } else {
        return;
      }
    } on DioError catch (_) {
      return;
    }
  }

  /// call api 設定 device 參數
  Future<List<dynamic>> setDeviceParams({
    required User user,
    required int nodeId,
    required List<Map<String, String>> params,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
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

  /// call api 取得 device description
  Future<dynamic> _getDeviceDescription({
    required User user,
    required int nodeId,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
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

  /// call api 設定 device description
  Future<List<dynamic>> setDeviceDescription({
    required User user,
    required int nodeId,
    required String name,
    required String description,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
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

  /// call api 取得 device 歷史紀錄
  Future<List<dynamic>> getDeviceHistory({
    required User user,
    required int nodeId,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deviceStatusPath =
        '/history/search?start_time=&end_time=&shelf=&slot=&next=&trap_id=&current=0&q=&node_id=' +
            nodeId.toString();

    try {
      Response response = await dio.get(deviceStatusPath);

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

        // sort by trapId, a larger id represents a newer time
        deviceHistoryDataList.sort((a, b) => b.trapId.compareTo(a.trapId));

        return [true, deviceHistoryDataList];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 取得更多 device 歷史紀錄, 一次最多1000筆
  Future<List<dynamic>> getMoreDeviceHistory({
    required User user,
    required int nodeId,
    required int trapId,
    required String next,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deviceStatusPath =
        '/history/search?start_time=&end_time=&shelf=&slot=&next=$next&trap_id=${trapId.toString()}&current=0&q=&node_id=${nodeId.toString()}';

    try {
      Response response = await dio.get(deviceStatusPath);

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

  /// call api 取得 device line chart 用的數據
  Future<List<dynamic>> getDeviceChartData({
    required User user,
    required String startDate,
    required String endDate,
    required int deviceId,
    required String oid,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
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

          if (rawDate != null && rawValue != null) {
            double? value;
            if (rawValue == 'null') {
              value = null;
            } else {
              value = double.parse(rawValue);
            }

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

  ///取得選擇的 device 參數(oid), 的line chart 用的數據
  Future<List<dynamic>> getDeviceChartDataCollection({
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

  ///匯出單軸 line chart 數據
  Future<List<dynamic>> exportSingleAxisChartData({
    required String nodeName,
    required String parameterName,
    required List<ChartDateValuePair> chartDateValuePairs,
  }) async {
    List<String> header = [];
    Excel excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    header
      ..add('Date')
      ..add(parameterName);

    sheet.insertRowIterables(header, 0);

    for (int i = 0; i < chartDateValuePairs.length; i++) {
      ChartDateValuePair chartDateValuePair = chartDateValuePairs[i];
      String dateTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(chartDateValuePair.dateTime);

      String value = chartDateValuePair.value.toString();

      List<String> row = [];
      row
        ..add(dateTime)
        ..add(value);

      sheet.insertRowIterables(row, i + 1);
    }

    var fileBytes = excel.save();

    String timeStamp =
        DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();

    String filename = '${nodeName}_${parameterName}_$timeStamp.xlsx';

    if (Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$filename';
      File f = File(fullWrittenPath);
      await f.writeAsBytes(fileBytes!);
      return [
        true,
        'Export chart data success',
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
        'Export chart data success',
        fullWrittenPath,
      ];
    } else {
      return [
        false,
        'write file failed, export function not implement on ${Platform.operatingSystem} '
      ];
    }
  }

  ///匯出多軸 line chart 數據
  Future<List<dynamic>> exportMultipleAxisChartData({
    required String nodeName,
    required Map<String, CheckBoxValue> checkBoxValues,
    required Map<String, List<ChartDateValuePair>> chartDateValuePairs,
  }) async {
    List<String> header = [];
    Excel excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    header.add('Date');

    for (String oid in checkBoxValues.keys) {
      header.add(checkBoxValues[oid]!.name);
    }

    sheet.insertRowIterables(header, 0);

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
      sheet.insertRowIterables(row, i + 1);
    }

    var fileBytes = excel.save();

    String timeStamp =
        DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();

    String filename = '${nodeName}_$timeStamp.xlsx';

    if (Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$filename';
      File f = File(fullWrittenPath);
      await f.writeAsBytes(fileBytes!);
      return [
        true,
        'Export chart data success',
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
        'Export chart data success',
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

/// 儲存單一分頁的屬性, id, 名稱, 可否編輯
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

/// 儲存單歷史紀錄分頁的單筆歷史紀錄內容
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

/// 儲存監控圖表分頁的 line chart 的基本資料點
class ChartDateValuePair {
  const ChartDateValuePair({
    required this.dateTime,
    required this.value,
  });

  final DateTime dateTime;
  final double? value;
}
