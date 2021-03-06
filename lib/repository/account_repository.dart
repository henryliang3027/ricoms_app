import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ricoms_app/repository/account_detail.dart';
import 'package:ricoms_app/repository/account_outline.dart';
import 'package:ricoms_app/repository/user.dart';

class AccountRepository {
  AccountRepository();

  final Dio _dio = Dio();

  Future<List<dynamic>> getAccountOutlineList({
    required User user,
  }) async {
    _dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;
    String accountListApiPath = '/accounts';

    try {
      //404
      Response response = await _dio.get(
        accountListApiPath,
      );

      Map<String, dynamic> data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List<AccountOutline> accountOutlineList = List<AccountOutline>.from(
            data['data'].map((element) => AccountOutline.fromJson(element)));

        if (accountOutlineList.isNotEmpty) {
          return [true, accountOutlineList];
        } else {
          return [false, 'There are no records to show'];
        }
      } else {
        return [false, 'Error errno: ${data['code']} msg: ${data['msg']}'];
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e is DioError) {
        if (e.response != null) {
          if (kDebugMode) {
            print(e.response!.data);
            print(e.response!.headers);
            print(e.response!.requestOptions);
          }

          //throw Exception('Server No Response');
          return [false, 'Server No Response'];
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          if (kDebugMode) {
            print(e.requestOptions);
            print(e.message);
          }

          //throw Exception(e.message);
          return [false, e.message];
        }
      } else {
        //throw Exception(e.toString());
        return [false, e.toString()];
      }
    }
  }

  Future<List<dynamic>> getAccountByKeyword({
    required User user,
    required String keyword,
  }) async {
    List<dynamic> result = await getAccountOutlineList(user: user);

    if (result[0]) {
      List<AccountOutline> matchedAccountOutlineList = result[1]
          .where((accountOutline) =>
              accountOutline.account
                  .toLowerCase()
                  .contains(keyword.toLowerCase()) ||
              (accountOutline.department ?? '')
                  .toLowerCase()
                  .contains(keyword.toLowerCase()) ||
              accountOutline.name
                  .toLowerCase()
                  .contains(keyword.toLowerCase()) ||
              accountOutline.permission
                  .toLowerCase()
                  .contains(keyword.toLowerCase()))
          .toList();

      if (matchedAccountOutlineList.isNotEmpty) {
        return [true, matchedAccountOutlineList];
      } else {
        return [false, 'There are no records to show'];
      }
    } else {
      return [false, result[1]];
    }
  }

  Future<List<dynamic>> getAccountDetail({
    required User user,
    required int accountId,
  }) async {
    _dio.options.baseUrl = 'http://' + user.ip + '/aci/api';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;
    String accountDetailApiPath = '/accounts/$accountId';

    try {
      //404
      Response response = await _dio.get(
        accountDetailApiPath,
      );

      Map<String, dynamic> data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        AccountDetail accountDetail = List<AccountDetail>.from(
            data['data'].map((element) => AccountDetail.fromJson(element)))[0];

        return [true, accountDetail];
      } else {
        return [false, 'Error errno: ${data['code']} msg: ${data['msg']}'];
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e is DioError) {
        if (e.response != null) {
          if (kDebugMode) {
            print(e.response!.data);
            print(e.response!.headers);
            print(e.response!.requestOptions);
          }

          //throw Exception('Server No Response');
          return [false, 'Server No Response'];
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          if (kDebugMode) {
            print(e.requestOptions);
            print(e.message);
          }

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
