//import 'package:fit_kit/fit_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:friendfit_ready/widgets/ripplesAnimation.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/ViewModels/StepViewModel.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import '../constants.dart';
import 'package:friendfit_ready/ViewModels/NotificationViewModel.dart';
import 'package:friendfit_ready/models/todoNotify.dart';

class MyNotifications extends StatefulWidget {
  @override
  MyNotificationsState createState() => MyNotificationsState();
}

class MyNotificationsState extends State<MyNotifications> {
  //final StepViewModel stepModel = serviceLocator<StepViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    //stepModel.readPermissions();
    //stepModel.readData();
    // timer = Timer.periodic(Duration(seconds: 15), (Timer t) => stepModel.readData());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NotificationViewModel notifyModel =
        Provider.of<NotificationViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        //shadowColor: AppColors.kRipple,
        //elevation: 3,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: kIconColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Bildirimlerim",
          style: TextStyle(
              fontSize: 18, color: AppColors.kFont, fontFamily: "Poppins"),
        ),
        centerTitle: true,
        actions: [Text("Tümünü sil")],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<TodoNotify>>(
            future: notifyModel.getLastNotifList(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else if (snapshot.data!.length == 0) {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFFC9C9C9),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              } else {
                List<UserResult> searchResults = [];
                snapshot.data?.forEach((element) {
                  searchResults.add(UserResult(element));
                });

                return ListView(children: searchResults);
                /* Container(
                        height: 400,
                        //color: Color(0xFFF6F8FC),
                        child: GridView.builder(
                          padding: EdgeInsets.only(top: 12),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return MedicineCard(snapshot.data[index]);
                          },
                        ),
                      );*/
              }
            },

            // Text(stepModel.typeScores["DataType.STEP_COUNT"].toString())
          ),
        ),
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  final TodoNotify medicine;

  MedicineCard(this.medicine);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: InkWell(
        highlightColor: Colors.white,
        splashColor: Colors.grey,
        onTap: () {
          /*Navigator.of(context).push(
            PageRouteBuilder<Null>(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return AnimatedBuilder(
                    animation: animation,
                    builder: (BuildContext context, Widget child) {
                      return Opacity(
                        opacity: animation.value,
                        child: MedicineDetails(medicine),
                      );
                    });
              },
              transitionDuration: Duration(milliseconds: 500),
            ),
          );*/
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.kRipple.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //makeIcon(50.0),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      medicine.gameName!,
                      style: TextStyle(
                          fontSize: 22,
                          color: AppColors.kRipple,
                          fontWeight: FontWeight.w500),
                    ),
                  ),

                  Text(
                    medicine.todoName!,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFC9C9C9),
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    medicine.getInterval.toString() + " dk. önce",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFC9C9C9),
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    medicine.startNotify2!,
                    /*medicine.startNotify.year.toString() +
                        "-" +
                        medicine.startNotify.month.toString() +
                        "-" +
                        medicine.startNotify.day.toString(),*/
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFC9C9C9),
                        fontWeight: FontWeight.w400),
                  ),
                  /*Text(
                    medicine.startNotify.hour.toString() +
                        ":" +
                        medicine.startNotify.minute.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFC9C9C9),
                        fontWeight: FontWeight.w400),
                  )*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserResult extends StatelessWidget {
  final TodoNotify notify;

  UserResult(this.notify);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () =>
                print("okan"), //showProfile(context, profileId: user.id),
            child: ListTile(
              dense: true,
              /* leading: CircleAvatar(
                backgroundColor: Colors.grey,
                // backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),*/
              title: Text(
                notify.gameName!,
                style: TextStyle(
                    color: AppColors.kFont, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                notify.todoName! +
                    " " +
                    notify.getInterval.toString() +
                    " dk.önce, Tarih: " +
                    notify.startNotify2!,
                //DateFormat('yyyy-MM-dd – kk:mm').format(notify.startNotify),
                style: TextStyle(color: AppColors.kFont),
              ),
              trailing: Icon(
                Icons.delete,
                size: 20,
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
