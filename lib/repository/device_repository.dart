import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ricoms_app/repository/user.dart';

class DeviceRepository {
  DeviceRepository();

  //final User user;
  String _nodeId = '';

  final Map<String, String> _pageId = <String, String>{};
  final Map<String, bool> _pageEditable = <String, bool>{};

  set deviceNodeId(String nodeId) {
    _nodeId = nodeId;
  }

  bool isEditable(String pageName) {
    if (_pageEditable[pageName] == null) {
      return false; // page not exist
    } else {
      return _pageEditable[pageName]!;
    }
  }

  Future<dynamic> createDeviceBlock({required User user}) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deviceStatusPath = '/device/' + _nodeId + '/block';

    try {
      //404
      Response response = await dio.get(deviceStatusPath);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List dataList = data['data'];

        dataList.removeWhere((element) => element['mobile'] == 0);

        // build two maps -> {pagename : id} and {pagename : editable}
        for (var item in dataList) {
          _pageId[item['name']] = item['id'].toString();
          _pageEditable[item['name']] = item['edit'] == 1 ? true : false;
        }

        return dataList;
      } else {
        return '${data['code']}: The device does not respond.';
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
          return 'Server No Response';
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          if (kDebugMode) {
            print(e.requestOptions);
            print(e.message);
          }

          //throw Exception(e.message);
          return e.message;
        }
      } else {
        //throw Exception(e.toString());
        return e.toString();
      }
    }
  }

  Future<dynamic> getDevicePage(
      {required User user, required String pageName}) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;

    if (_pageId[pageName] == null) {
      return 'Page id does not exist! please look up block and give a page id';
    }

    String deviceThresholdPath =
        '/device/' + _nodeId + '/block/' + _pageId[pageName]!;

    try {
      //404
      Response response = await dio.get(deviceThresholdPath);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        //List dataList = data['data'];
        //print(data['data'][0]);
        List dataList = data['data'];

        if (pageName == 'Description') {
          //make different id value because textfield ids are the same in json
          int autoId = 9998;

          var deviceInfo = await getDeviceDescription(user: user);

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
          return 'Server No Response';
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          if (kDebugMode) {
            print(e.requestOptions);
            print(e.message);
          }

          //throw Exception(e.message);
          return e.message;
        }
      } else {
        //throw Exception(e.toString());
        return e.toString();
      }
    }
  }

  Future<List<dynamic>> setDeviceParams(
      {required User user, required List<Map<String, String>> params}) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deviceWritingPath = '/device/' + _nodeId + '/write';

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
        return [false, 'Setup Failed! errno: ${data['code']}'];
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

  Future<dynamic> getDeviceDescription({required User user}) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;

    String deviceDescriptionPath = '/device/' + _nodeId;

    try {
      //404
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
          return 'Server No Response';
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          if (kDebugMode) {
            print(e.requestOptions);
            print(e.message);
          }

          //throw Exception(e.message);
          return e.message;
        }
      } else {
        //throw Exception(e.toString());
        return e.toString();
      }
    }
  }

  Future<List<dynamic>> setDeviceDescription({
    required User user,
    required String name,
    required String description,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deviceDescriptionPath = '/device/' + _nodeId;
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

  Future<dynamic> getDeviceHistory({required User user}) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deviceStatusPath =
        '/history/search?start_time=&end_time=&shelf=&slot=&next=&trap_id=&current=0&q=&node_id=' +
            _nodeId;

    try {
      //404
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
        return deviceHistoryDataList;
      } else {
        return 'There are no records to show';
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
          return 'Server No Response';
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          if (kDebugMode) {
            print(e.requestOptions);
            print(e.message);
          }
          //throw Exception(e.message);
          return e.message;
        }
      } else {
        //throw Exception(e.toString());
        return e.toString();
      }
    }
  }
}

class DeviceHistoryData {
  const DeviceHistoryData({
    required this.event,
    this.severity = -1,
    this.timeReceived = '',
    this.clearTime = '',
    this.alarmDuration = '',
  });

  final int severity;
  final String event;
  final String timeReceived;
  final String clearTime;
  final String alarmDuration;
}
