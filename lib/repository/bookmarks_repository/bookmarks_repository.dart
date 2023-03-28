import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/repository/user_api.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

class BookmarksRepository {
  BookmarksRepository();

  final Dio _dio = Dio();
  final UserApi userApi = UserApi();

  /// 從手機端資料庫取得所有書籤用的 device 簡易描述列表, DeviceMeta 結構
  List<DeviceMeta> getDeviceMetas({
    required User user,
  }) {
    return userApi.getBookmarksByUserId(user.id);
  }

  /// 藉由 DeviceMeta 結構的書籤列表去向後端取得每個 device 的完整內容
  Future<List<dynamic>> getBookmarks({
    required User user,
    required List<DeviceMeta> deviceMetas,
    int startIndex = 0,
  }) async {
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: _dio);
    _dio.options.baseUrl = 'http://' + onlineIP + '/aci/api/';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;

    List<Device> devices = [];
    int count = 0;
    int maxCount = 10;
    int currentIndex = startIndex;
    int deletedCount = 0;

    /// 取得最多10筆 device 的完整內容, 已被刪除的忽略不計算筆數
    while (currentIndex < deviceMetas.length && count < maxCount) {
      DeviceMeta deviceMeta = deviceMetas[currentIndex];
      String deviceStatusApiPath = '/device/${deviceMeta.id.toString()}';

      try {
        Response response = await _dio.get(
          deviceStatusApiPath,
        );

        var data = jsonDecode(response.data.toString());

        if (data['code'] == '200' || data['code'] == '404') {
          // 404 : Doesn't Find Device. status: 0 -> unknown
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
            count = count + 1;
          }
        } else {
          // 已被刪除的 device, status 設為 -99
          Device device = Device(
            id: deviceMeta.id,
            name: deviceMeta.name,
            type: deviceMeta.type,
            ip: deviceMeta.ip,
            shelf: deviceMeta.shelf,
            slot: deviceMeta.slot,
            path: deviceMeta.path,
            status: -99, // device has been deleted
          );
          deletedCount = deletedCount + 1;

          devices.add(device);
        }
        currentIndex = currentIndex + 1;
      } on DioError catch (_) {
        return [false, CustomErrMsg.connectionFailed];
      }
    }
    if (devices.length == deletedCount) {
      // 如果在書籤內已經被刪除的 device 數量等於書籤內全部裝置數量, 則視為無書籤資料
      return [false, 'There are no records to show'];
    } else {
      return [true, devices];
    }
  }

  /// 刪除書籤中的 device
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
}

/// 儲存書籤內個別 device 的資料
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

// e.g.
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
