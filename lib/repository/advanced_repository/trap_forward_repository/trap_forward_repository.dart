import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_forward_repository/forward_detail.dart';
import 'package:ricoms_app/repository/advanced_repository/trap_forward_repository/forward_outline.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

class TrapForwardRepository {
  /// call api 取得 trap forward 列表, 並將 json data 轉換為 ForwardOutline 的資料結構
  Future<List<dynamic>> getForwardOutlineList({
    required User user,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String trapForwardListApiPath = '/advanced/forward';

    try {
      Response response = await dio.get(
        trapForwardListApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List<ForwardOutline> forwardOutlineList = List<ForwardOutline>.from(
            data['data'].map((element) => ForwardOutline.fromJson(element)));

        return [true, forwardOutlineList];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 取得 trap forward 設定內容, 並將 json data 轉換為 ForwardDetail 的資料結構
  Future<List<dynamic>> getForwardDetail({
    required User user,
    required int id,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String trapForwardInfoApiPath = '/advanced/forward/$id';

    try {
      Response response = await dio.get(
        trapForwardInfoApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        ForwardDetail forwardDetail = List<ForwardDetail>.from(
            data['data'].map((element) => ForwardDetail.fromJson(element)))[0];

        return [true, forwardDetail];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 更新 trap forward 設定內容
  Future<List<dynamic>> updateForwardDetail({
    required User user,
    required int id,
    required bool enable,
    required String name,
    required String ip,
    required List<Parameter> parameters,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String trapForwardInfoApiPath = '/advanced/forward';

    int isEnable = enable ? 1 : 0;

    ForwardDetail forwardDetail = ForwardDetail(
      id: id,
      enable: isEnable,
      name: name,
      ip: ip,
      parameters: parameters,
    );

    Map<String, dynamic> requestData = forwardDetail.toJson();
    requestData['uid'] = user.id;

    try {
      Response response = await dio.put(
        trapForwardInfoApiPath,
        data: requestData,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [true, ''];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 新增 trap forward 設定內容
  Future<List<dynamic>> createForwardDetail({
    required User user,
    required bool enable,
    required String name,
    required String ip,
    required List<Parameter> parameters,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String trapForwardInfoApiPath = '/advanced/forward';

    int isEnable = enable ? 1 : 0;

    ForwardDetail forwardDetail = ForwardDetail(
      id: 0,
      enable: isEnable,
      name: name,
      ip: ip,
      parameters: parameters,
    );

    Map<String, dynamic> requestData = forwardDetail.toJson();
    requestData['uid'] = user.id;

    try {
      Response response = await dio.put(
        trapForwardInfoApiPath,
        data: requestData,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [true, ''];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 刪除單筆 trap forward 設定
  Future<List<dynamic>> deleteForwardOutline({
    required User user,
    required int id,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String trapForwardDeleteApiPath = '/advanced/forward/$id?uid=${user.id}';

    try {
      Response response = await dio.delete(
        trapForwardDeleteApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [true, ''];
      } else {
        return [false, 'Delete Trap Forward failed!'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 刪除多筆 trap forward 設定
  Future<List<dynamic>> deleteMultipleForwardOutlines({
    required User user,
    required List<ForwardOutline> forwardOutlines,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;

    for (ForwardOutline forwardOutline in forwardOutlines) {
      String trapForwardDeleteApiPath =
          '/advanced/forward/${forwardOutline.id}?uid=${user.id}';

      try {
        Response response = await dio.delete(
          trapForwardDeleteApiPath,
        );

        var data = jsonDecode(response.data.toString());

        if (data['code'] != '200') {
          return [
            false,
            'Delete Trap Forward failed! Name: ${forwardOutline.name}'
          ];
        }
      } on DioError catch (_) {
        return [false, CustomErrMsg.connectionFailed];
      }
    }
    return [true, ''];
  }
}
