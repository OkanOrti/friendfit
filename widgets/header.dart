import 'package:flutter/material.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';

AppBar header(
  BuildContext context, {
  String? title,
  bool isAppTitle = false,
  bool removeBackButton = false,
}) {
  return AppBar(
      iconTheme: const IconThemeData(
        color: AppColors.kFont, //change your color here
      ),
      backgroundColor: Colors.white,
      automaticallyImplyLeading: removeBackButton ? false : true,
      title: Text(isAppTitle ? "FlutterShare" : title!,
          style: TextStyle(
              color: AppColors.kRed,
              fontFamily: isAppTitle ? "Poppins" : "Poppins",
              fontSize: isAppTitle ? 50.0 : 22.0)),
      centerTitle: true);
}
