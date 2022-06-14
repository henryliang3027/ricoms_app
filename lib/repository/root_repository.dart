import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:ricoms_app/repository/user.dart';

class RootRepository {
  RootRepository(this.user);

  final User user;

  Future<dynamic> getChilds(Node parent) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String childsPath = '/net/node/' + parent.id.toString() + '/childs';

    try {
      //404
      Response response = await dio.get(childsPath);

      //print(response.data.toString());
      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List<Node> childs = [];
        List dataList = data['data'];

        for (var element in dataList) {
          if (element['id'] == null) continue;
          childs.add(Node(
            id: element['id'],
            name: element['name'],
            type: element['type'],
            teg: element['teg'],
            path: element['path'],
            shelf: element['shelf'],
            slot: element['slot'],
            status: element['status'],
            sort: element['sort'],
          ));
        }
        return childs;
      } else {
        print('ERROR');
        return 'Error errno: ${data['code']}';
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e is DioError) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
          //throw Exception('Server No Response');
          return 'Server No Response';
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
          //throw Exception(e.message);
          return e.message;
        }
      } else {
        //throw Exception(e.toString());
        return Future.error(e.toString());
      }
    }
  }

  Future<List<dynamic>> exportNodes() async {
    Dio dio = Dio();
    dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 10000;
    String nodeExportApiPath = '/net/node';

    try {
      //404
      Response response = await dio.get(
        nodeExportApiPath,
        queryParameters: {'uid': user.id},
      );

      String rawData = response.data;

      rawData = rawData.replaceAll('\"=\"', '');
      rawData = rawData.replaceAll('\"', '');

      List<String> rawDataList = rawData.split('\n');
      List<List<String>> dataList = [];

      rawDataList.forEach((element) {
        if (element.isNotEmpty) {
          List<String> line = element.split(',');
          dataList.add(line);
        }
      });

      String csv = const ListToCsvConverter().convert(dataList);

      String timeStamp =
          DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();

      String filename = 'root_data_$timeStamp.csv';

      if (Platform.isIOS) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        File f = File('$appDocPath/$filename');
        f.writeAsString(csv);
        return [true, 'Export root data success'];
      } else if (Platform.isAndroid) {
        String downloadPath =
            await ExternalPath.getExternalStoragePublicDirectory(
                ExternalPath.DIRECTORY_DOWNLOADS);
        File f = File('$downloadPath/$filename');
        f.writeAsString(csv);
        return [true, 'Export root data success'];
      } else {
        return [
          false,
          'write file failed, export function not implement on ${Platform.operatingSystem} '
        ];
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e is DioError) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
          //throw Exception('Server No Response');
          return [false, 'Server No Response'];
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
          //throw Exception(e.message);
          return [false, e.message];
        }
      } else {
        //throw Exception(e.toString());
        return [false, e.toString()];
      }
    }
  }
}

class Node {
  const Node({
    required this.id,
    this.name = '',
    this.type = -1,
    this.teg = '',
    this.path = '',
    this.shelf = -1,
    this.slot = -1,
    this.status = -1,
    this.sort = '',
  });

  final int id;
  final String name;
  final int type;
  final String teg;
  final String path;
  final int shelf;
  final int slot;
  final int status;
  final String sort;
}
