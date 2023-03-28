import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

/// 用來區別資料是更新用或初始化用
/// 如果是初始化會搭配 UI 的 轉圈圈畫面
enum RequestMode {
  initial,
  update,
}

/// 取得書籤中的 device 的狀態, 是否存在樹裡
Future<List<dynamic>> getDeviceStatus({
  required User user,
  required List<int> path,
}) async {
  Dio dio = Dio();
  String onlineIP =
      await MasterSlaveServerInfo.getOnlineServerIP(loginIP: user.ip, dio: dio);
  dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
  dio.options.connectTimeout = 10000; //10s
  dio.options.receiveTimeout = 10000;
  String realTimeAlarmApiPath = '/device/' + path[0].toString();

  try {
    Response response = await dio.get(
      realTimeAlarmApiPath,
    );

    var data = jsonDecode(response.data.toString());

    if (data['code'] == '200') {
      if (data['data'][0]['status'] == 0) {
        // 0: unknown
        // 4: offline
        return [false, 'The device does not respond!'];
      } else {
        List<int> nodes = path.skip(1).toList();
        List<dynamic> verifiedResilt =
            await _checkPath(user: user, path: nodes);
        if (verifiedResilt[0]) {
          return [true, ''];
        } else {
          return verifiedResilt;
        }
      }
    } else {
      return [false, 'The device does not respond!'];
    }
  } on DioError catch (_) {
    return [false, CustomErrMsg.connectionFailed];
  }
}

/// 檢查 device 是否存在樹裡
Future<List<dynamic>> _checkPath({
  required User user,
  required List<int> path,
}) async {
  Dio dio = Dio();
  String onlineIP =
      await MasterSlaveServerInfo.getOnlineServerIP(loginIP: user.ip, dio: dio);
  dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
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
