import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/user.dart';

Future<List<dynamic>> getSlaveServerIP({
  required User user,
  required Dio dio,
}) async {
  dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
  dio.options.connectTimeout = 3000; //10s
  dio.options.receiveTimeout = 3000;
  String serverIPInformationPath = '/advanced/masterslave';

  try {
    Response response = await dio.get(
      serverIPInformationPath,
    );

    var data = jsonDecode(response.data.toString());

    if (data['code'] == '200') {
      return [
        true,
        data['data']['server_online'],
      ];
    } else {
      return [false, user.ip];
    }
  } on DioError catch (_) {
    return [false, user.ip];
  }
}
