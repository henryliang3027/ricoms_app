import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';

class TrapForwardRepository {
  Future<List<dynamic>> getForwardMetaList({
    required User user,
  }) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String trapForwardListApiPath = '/advanced/forward';

    try {
      Response response = await dio.get(
        trapForwardListApiPath,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List rawDataList = data['data'];
        List<ForwardMeta> forwardMetaList = [];

        for (var element in rawDataList) {
          if (element['id'] != null) {
            ForwardMeta forwardMeta = ForwardMeta(
              id: element['id'],
              enable: element['enable'] ?? 0,
              name: element['name'] ?? '',
              ip: element['ip'] ?? '',
              //element['item'] : we don't need this data that return from api
            );

            forwardMetaList.add(forwardMeta);
          }
        }
        return [true, forwardMetaList];
      } else {
        return [false, 'There are no records to show'];
      }
    } on DioError catch (e) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }
}

Future<List<dynamic>> getForwardDetail({
  required User user,
  required int id,
}) async {
  Dio dio = Dio();
  dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
  dio.options.connectTimeout = 10000; //10s
  dio.options.receiveTimeout = 10000;
  String trapForwardInfoApiPath = '/advanced/forward/$id';

  try {
    Response response = await dio.get(
      trapForwardInfoApiPath,
    );

    var data = jsonDecode(response.data.toString());

    if (data['code'] == '200') {
      var rawData = data['data'][0];

      List itemDataList = rawData['item'];
      List<Parameter> parameters = [];
      for (var item in itemDataList) {
        Parameter parameter = Parameter(
          name: item['name'],
          oid: item['OID'],
          check: item['checked'],
        );
        parameters.add(parameter);
      }

      ForwardDetail forwardDetail = ForwardDetail(
        id: rawData['id'],
        enable: rawData['enable'] ?? 0,
        name: rawData['name'] ?? '',
        ip: rawData['ip'] ?? '',
        parameters: parameters,
      );

      return [true, forwardDetail];
    } else {
      return [false, 'There are no records to show'];
    }
  } on DioError catch (e) {
    return [false, CustomErrMsg.connectionFailed];
  }
}

class ForwardMeta {
  const ForwardMeta({
    required this.id, //forward info id
    this.enable = 0, // 'User' or 'Device'
    this.name = '',
    this.ip = '',
  });

  final int id;
  final int enable;
  final String name;
  final String ip;
}

class ForwardDetail {
  const ForwardDetail({
    required this.id, //forward info id
    this.enable = 0, // 'User' or 'Device'
    this.name = '',
    this.ip = '',
    this.parameters = const [], // forward parameters
  });

  final int id;
  final int enable;
  final String name;
  final String ip;
  final List<Parameter> parameters;
}

class Parameter {
  const Parameter({
    required this.name,
    required this.oid,
    required this.check,
  });

  final String name;
  final String oid;
  final int check;
}
