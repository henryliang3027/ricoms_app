import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:ricoms_app/advanced/bloc/batch_setting/device_setting_result/device_setting_result_bloc.dart';
import 'package:ricoms_app/repository/advanced_repository/batch_setting_repository/batch_setting_device.dart';
import 'package:ricoms_app/repository/advanced_repository/batch_setting_repository/module.dart';
import 'package:ricoms_app/repository/root_repository/device_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

class BatchSettingRepository {
  /// call api 取得批次設定用的模組資料
  Future<dynamic> getModuleData({
    required User user,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String batchSettingApiPath = '/advanced/modulebatch';

    try {
      Response response = await dio.get(
        batchSettingApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List<Module> modules = List<Module>.from(
            data['data'].map((element) => Module.fromJson(element)));

        return [
          true,
          modules,
        ];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 取得批次設定用的 device 資料
  Future<dynamic> getDeviceData({
    required User user,
    required int moduleId,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String batchSettingDevicesApiPath =
        '/advanced/modulebatch/$moduleId/devices';

    try {
      Response response = await dio.get(
        batchSettingDevicesApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List<BatchSettingDevice> devices = List<BatchSettingDevice>.from(
            data['data']
                .map((element) => BatchSettingDevice.fromJson(element)));

        return [
          true,
          devices,
        ];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 取得批次設定用的 device 可設定的 pages
  Future<List<dynamic>> getDeviceBlock({
    required User user,
    required int moduleId,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String batchDeviceSettingBlockPath =
        '/advanced/modulebatch/' + moduleId.toString() + '/settings';

    try {
      Response response = await dio.get(batchDeviceSettingBlockPath);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List dataList = data['data'];
        List<DeviceBlock> deviceBlocks = [];

        dataList.removeWhere((element) => element['mobile'] == 0);

        // build two maps -> {pagename : id} and {pagename : editable}
        for (var item in dataList) {
          DeviceBlock deviceBlock = DeviceBlock(
            id: item['id'],
            name: item['name'],
            editable: item['edit'] == 1 ? true : false,
          );

          deviceBlocks.add(deviceBlock);
        }

        return [true, deviceBlocks];
      } else {
        return [false, 'The device blocks does not respond!'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 藉由 page id 取得該 page 的參數 json data, 用來建立 ui 元件
  Future<List<dynamic>> getDevicePageData({
    required User user,
    required int moduleId,
    required int pageId,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String batchDeviceSettingDataPath = '/advanced/modulebatch/' +
        moduleId.toString() +
        '/settings/' +
        pageId.toString();

    try {
      Response response = await dio.get(batchDeviceSettingDataPath);
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [true, data['data']];
      } else {
        return [false, 'The device does not respond!'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 設定 device 參數
  Future<List<dynamic>> setDeviceParameter({
    required User user,
    required DeviceParamItem deviceParamItem,
  }) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);

    // print('onlone ip: ${onlineIP}');
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String batchDeviceSettingApiPath = '/advanced/modulebatch';

    try {
      List<Map<String, String>> paramMapList = [
        {'oid_id': deviceParamItem.oid, 'value': deviceParamItem.param}
      ];
      var requestData = {
        'uid': user.id,
        'node_id': deviceParamItem.id,
        'data': paramMapList
      };

      Response response = await dio.put(
        batchDeviceSettingApiPath,
        data: requestData,
      );

      var data = jsonDecode(response.data.toString());
      String modifyResult = data['data'][0]['modify_result'] ?? "";
      String endTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString();

      if (data['code'] == '200') {
        return [true, modifyResult, endTime];
      } else {
        return [false, modifyResult, endTime];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed, 'Request timeout'];
    }
  }
}
