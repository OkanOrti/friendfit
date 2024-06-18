// ignore_for_file: file_names, avoid_returning_null_for_void, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/StepViewModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatoryKey = GlobalKey<NavigatorState>();

  Future<void> navigateTo(String routeName) {
    return navigatoryKey.currentState!.pushNamed(routeName);
  }

  Future<void> navigateToWithArgs(String routeName, String args) {
    return navigatoryKey.currentState!.pushNamed(routeName, arguments: args);
  }

  Future<void> openDialog() async {
    bool check = false;
    await showDialog(
        context: navigatoryKey.currentContext!,
        builder: (_) => AlertDialog(
              title: const Text("Bilgilendirme"),
              content: const Text(
                "Adımlarınızı görebilmeniz ve FitCoin e dönüştürebilmeniz icin lütfen izin yöneticinizden fiziksel aktivite iznini veriniz.",
                style: TextStyle(fontSize: 14, fontFamily: "Poppins"),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('İzin yöneticisi'),
                  onPressed: () async {
                    Navigator.pop(navigatoryKey.currentContext!);
                    await AppSettings.openAppSettings();

                    //check = true;
                  },
                ),
                FlatButton(
                  child: Text('Vazgec'),
                  //textColor: Colors.grey,
                  onPressed: () {
                    Navigator.pop(navigatoryKey.currentContext!);
                  },
                ),
              ],
            ));

    //return check;
  }
}
