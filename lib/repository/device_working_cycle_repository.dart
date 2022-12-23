import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';

class DeviceWorkingCycleRepository {
  Future<List<dynamic>> getWorkingCycleList({required User user}) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String trapForwardListApiPath = '/advanced/rotation';

    try {
      Response response = await dio.get(
        trapForwardListApiPath,
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
}

class DeviceWorkingCycle {
  const DeviceWorkingCycle({
    required this.index,
    required this.name,
  });

  final String index;
  final String name;
}
