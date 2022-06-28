import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ricoms_app/repository/user.dart';

class RootRepository {
  RootRepository(this.user);

  final User user;

  Future<dynamic> getChilds(Node parent) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String childsPath = '/net/node/' + parent.id.toString() + '/childs';

    try {
      //404
      Response response = await dio.get(childsPath);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List<Node> childs = [];
        List dataList = data['data'];

        for (var element in dataList) {
          if (element['id'] == null) continue;

          Node node = Node(
            id: element['id'],
            name: element['name'],
            type: element['type'],
            teg: element['teg'],
            path: element['path'],
            shelf: element['shelf'],
            slot: element['slot'],
            status: element['status'],
            sort: element['sort'],
          );
          childs.add(node);
        }
        return childs;
      } else {
        print('ERROR');
        return 'Error errno: ${data['code']}';
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e is DioError) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
          //throw Exception('Server No Response');
          return 'Server No Response';
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
          //throw Exception(e.message);
          return e.message;
        }
      } else {
        //throw Exception(e.toString());
        return Future.error(e.toString());
      }
    }
  }

  Future<dynamic> getNodeInfo(int nodeId) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String childsPath = '/net/node/' + nodeId.toString();

    try {
      //404
      Response response = await dio.get(childsPath);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        var rawData = data['data'][0];

        Info info = Info(
          deviceID: rawData['device_id'] ?? -1,
          ip: rawData['ip'] ?? '',
          read: rawData['read'] ?? '',
          write: rawData['write'] ?? '',
          description: rawData['description'] ?? '',
          location: rawData['location'] ?? '',
          parentID: rawData['parent_id'] ?? -1,
          path: rawData['path'] ?? '',
          deviceMainID: rawData['device_main_id'] ?? -1,
          moduleID: rawData['module_id'] ?? -1,
          module: rawData['module'] ?? '',
          series: rawData['series'] ?? '',
        );

        return info;
      } else {
        print('ERROR');
        return 'Error errno: ${data['code']}';
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e is DioError) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
          //throw Exception('Server No Response');
          return 'Server No Response';
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
          //throw Exception(e.message);
          return e.message;
        }
      } else {
        //throw Exception(e.toString());
        return Future.error(e.toString());
      }
    }
  }

  Future<List<dynamic>> createNode({
    required int parentId,
    required int type,
    required String name,
    required String description,
    String? deviceIP,
    String? read,
    String? write,
    String? location,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String createNodePath = '/net/node/' + parentId.toString() + '/childs/new';

    try {
      //404

      Response response;

      if (type == 1) {
        // group
        Map<String, dynamic> requestData = {
          'type': type.toString(),
          'name': name,
          'desc': description,
          'uid': user.id,
          'ip': deviceIP ?? '',
          'read': read ?? '',
          'write': write ?? '',
          'location': location ?? '',
        };

        response = await dio.post(createNodePath, data: requestData);
      } else if (type == 2) {
        // device
        Map<String, dynamic> requestData = {
          'type': type.toString(),
          'name': name,
          'desc': description,
          'uid': user.id,
          'ip': deviceIP,
          'read': read,
          'write': write,
          'location': location,
        };
        response = await dio.post(createNodePath, data: requestData);
      } else {
        return [false, 'The given type is invalid. 1:Group / 2:Device'];
      }

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [true, 'create node success'];
      } else if (data['code'] == '204') {
        return [true, 'The device is unconnedted and unsupported.'];
      } else {
        print('ERROR');
        return [false, data['msg']];
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e is DioError) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
          //throw Exception('Server No Response');
          return [false, e.response!.statusMessage];
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
          //throw Exception(e.message);
          return [false, e.message];
        }
      } else {
        //throw Exception(e.toString());
        return [false, e.toString()];
      }
    }
  }

  Future<List<dynamic>> updateNode({
    required Node currentNode,
    required String name,
    required String description,
    String? deviceIP,
    String? read,
    String? write,
    String? location,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String updateNodePath = '/net/node/' + currentNode.id.toString();

    try {
      //404

      Response response;

      if (currentNode.type == 1) {
        // group
        Map<String, dynamic> requestData = {
          'name': name,
          'desc': description,
          'uid': user.id,
          'type': 1,
        };

        response = await dio.put(updateNodePath, data: requestData);
      } else if (currentNode.type == 2 || currentNode.type == 3) {
        // device
        Map<String, dynamic> requestData = {
          'name': name,
          'desc': description,
          'uid': user.id,
          'ip': deviceIP,
          'read': read,
          'write': write,
          'series': currentNode.info!.series,
          'type': 2,
          'location': location,
        };
        response = await dio.put(updateNodePath, data: requestData);
      } else {
        return [false, 'The given type is invalid. 1:Group / 2:Device'];
      }

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [true, 'create node success'];
      } else if (data['code'] == '204') {
        return [true, 'The device is unconnedted and unsupported.'];
      } else {
        print('ERROR');
        return [false, data['msg']];
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e is DioError) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
          //throw Exception('Server No Response');
          return [false, 'Server No Response'];
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
          //throw Exception(e.message);
          return [false, e.message];
        }
      } else {
        //throw Exception(e.toString());
        return [false, e.toString()];
      }
    }
  }

  Future<List<dynamic>> connectDevice({
    required int currentNodeID,
    required String ip,
    required String read,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String connectDevicePath = '/net/node/' + currentNodeID.toString() + '/try';

    try {
      // device
      Map<String, dynamic> requestData = {
        'ip': ip,
        'read': read,
      };

      Response response = await dio.post(connectDevicePath, data: requestData);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200' || data['code'] == '204') {
        return [true, ''];
      } else {
        print('ERROR');
        return [false, data['msg']];
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e is DioError) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
          //throw Exception('Server No Response');
          return [false, 'Server No Response'];
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
          //throw Exception(e.message);
          return [false, e.message];
        }
      } else {
        //throw Exception(e.toString());
        return [false, e.toString()];
      }
    }
  }

  Future<List<dynamic>> deleteNode({
    required Node currentNode,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deleteNodePath = '/net/node/' + currentNode.id.toString();

    try {
      //404

      Response response;

      Map<String, dynamic> requestData = {
        'uid': user.id,
      };

      response = await dio.delete(deleteNodePath, data: requestData);

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [true, ''];
      } else {
        print('ERROR');
        return [false, data['msg']];
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e is DioError) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
          //throw Exception('Server No Response');
          return [false, 'Server No Response'];
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
          //throw Exception(e.message);
          return [false, e.message];
        }
      } else {
        //throw Exception(e.toString());
        return [false, e.toString()];
      }
    }
  }

  Future<List<dynamic>> searchNodes({
    required int type,
    required String keyword,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deleteNodePath = '/device/search/';

    try {
      //404

      Response response;

      Map<String, dynamic> queryData = {
        'type': type,
        'value': keyword,
      };

      response = await dio.get(deleteNodePath, queryParameters: queryData);

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List searchDataList = [];
        List dataList = data['data'];

        for (var element in dataList) {
          if (element['id'] == null) continue;

          String rawPath = element['path'];
          List<String> nodeIdList =
              rawPath.split(',').where((raw) => raw.isNotEmpty).toList();
          List<int> path = [];
          nodeIdList.forEach((nodeId) {
            path.add(int.parse(nodeId));
          });

          SearchData searchData = SearchData(
            id: element['id'],
            name: element['name'],
            path: path,
            shelf: element['shelf'],
            slot: element['slot'],
            teg: element['teg'],
            type: element['type'],
            deviceName: element['device_name'],
            deviceDescription: element['device_desc'],
            deviceLocation: element['device_location'],
            moduleId: element['module_id'],
            status: element['status'],
          );
          searchDataList.add(searchData);
        }
        return [true, searchDataList];
      } else {
        print('ERROR');
        return [false, data['msg']];
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e is DioError) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
          //throw Exception('Server No Response');
          return [false, 'Server No Response'];
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
          //throw Exception(e.message);
          return [false, e.message];
        }
      } else {
        //throw Exception(e.toString());
        return [false, e.toString()];
      }
    }
  }

  Future<List<dynamic>> exportNodes() async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String nodeExportApiPath = '/net/node';

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

      rawDataList.forEach((element) {
        if (element.isNotEmpty) {
          List<String> line = element.split(',');
          dataList.add(line);
        }
      });

      String csv = const ListToCsvConverter().convert(dataList);

      String timeStamp =
          DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();

      String filename = 'root_data_$timeStamp.csv';

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
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
          //throw Exception('Server No Response');
          return [false, 'Server No Response'];
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
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

class SearchData {
  const SearchData({
    required this.id,
    this.name = '',
    this.path = const [],
    this.shelf = -1,
    this.slot = -1,
    this.type = -1,
    this.teg = '',
    this.deviceName = '',
    this.deviceDescription = '',
    this.deviceLocation = '',
    this.moduleId = -1,
    this.status = -1,
  });

  final int id;
  final String name;
  final List path;
  final int shelf;
  final int slot;
  final int type;
  final String teg;
  final String deviceName;
  final String deviceDescription;
  final String deviceLocation;
  final int moduleId;
  final int status;
}

class Node {
  const Node({
    required this.id,
    this.name = '',
    this.type = -1,
    this.teg = '',
    this.path = '',
    this.shelf = -1,
    this.slot = -1,
    this.status = -1,
    this.sort = '',
    this.info,
  });

  final int id;
  final String name;
  final int type;
  final String teg;
  final String path;
  final int shelf;
  final int slot;
  final int status;
  final String sort;
  final Info? info;
}

class Info {
  const Info({
    this.deviceID = -1,
    this.ip = '',
    this.read = '',
    this.write = '',
    this.description = '',
    this.location = '',
    this.parentID = -1,
    this.path = '',
    this.deviceMainID = -1,
    this.moduleID = -1,
    this.module = '',
    this.series = '',
  });

  final int deviceID;
  final String ip;
  final String read;
  final String write;
  final String description;
  final String location;
  final int parentID;
  final String path;
  final int deviceMainID;
  final int moduleID;
  final String module;
  final String series;
}

// "device_id": 678,
// "ip": "192.168.29.202",
// "shelf": 0,
// "slot": 0,
// "read": "public",
// "write": "private",
// "description": "",
// "location": "",
// "parent_id": 779,
// "path": ",1000,779,",
// "device_main_id": -1,
// "module_id": -1,
// "module": "A8K3U",
// "series": "A8K3U"
