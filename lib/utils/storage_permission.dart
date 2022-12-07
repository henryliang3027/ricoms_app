import 'package:device_info/device_info.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission() async {
  var androidInfo = await DeviceInfoPlugin().androidInfo;
  int sdkInt = androidInfo.version.sdkInt;
  //print("sdk version " + sdkInt.toString());
  if (sdkInt <= 28) {
    // Android 9 or older
    PermissionStatus storagePermission = await Permission.storage.request();
    if (storagePermission.isGranted) {
      return true;
    } else {
      return false;
    }
  } else {
    // sdk 29, 30, (31-32), 33 Android 10, 11, 12, 13
    PermissionStatus storagePermission = await Permission.storage.request();
    PermissionStatus manageExternalStoragePermission =
        await Permission.manageExternalStorage.request();
    if (
        //  storagePermission.isGranted &&
        manageExternalStoragePermission.isGranted) {
      return true;
    } else {
      return false;
    }
    // PermissionStatus storagePermission = await Permission.storage.request();
    // if (storagePermission.isGranted) {
    //   return true;
    // } else {
    //   return false;
    // }
  }
}
