import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_api.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

class RootRepository {
  RootRepository();

  Future<dynamic> getChilds({
    required User user,
    required int parentId,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String childsPath = '/net/node/' + parentId.toString() + '/childs';

    if (user.id == 'demo') {
      return 'No node';
    }

    try {
      Response response = await dio.get(
        childsPath,
      );

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List<Node> childs = [];
        List dataList = data['data'];

        for (var element in dataList) {
          if (element['id'] == null) continue;

          /// check if device status is unknown or offline
          int status = -1;
          if (element['status'] == 0) {
            List<dynamic> resultOfGetInfo = await getNodeInfo(
              user: user,
              nodeId: element['id'],
            );
            if (resultOfGetInfo[0]) {
              Info info = resultOfGetInfo[1];

              status = info.moduleID == -2 ? -2 : 0;
            } else {
              status = element['status'];
            }
          } else {
            status = element['status'];
          }

          ///

          Node node = Node(
            id: element['id'],
            name: element['name'],
            type: element['type'],
            teg: element['teg'],
            path: element['path'],
            shelf: element['shelf'],
            slot: element['slot'],
            status: status,
            sort: element['sort'],
          );
          childs.add(node);
        }
        return childs;
      } else {
        return 'No node';
      }
    } on DioError catch (_) {
      return CustomErrMsg.connectionFailed;
    }
  }

  // check  device online or offline
  Future<List<dynamic>> checkDeviceConnectionStatus({
    required User user,
    required int deviceId,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;

    // if (_pageId[pageName] == null) {
    //   return 'Page id does not exist! please look up block and give a page id';
    // }

    String deviceBlockPath = '/device/' + deviceId.toString() + '/block';

    try {
      Response response = await dio.get(deviceBlockPath);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [true, 'online'];
      } else {
        return [false, 'offline'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<List<dynamic>> getNodeInfo(
      {required User user, required int nodeId}) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String childsPath = '/net/node/' + nodeId.toString();

    try {
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

        return [true, info];
      } else {
        return [false, 'Error errno: ${data['code']}'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<List<dynamic>> getDataSheetURL({
    required User user,
    required int nodeId,
  }) async {
    List<dynamic> resultOfGetInfo =
        await getNodeInfo(user: user, nodeId: nodeId);

    if (resultOfGetInfo[0]) {
      Info info = resultOfGetInfo[1];
      String onlineIP = MasterSlaveServerInfo.onlineServerIP;
      String moduleSeries = info.series.replaceAll(' ', '%20');
      String moduleName = info.module.replaceAll(' ', '%20');
      String dataSheetURL =
          'http://$onlineIP/aci/ricoms/datasheet/$moduleSeries/$moduleName.pdf';

      return [true, dataSheetURL];
    } else {
      return [false, resultOfGetInfo[1]];
    }
  }

  Future<List<dynamic>> createNode({
    required User user,
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
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String createNodePath = '/net/node/' + parentId.toString() + '/childs/new';

    try {
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
        return [true, ''];
      } else if (data['code'] == '204') {
        return [true, 'The device is unconnected and unsupported.'];
      } else if (data['code'] == '409') {
        return [false, 'The device already exists.'];
      } else {
        return [false, data['msg']];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<List<dynamic>> updateNode({
    required User user,
    required Node currentNode,
    required String name,
    required String description,
    String? deviceIP,
    String? read,
    String? write,
    String? location,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String updateNodePath = '/net/node/' + currentNode.id.toString();

    try {
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
        return [true, ''];
      } else if (data['code'] == '204') {
        return [true, 'The device is unconnected and unsupported.'];
      } else {
        return [false, data['msg']];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<List<dynamic>> getDeviceName({
    required User user,
    required int deviceId,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String devicePath = '/net/node/' + deviceId.toString();

    try {
      Response response = await dio.get(devicePath);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        String name = data['data'][0]['name'];

        return [true, name];
      } else {
        return [false, 'Error errno: ${data['code']}'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<List<dynamic>> connectDevice({
    required User user,
    required int currentNodeID,
    required String ip,
    required String read,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
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
        return [false, data['msg']];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<List<dynamic>> deleteNode({
    required User user,
    required Node currentNode,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deleteNodePath = '/net/node/' + currentNode.id.toString();

    try {
      Response response;

      Map<String, dynamic> requestData = {
        'uid': user.id,
      };

      response = await dio.delete(deleteNodePath, data: requestData);

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [true, ''];
      } else {
        return [false, data['msg']];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<List<dynamic>> searchNodes({
    required User user,
    required int type,
    required String keyword,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deleteNodePath = '/device/search/';

    try {
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

          String rawPath = element['path'] ?? '';
          List<String> nodeIdList =
              rawPath.split(',').where((raw) => raw.isNotEmpty).toList();
          List<int> path = [];
          for (var nodeId in nodeIdList) {
            path.add(int.parse(nodeId));
          }

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
        return [false, data['msg']];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<List<dynamic>> exportNodes({required User user}) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String nodeExportApiPath = '/net/node';

    try {
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

      String filename = 'root_data_$timeStamp.csv';

      if (Platform.isIOS) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        String fullWrittenPath = '$appDocPath/$filename';
        File f = File(fullWrittenPath);
        await f.writeAsString('\uFEFF\n' + csv);
        return [
          true,
          'Export root data success',
          fullWrittenPath,
        ];
      } else if (Platform.isAndroid) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        String fullWrittenPath = '$appDocPath/$filename';
        File f = File(fullWrittenPath);
        await f.writeAsString('\uFEFF\n' + csv);

        return [
          true,
          'Export root data success',
          fullWrittenPath,
        ];
      } else {
        return [
          false,
          'write file failed, export function not implement on ${Platform.operatingSystem} '
        ];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  List<DeviceMeta> getBookmarks({required User user}) {
    UserApi userApi = UserApi();

    List<DeviceMeta> bookmarks = userApi.getBookmarksByUserId(user.id);

    return bookmarks;
  }

  Future<bool> addBookmarks({
    required User user,
    required Node node,
  }) async {
    UserApi userApi = UserApi();

    List<dynamic> resultOfNodeInfo =
        await getNodeInfo(user: user, nodeId: node.id);

    String deviceIp = '-';
    List<int> path = [];

    if (resultOfNodeInfo[0]) {
      Info info = resultOfNodeInfo[1];
      deviceIp = info.ip;
    } else {
      deviceIp = '-';
    }

    List<String> nodeIdList =
        node.path.split(',').where((raw) => raw.isNotEmpty).toList();
    for (var nodeId in nodeIdList) {
      path.add(int.parse(nodeId));
    }

    DeviceMeta deviceMeta = DeviceMeta(
      id: node.id,
      name: node.name,
      type: node.type,
      ip: deviceIp,
      shelf: node.shelf,
      slot: node.slot,
      path: path,
    );

    bool resdult = await userApi.addBookmarksByUserId(user.id, deviceMeta);

    return resdult;
  }

  Future<bool> deleteBookmarks({
    required User user,
    required int nodeId,
  }) async {
    UserApi userApi = UserApi();

    bool resdult = await userApi.deleteBookmarksByUserId(user.id, nodeId);

    return resdult;
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
