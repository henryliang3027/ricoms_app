import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ricoms_app/account/model/account.dart';
import 'package:ricoms_app/repository/account_repository/account_detail.dart';
import 'package:ricoms_app/repository/account_repository/account_outline.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/utils/custom_errmsg.dart';
import 'package:ricoms_app/utils/master_slave_info.dart';

class AccountRepository {
  AccountRepository();

  final Dio _dio = Dio();

  /// call api 取得帳號列表
  Future<List<dynamic>> getAccountOutlineList({
    required User user,
    String? keyword,
  }) async {
    // demo 帳號 無資料
    if (user.id == 'demo') {
      return [false, 'There are no records to show'];
    }

    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: _dio);
    _dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;
    String accountListApiPath = '/accounts';

    try {
      Response response = await _dio.get(
        accountListApiPath,
      );

      Map<String, dynamic> data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        List<AccountOutline> accountOutlineList = List<AccountOutline>.from(
            data['data'].map((element) => AccountOutline.fromJson(element)));

        if (accountOutlineList.isNotEmpty) {
          if (keyword != null && keyword.isNotEmpty) {
            List<AccountOutline> matchedAccountOutlineList = accountOutlineList
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
              // search but no account matched keyword
              return [false, 'There are no records to show'];
            }
          } else {
            //return all accounts if keyword is empty
            return [true, accountOutlineList];
          }
        } else {
          // request for all but get no account
          return [false, 'There are no records to show'];
        }
      } else {
        return [false, 'Error errno: ${data['code']} msg: ${data['msg']}'];
      }
    } catch (e) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 藉由 account id 取得特定帳號內容
  Future<List<dynamic>> getAccountDetail({
    required User user,
    required int accountId,
  }) async {
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: _dio);
    _dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;
    String accountDetailApiPath = '/accounts/$accountId';

    try {
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
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 新增帳號
  Future<List<dynamic>> createAccount({
    required User user,
    required String account,
    required String password,
    required String name,
    required int permission,
    String? department,
    String? email,
    String? mobile,
    String? tel,
    String? ext,
  }) async {
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: _dio);
    _dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;
    String createAccountApiPath = '/accounts';

    try {
      AccountDetail accountDetail = AccountDetail(
        account: account,
        name: name,
        permission:
            permission.toString(), // int type digit to string type digit
        department: department,
        email: email,
        mobile: mobile,
        tel: tel,
        ext: ext,
        password: password,
      );

      Map<String, dynamic> requestData = accountDetail.toJson();
      requestData['uid'] = user.id;

      Response response = await _dio.post(
        createAccountApiPath,
        data: requestData,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [true, data['msg']];
      } else {
        return [false, data['msg']];
      }
    } catch (e) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 更新帳號內容
  Future<List<dynamic>> updateAccount({
    required User user,
    required int accountId,
    required String account,
    required String password,
    required String name,
    required int permission,
    String? department,
    String? email,
    String? mobile,
    String? tel,
    String? ext,
  }) async {
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: _dio);
    _dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;
    String updateAccountApiPath = '/accounts/$accountId';

    try {
      AccountDetail accountDetail = AccountDetail(
        account: account,
        name: name,
        permission:
            permission.toString(), // int type digit to string type digit
        department: department,
        email: email,
        mobile: mobile,
        tel: tel,
        ext: ext,
        password: password,
      );

      Map<String, dynamic> requestData = accountDetail.toJson();
      requestData['uid'] = user.id;

      Response response = await _dio.put(
        updateAccountApiPath,
        data: requestData,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [true, data['msg']];
      } else {
        return [false, data['msg']];
      }
    } catch (e) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// call api 刪除帳號
  Future<List<dynamic>> deleteAccount({
    required User user,
    required int accountId,
  }) async {
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: _dio);
    _dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;
    String deleteAccountApiPath = '/accounts/$accountId';

    try {
      Map<String, dynamic> requestData = {
        'account_id': accountId,
        'uid': user.id,
      };

      Response response = await _dio.delete(
        deleteAccountApiPath,
        data: requestData,
      );

      var data = jsonDecode(response.data.toString());

      if (data['code'] == '200') {
        return [true, data['msg']];
      } else {
        return [false, data['msg']];
      }
    } catch (e) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }

  /// 匯出基於目前條件下的帳號清單
  Future<List> exportAccounts({
    required User user,
  }) async {
    String onlineIP = await MasterSlaveServerInfo.getOnlineServerIP(
        loginIP: user.ip, dio: _dio);
    _dio.options.baseUrl = 'http://' + onlineIP + '/aci/api';
    _dio.options.connectTimeout = 10000; //10s
    _dio.options.receiveTimeout = 10000;
    String exportAccountsApiPath = '/accounts/export';

    try {
      Response response = await _dio.get(
        exportAccountsApiPath,
      );

      String rawData = response.data;
      RegExp regExp = RegExp(r'"[^"]*"'); // 匹配雙引號内的字串
      String specialToken = '\\n'; // 換行符號的特殊標記
      String commaSpecialToken = '\u0000'; // 逗號的特殊標記

      // 將在雙引號內的换行符號替換為特殊標記
      String modifiedString = rawData.replaceAllMapped(regExp, (match) {
        return match[0]!.replaceAll('\n', specialToken);
      });

      // 對替換後的字串進行分割
      List<String> rawDataList = modifiedString.split('\n');

      // 將特殊標記替换為真正的換行符號
      for (int i = 0; i < rawDataList.length; i++) {
        rawDataList[i] = rawDataList[i].replaceAll(specialToken, '\n');
      }

      Excel excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];

      for (int i = 0; i < rawDataList.length; i++) {
        if (rawDataList[i].isNotEmpty) {
          // 將在雙引號內的逗號替換為特殊標記
          String modifiedSubString =
              rawDataList[i].replaceAllMapped(regExp, (match) {
            return match[0]!.replaceAll(',', commaSpecialToken);
          });

          List<String> line = modifiedSubString.split(',');

          // 將特殊標記替换為真正的逗號
          for (int j = 0; j < line.length; j++) {
            line[j] = line[j].replaceAll(commaSpecialToken, ',');
          }

          List<String> noQuotesLine = [];

          // 將雙引號去掉, 替換為空字元
          for (String word in line) {
            if (word.startsWith('\"') && word.endsWith('\"')) {
              word = word.replaceFirst('\"', '');
              word = word.replaceFirst('\"', '', word.length - 1);
              word = word.replaceAll('\"\"', '\"');
            }

            noQuotesLine.add(word);
          }

          sheet.insertRowIterables(noQuotesLine, i);
        }
      }

      var fileBytes = excel.save();

      String timeStamp =
          DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();

      String filename = 'User_Accounts_data_$timeStamp.xlsx';

      if (Platform.isIOS) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        String fullWrittenPath = '$appDocPath/$filename';
        File f = File(fullWrittenPath);
        await f.writeAsBytes(fileBytes!);
        return [
          true,
          'Export account data success',
          fullWrittenPath,
        ];
      } else if (Platform.isAndroid) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        String fullWrittenPath = '$appDocPath/$filename';
        File f = File(fullWrittenPath);
        await f.writeAsBytes(fileBytes!);

        return [
          true,
          'Export account data success',
          fullWrittenPath,
        ];
      } else {
        return [
          false,
          'write file failed, export function not implement on ${Platform.operatingSystem} '
        ];
      }
    } on DioError catch (_) {
      return [false, CustomErrMsg.connectionFailed];
    }
  }
}
