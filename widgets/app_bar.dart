import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:friendfit_ready/screens/home.dart' as Home;
import 'package:friendfit_ready/screens/survey.dart';
import 'package:friendfit_ready/screens/surveysPage.dart';
import 'package:friendfit_ready/services/firebase_auth_methods.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/screens/myNotifications.dart';
import 'package:provider/src/provider.dart';

import '../constants.dart';

AppBar buildAppBar(BuildContext context,
    {bool isTransparent = false,
    String? title,
    AdvancedDrawerController? advancedDrawerController,
    void Function()? handle}) {
  return AppBar(
    backgroundColor: isTransparent ? Colors.transparent : Colors.white,
    elevation: 0,
    leading: IconButton(
        onPressed: handle,
        icon: ValueListenableBuilder<AdvancedDrawerValue>(
          valueListenable: advancedDrawerController!,
          builder: (_, value, __) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                value.visible ? Icons.clear : Icons.menu,
                key: ValueKey<bool>(value.visible),
              ),
            );
          },
        )),
    title: !isTransparent
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              isTransparent ? "" : "Friend",
              style: const TextStyle(
                  color: AppColors.kFont, fontFamily: "Poppins"),
            ),
            Text(
              isTransparent ? "" : "Fit",
              style: const TextStyle(
                  color: AppColors.kRipple, fontFamily: "Poppins"),
            ),
          ])
        : null,
    centerTitle: true,
    actions: [
      IconButton(
        icon: const Icon(Icons.list_alt,
            color: Color(
                0xFF545D68)), //ClipOval(child: Image.asset("assets/images/profile.png")),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurveysPage(
                  //todom: data.todo,
                  //todoModel: this.model,
                  ),
            ),
          );

          //googleSignIn.signOut();
        },
      ),
      IconButton(
        icon: const Icon(Icons.notifications_none,
            color: Color(
                0xFF545D68)), //ClipOval(child: Image.asset("assets/images/profile.png")),
        onPressed: () {
          context.read<FirebaseAuthMethods>().signOut(context);
          Home.googleSignIn.signOut();
          /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyNotifications(
                  //todom: data.todo,
                  //todoModel: this.model,
                  ),
            ),
          );*/

          //googleSignIn.signOut();
        },
      )
    ],
  );
}
