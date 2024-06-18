// ignore: file_names
// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefRepo {
  static const String appInstallDatekeyVal = "AppInstallDate";

  Future<bool> addAppInstallDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int appInstallDate = (prefs.getInt(appInstallDatekeyVal) ?? 0);
    if (appInstallDate == 0) {
      prefs.setInt(appInstallDatekeyVal, DateTime.now().millisecondsSinceEpoch);
    }
    return true;
  }

  Future<DateTime> getAppInstallDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int appInstallDateInt = (prefs.getInt(appInstallDatekeyVal) ?? 0);
    DateTime appInstallDate =
        DateTime.fromMillisecondsSinceEpoch(appInstallDateInt);
    return appInstallDate;
  }
}
