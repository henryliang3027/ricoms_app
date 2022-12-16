import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';

class BatchSettingRepository {
  Future<bool> setDeviceParameter({
    required User user,
  }) async {
    await Future.delayed(const Duration(seconds: 3));
    return true;
    // Dio dio = Dio();
    // dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    // dio.options.connectTimeout = 10000; //10s
    // dio.options.receiveTimeout = 10000;
    // String trapForwardListApiPath = '/advanced/forward';

    // try {
    //   Response response = await dio.get(
    //     trapForwardListApiPath,
    //   );

    //   var data = jsonDecode(response.data.toString());

    //   if (data['code'] == '200') {
    //     // List<ForwardOutline> forwardOutlineList = List<ForwardOutline>.from(
    //     //     data['data'].map((element) => ForwardOutline.fromJson(element)));

    //     return [true, []];
    //   } else {
    //     return [false, 'There are no records to show'];
    //   }
    // } on DioError catch (_) {
    //   return [false, CustomErrMsg.connectionFailed];
    // }
  }
}
