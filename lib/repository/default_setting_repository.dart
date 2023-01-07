import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/default_setting.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

class DefaultSettingRepository {
  DefaultSettingRepository();

  Future<List<dynamic>> getDefaultSetting({required User user}) async {
    Dio dio = Dio();
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: dio);
    dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String defaultSettingApiPath = '/system/default';

    try {
      Response response = await dio.get(
        defaultSettingApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        DefaultSetting defaultSetting = List<DefaultSetting>.from(
            data['data'].map((element) => DefaultSetting.fromJson(element)))[0];

        return [
          true,
          defaultSetting,
        ];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }
}

class DefaultSettingItem extends Equatable {
  const DefaultSettingItem({
    required this.defaultValue,
    required this.currentValue,
    this.defaultIdx = '',
    this.currentIdx = '',
    this.isSelected = false,
  });

  final bool isSelected;
  final String defaultValue;
  final String currentValue;
  final String defaultIdx; // valid only for device working cycle
  final String currentIdx; // valid only for device working cycle

  @override
  List<Object?> get props => [
        isSelected,
        defaultValue,
        currentValue,
        defaultIdx,
        currentIdx,
      ];
}
