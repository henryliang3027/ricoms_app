import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_api.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';

class BookmarksRepository {
  BookmarksRepository();

  final Dio _dio = Dio();
  final UserApi userApi = UserApi();

  List<DeviceMeta> getDeviceMetas({
    required User user,
  }) {
    return userApi.getBookmarksByUserId(user.id);
  }

  Future<List<dynamic>> getBookmarks({
    required User user,
    required List<DeviceMeta> deviceMetas,
    int startIndex = 0,
  }) async {
    _dio.options.baseUrl = 'http://' + user.ip + '/aci/api/';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;

    List<Device> devices = [];
    int endIndex = startIndex + 10 < deviceMetas.length
        ? startIndex + 10
        : deviceMetas.length;

    // List<DeviceMeta> bookmarks = userApi.getBookmarksByUserId(user.id);

    if (deviceMetas.isNotEmpty) {
      for (int i = startIndex; i < endIndex; i++) {
        DeviceMeta deviceMeta = deviceMetas[i];
        String deviceStatusApiPath = '/device/${deviceMeta.id.toString()}';

        try {
          Response response = await _dio.get(
            deviceStatusApiPath,
          );

          var data = jsonDecode(response.data.toString());

          if (data['code'] == '200' || data['code'] == '404') {
            var element = data['data'][0];

            String rawPath = element['path'] ?? '';
            List<String> nodeIdList =
                rawPath.split(',').where((raw) => raw.isNotEmpty).toList();
            List<int> path = [];
            for (var nodeId in nodeIdList) {
              path.add(int.parse(nodeId));
            }

            if (element['device_id'] != null) {
              Device device = Device(
                id: deviceMeta.id,
                name: element['name'],
                type: element['type'],
                ip: element['ip'],
                shelf: element['shelf'],
                slot: element['slot'],
                read: element['read'],
                write: element['write'],
                description: element['description'],
                location: element['location'],
                path: path,
                moduleId: element['module_id'],
                module: element['module'],
                series: element['series'],
                status: element['status'],
              );

              devices.add(device);
            }
          } else {
            Device device = Device(
              id: deviceMeta.id,
              name: deviceMeta.name,
              type: deviceMeta.type,
              ip: deviceMeta.ip,
              shelf: deviceMeta.shelf,
              slot: deviceMeta.slot,
              path: deviceMeta.path,
              status: 0,
            );

            devices.add(device);
          }
        } on DioError catch (_) {
          return [false, CustomErrMsg.connectionFailed];
        }
      }
      return [true, devices];
    } else {
      return [false, 'There are no records to show'];
    }
  }

  Future<List<dynamic>> deleteDevices({
    required User user,
    required List<Device> devices,
  }) async {
    UserApi userApi = UserApi();

    List<int> nodeIds = [];

    for (Device device in devices) {
      nodeIds.add(device.id);
    }

    bool isSuccess =
        await userApi.deleteMultipleBookmarksByUserId(user.id, nodeIds);

    if (isSuccess) {
      return [true, ''];
    } else {
      return [false, 'Your account id does not exist.'];
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
}

class Device {
  const Device({
    required this.id,
    this.name = '',
    this.type = -1,
    this.ip = '',
    this.shelf = -1,
    this.slot = -1,
    this.read = '',
    this.write = '',
    this.description = '',
    this.location = '',
    this.path = const [],
    this.moduleId = -1,
    this.module = '',
    this.series = '',
    this.status = -1,
  });

  final int id;
  final String name;
  final int type;
  final String ip;
  final int shelf;
  final int slot;
  final String read;
  final String write;
  final String description;
  final String location;
  final List<int> path;
  final int moduleId;
  final String module;
  final String series;
  final int status;
}



            // "name": "A8KQRR-AGC-HG",
            // "type": 5,
            // "device_id": 681,
            // "ip": "192.168.29.202",
            // "shelf": 1,
            // "slot": 1,
            // "read": "public",
            // "write": "private",
            // "description": "1234",
            // "location": "",
            // "parent_id": 1001,
            // "path": ",1004,1001,1000,779,",
            // "device_main_id": 678,
            // "module_id": 4,
            // "module": "A8KQRR-AGC-HG",
            // "series": "A8K3U",
            // "status": 3