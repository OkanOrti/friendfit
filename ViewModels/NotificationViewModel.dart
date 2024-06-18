// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_this, file_names

import 'dart:convert';
import 'package:friendfit_ready/models/todoNotify.dart';
import 'package:friendfit_ready/models/dietTodos.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:friendfit_ready/models/diet_game.dart';
import 'package:friendfit_ready/screens/home.dart' as home;
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:path_provider/path_provider.dart';

final dietGamesRef = FirebaseFirestore.instance.collection('dietGames');

class NotificationViewModel extends ChangeNotifier {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  bool isNotified = false;
//declare stream
  BehaviorSubject<List<TodoNotify>> _medicineList$ =
      BehaviorSubject<List<TodoNotify>>.seeded([]);
  BehaviorSubject<List<TodoNotify>> get medicineList$ => _medicineList$;

  List<TodoNotify> prefList = [];
  List<TodoNotify> temp = [];

  getActiveStartedGames(List<DietGame> games) async {
    List<DietGame> games2 = [];
    print(games);
    for (var element in games) {
      if ((element.status == "Approved") &&
          (element.memberIds!.contains(home.currentUser!.id) ||
              element.gameOwnerId!.contains(home.currentUser!.id!))) {
        games2.add(element);
      }
    }
    var gameTodos = [];
    Map<String, Map<String, List<dynamic>>> a = {};
    await Future.forEach(games2, (DietGame element) async {
      QuerySnapshot snapshot = await dietGamesRef
          .doc(element.gameOwnerId)
          .collection("userDietGames")
          .doc(element.id)
          .collection("gameTodos")
          .get();
      final todoDocs = snapshot.docs;

      todoDocs.forEach((doc) {
        DietToDos a = DietToDos.fromDocument(doc);
        a.imageTitleUrl = element.imageTitleUrl ?? "";
        gameTodos.add(a);
      });
      a[element.id!] = {element.title!: gameTodos};
    });
    List<TodoNotify> notifyList = [];
    print(gameTodos);
    print(a);
    for (var i in a.entries) {
      for (var k in a[i.key]!.entries)
        k.value.asMap().forEach((index, element) {
          TodoNotify newEntryMedicine = TodoNotify(
              //notificationIDs: notificationIDs,
              todoName: element.title,
              gameName: k.key,
              todoId: element.id,
              //medicineType: medicineType,
              interval: 15,
              startTime: element.startDateToDo.toDate().toString(),
              startDateToDo: element.startDateToDo.toDate().toString(),
              startDate: element.startDate.toDate().toString(),
              imageTitleUrl: element.imageTitleUrl,
              gameId: i.key,
              //  isNotified: true,
              notifiedId: (i.key +
                  "_" +
                  this.dateFormat.format(element.startDate.toDate()) +
                  element.title +
                  index.toString()));
          notifyList.add(newEntryMedicine);
        });
      print(notifyList);
    }
    for (var element in notifyList) {
      this.updateTodoNotifyList(element);
    }

    notifyList.forEach((element) {
      !isNotifiedContol2(element.notifiedId!)
          ? scheduleNotification(element, 15, flutterLocalNotificationsPlugin,
              element.notifiedId!, element.imageTitleUrl!)
          : null;
    });
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> scheduleNotification(
      TodoNotify todo,
      // DietToDos todo,
      int value,
      FlutterLocalNotificationsPlugin plugin,
      String uniqueNotifiedId,
      String imagePath) async {
    var notifDate = todo.startNotify!.subtract(Duration(minutes: value));
    DateTime a = DateTime(2023, 11, 20, 4, 20);

    //var scheduledDate = tz.TZDateTime.from(notifDate, tz.local);
    var scheduledDate = tz.TZDateTime.utc(notifDate.year, notifDate.month,
        notifDate.day, notifDate.hour, notifDate.minute, notifDate.second);

    //final String largeIconPath = await _downloadAndSaveFile(imagePath, 'largeIcon');

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      //'repeatDailyAtTime description',
      importance: Importance.max,
      priority: Priority.high,
      color: AppColors.kRipple,
      //sound: 'sound',
      ledColor: AppColors.kRipple,
      ledOffMs: 1000,
      ledOnMs: 1000,
      enableLights: true,
      // largeIcon: FilePathAndroidBitmap(largeIconPath),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    /*for (int i = 0; i < (24 / medicine.interval).floor(); i++) {
      if ((hour + (medicine.interval * i) > 23)) {
        hour = hour + (medicine.interval * i) - 24;
      } else {
        hour = hour + (medicine.interval * i);
      }*/
    /* await widget.flutterLocalNotificationsPlugin.show(
          1,
          this.widget.game.title,
          todo.title+": öğünün başlamasına az kaldı, acele et...",
          //'It is time to take your medicine, according to schedule',
          //Time(19, 05, 0),
          platformChannelSpecifics);
      hour = ogValue;*/
    await plugin.zonedSchedule(
        uniqueNotifiedId.hashCode,
        todo.gameName,
        todo.todoName! + ": öğünün başlamasına az kaldı, acele et...",
        //  tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        scheduledDate,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  isNotifiedContol(String id) {
    var notified = false;
    var notifyList = _medicineList$.value;

    notifyList.forEach((element) {
      if (element.notifiedId == id) {
        notified = true;
      }
    });
    return notified;
  }

  Future<List<TodoNotify>> getLastNotifList() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    // sharedUser.setStringList('medicines', []);

    List<String> jsonList = sharedUser.getStringList('medicines')!;
    List<TodoNotify> pList = [];
    if (jsonList == null) {
      pList = [];
    } else {
      for (String jsonTodoNotify in jsonList) {
        Map userMap = jsonDecode(jsonTodoNotify);
        TodoNotify tempTodoNotify = TodoNotify.fromJson(userMap);
        pList.add(tempTodoNotify);
      }
    }
    return pList;
  }

  isNotifiedContol2(String id) async {
    var notified = false;
    var notifyList = await getLastNotifList(); //_medicineList$.value;

    notifyList.forEach((element) {
      if (element.notifiedId == id) {
        notified = true;
      }
    });
    return notified;
  }

  int getNotifiedInterval(String id) {
    var interval = 0;
    var notifyList = _medicineList$.value;
    notifyList.forEach((element) {
      if (element.notifiedId == id) {
        interval = element.interval!;
      }
    });
    return interval;
  }

  initializeNotifications() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    await _configureLocalTimeZone();
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    //await Navigator.push(    context,      new MaterialPageRoute(builder: (context) => HomePage()),);
  }

  Future removeTodoNotify(String uniqueNotifiedId) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    List<String> medicineJsonList = [];

    var blocList = _medicineList$.value;
    blocList.removeWhere((medicine) => medicine.notifiedId == uniqueNotifiedId);

    await flutterLocalNotificationsPlugin.cancel(uniqueNotifiedId.hashCode);

    if (blocList.length != 0) {
      for (var blocTodoNotify in blocList) {
        String medicineJson = jsonEncode(blocTodoNotify.toJson());
        medicineJsonList.add(medicineJson);
      }
    }
    sharedUser.setStringList('medicines', medicineJsonList);
    _medicineList$.add(blocList);
  }

  Future updateTodoNotifyList(TodoNotify newTodoNotify) async {
    List<TodoNotify> blocList = [];
    print(prefList);
    blocList = _medicineList$.value;
    List<String> medicineJsonList = [];
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    medicineJsonList = sharedUser.getStringList('medicines')!;

    Map<String, dynamic> tempMap = newTodoNotify.toJson();
    String newTodoNotifyJson = jsonEncode(tempMap);

    print(sharedUser.getStringList('medicines'));
    if (sharedUser.getStringList('medicines') == null ||
        sharedUser.getStringList('medicines')!.isEmpty) {
      medicineJsonList.add(newTodoNotifyJson);
      //List<TodoNotify> blocList2 = [];
      blocList.add(newTodoNotify);
      _medicineList$.add(blocList);
    } else {
      // List<TodoNotify> blocList2 = [];
      blocList.add(newTodoNotify);
      _medicineList$.add(blocList);

      !await isNotifiedContol2(newTodoNotify.notifiedId!)
          ? medicineJsonList.add(newTodoNotifyJson)
          : null;
      print("okan");
    }
    print("okan");

    sharedUser.setStringList('medicines', medicineJsonList);
  }

  Future makeTodoNotifyList() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    sharedUser.setStringList('medicines', []);

    List<String> jsonList = sharedUser.getStringList('medicines')!;
//    List<TodoNotify> prefList = [];
    if (jsonList == null) {
      return;
    } else {
      for (String jsonTodoNotify in jsonList) {
        Map userMap = jsonDecode(jsonTodoNotify);
        TodoNotify tempTodoNotify = TodoNotify.fromJson(userMap);
        prefList.add(tempTodoNotify);
        temp.add(tempTodoNotify);
      }
      _medicineList$.add(prefList);
    }
  }

  @override
  void dispose() {
    // _selectedDay$.close();
    // _selectedPeriod$.close();
    _medicineList$.close();
    super.dispose();
  }
}
