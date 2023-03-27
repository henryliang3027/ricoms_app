import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

class DeviceWorkingCycleRepository {
  // call api 取得裝置輪詢週期資料與目前輪詢週期設定
  Future<List<dynamic>> getWorkingCycleList({required User user}) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deviceWorkingCycleApiPath = '/advanced/rotation';

    try {
      Response response = await dio.get(
        deviceWorkingCycleApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List<DeviceWorkingCycle> deviceWorkingCycleList = [];
        Map<String, dynamic> items = data['data'][0]['items'];
        String defaultIndex = data['data'][0]['index'].toString();

        for (MapEntry<String, dynamic> entry in items.entries) {
          String index = entry.key;
          String name = (entry.value as Map<String, dynamic>)['name'];
          DeviceWorkingCycle deviceWorkingCycle = DeviceWorkingCycle(
            index: index,
            name: name,
          );

          deviceWorkingCycleList.add(deviceWorkingCycle);
        }

        return [
          true,
          deviceWorkingCycleList,
          defaultIndex,
        ];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  // call api 設定裝置輪詢週期
  Future<List<dynamic>> setWorkingCycle({
    required User user,
    required String index,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String trapForwardListApiPath = '/advanced/rotation';

    Map<String, dynamic> requestData = {
      'uid': user.id,
      'index': index,
    };

    try {
      Response response =
          await dio.put(trapForwardListApiPath, data: requestData);

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [
          true,
        ];
      } else {
        return [
          false,
        ];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }
}

// 儲存裝置輪詢週期設定的名稱與 index
class DeviceWorkingCycle {
  const DeviceWorkingCycle({
    required this.index,
    required this.name,
  });

  final String index;
  final String name;
}
