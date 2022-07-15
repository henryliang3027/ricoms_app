import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_api.dart';

class BookmarksRepository {
  BookmarksRepository();

  final Dio _dio = Dio();

  Future<List<dynamic>> getBookmarks({
    required User user,
  }) async {
    _dio.options.baseUrl = 'http://' + user.ip + '/aci/api/';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;

    List<Device> devices = [];
    UserApi userApi = UserApi();

    List<int> bookmarks = userApi.getBookmarksByUserId(user.id);

    for (var bookmark in bookmarks) {
      String deviceStatusApiPath = '/device/$bookmark';

      try {
        //404
        Response response = await _dio.get(
          deviceStatusApiPath,
        );

        var data = jsonDecode(response.data.toString());

        if (data['code'] == '200') {
          var element = data['data'][0];

          String rawPath = element['path'];
          List<String> nodeIdList =
              rawPath.split(',').where((raw) => raw.isNotEmpty).toList();
          List<int> path = [];
          for (var nodeId in nodeIdList) {
            path.add(int.parse(nodeId));
          }

          if (element['device_id'] != null) {
            Device device = Device(
              id: element['device_id'],
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
          return [false, 'Error errno: ${data['code']} msg: ${data['msg']}'];
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
    return [true, devices];
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