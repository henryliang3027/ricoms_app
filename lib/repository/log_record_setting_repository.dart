import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/log_record_setting.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

class LogRecordSettingRepository {
  LogRecordSettingRepository();

  Future<List<dynamic>> getLogRecordSetting({required User user}) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String trapForwardListApiPath = '/advanced/datasave';

    try {
      Response response = await dio.get(
        trapForwardListApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        LogRecordSetting logRecordSetting = List<LogRecordSetting>.from(
            data['data']
                .map((element) => LogRecordSetting.fromJson(element)))[0];

        return [
          true,
          logRecordSetting,
        ];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  Future<List<dynamic>> setLogRecordSetting({
    required User user,
    required String archivedHistoricalRecordQuanitiy,
    required String enableApiLogPreservation,
    required String apiLogPreservedQuantity,
    required String apiLogPreservedDays,
    required String enableUserSystemLogPreservation,
    required String userSystemLogPreservedQuantity,
    required String userSystemLogPreservedDays,
    required String enableDeviceSystemLogPreservation,
    required String deviceSystemLogPreservedQuantity,
    required String deviceSystemLogPreservedDays,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String trapForwardListApiPath = '/advanced/datasave';

    try {
      LogRecordSetting logRecordSetting = LogRecordSetting(
        archivedHistoricalRecordQuanitiy: archivedHistoricalRecordQuanitiy,
        enableApiLogPreservation: enableApiLogPreservation,
        apiLogPreservedQuantity: apiLogPreservedQuantity,
        apiLogPreservedDays: apiLogPreservedDays,
        enableUserSystemLogPreservation: enableUserSystemLogPreservation,
        userSystemLogPreservedQuantity: userSystemLogPreservedQuantity,
        userSystemLogPreservedDays: userSystemLogPreservedDays,
        enableDeviceSystemLogPreservation: enableDeviceSystemLogPreservation,
        deviceSystemLogPreservedQuantity: deviceSystemLogPreservedQuantity,
        deviceSystemLogPreservedDays: deviceSystemLogPreservedDays,
      );

      Map<String, dynamic> requestData = logRecordSetting.toJson();
      requestData['uid'] = user.id;

      Response response = await dio.put(
        trapForwardListApiPath,
        data: requestData,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [
          true,
          logRecordSetting,
        ];
      } else {
        return [false, data['msg']];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }
}

// class LogRecordSetting {
//   const LogRecordSetting({
//     required this.archivedHistoricalRecordQuanitiy,
//     required this.enableApiLogPreservation,
//     required this.apiLogPreservedQuantity,
//     required this.apiLogPreservedDays,
//     required this.enableUserSystemLogPreservation,
//     required this.userSystemLogPreservedQuantity,
//     required this.userSystemLogPreservedDays,
//     required this.enableDeviceSystemLogPreservation,
//     required this.deviceSystemLogPreservedQuantity,
//     required this.deviceSystemLogPreservedDays,
//   });

//   final String archivedHistoricalRecordQuanitiy;
//   final String enableApiLogPreservation;
//   final String apiLogPreservedQuantity;
//   final String apiLogPreservedDays;
//   final String enableUserSystemLogPreservation;
//   final String userSystemLogPreservedQuantity;
//   final String userSystemLogPreservedDays;
//   final String enableDeviceSystemLogPreservation;
//   final String deviceSystemLogPreservedQuantity;
//   final String deviceSystemLogPreservedDays;
// }
