import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ricoms_app/repository/user.dart';

class RootRepository {
  RootRepository(this.user);

  final User user;

  Future<List> getDeviceStatus() async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String deviceStatusPath = '/device/1003/block/101';

    try {
      //404
      Response response = await dio.get(deviceStatusPath);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        //List dataList = data['data'];
        print(data['data'][0]);
        return data['data'];
      } else {
        print('ERROR');
        return [];
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e is DioError) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
          throw Exception('Server No Response');
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
          throw Exception(e.message);
        }
      } else {
        throw Exception(e.toString());
      }
    }
  }
}
