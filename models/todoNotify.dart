// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class TodoNotify {
  final List<dynamic>? notificationIDs;
  final String? todoName;
  final String? gameName;
  final String? medicineType;
  final int? interval;
  final String? startTime;
  final String? todoId;
  final String? notifiedId;
  final String? gameId;
  final String? startDate;
  final String? imageTitleUrl;
  final String? startDateToDo;
  final DateTime? startNotify;
  final String? startNotify2;
  bool? isNotified;
  TodoNotify(
      {this.notificationIDs,
      this.todoName,
      this.gameName,
      this.startNotify,
      this.medicineType,
      this.startTime,
      this.interval,
      this.todoId,
      this.isNotified,
      this.notifiedId,
      this.gameId,
      this.startDate,
      this.startDateToDo,
      this.imageTitleUrl,
      this.startNotify2});

  String? get getTodoName => todoName;
  String? get getgameName => gameName;
  String? get getType => medicineType;
  int? get getInterval => interval;
  String? get getStartTime => startTime;
  List<dynamic>? get getIDs => notificationIDs;
  String? get getTodoId => todoId;

  Map<String, dynamic> toJson() {
    return {
      "ids": this.notificationIDs,
      "name": this.todoName,
      "gameName": this.gameName,
      "type": this.medicineType,
      "interval": this.interval,
      "start": this.startTime,
      "todoId": this.todoId,
      "startDate": this.startDate,
      "startDateToDo": this.startDateToDo,
      "isNotified": this.isNotified,
      "notifiedId": this.notifiedId,
      "startNotify2": this.startNotify2
    };
  }

  factory TodoNotify.fromJson(Map<dynamic, dynamic> parsedJson) {
    return TodoNotify(
      notificationIDs: parsedJson.containsKey('ids') ? parsedJson['ids'] : null,
      todoName: parsedJson.containsKey('name') ? parsedJson['name'] : null,
      gameName:
          parsedJson.containsKey('gameName') ? parsedJson['gameName'] : null,
      medicineType: parsedJson.containsKey('medicineType')
          ? parsedJson['medicineType']
          : null,
      interval:
          parsedJson.containsKey('interval') ? parsedJson['interval'] : null,
      startTime:
          parsedJson.containsKey('startTime') ? parsedJson['startTime'] : null,
      todoId: parsedJson.containsKey('todoId') ? parsedJson['todoId'] : null,
      isNotified: parsedJson.containsKey('isNotified')
          ? parsedJson['isNotified']
          : null,
      notifiedId: parsedJson.containsKey('notifiedId')
          ? parsedJson['notifiedId']
          : null,
      startDate:
          parsedJson.containsKey('startDate') ? parsedJson['startDate'] : null,
      startDateToDo: parsedJson.containsKey('startDateToDo')
          ? parsedJson['startDateToDo']
          : null,
      startNotify2: parsedJson.containsKey('startNotify2')
          ? parsedJson['startNotify2']
          : null,
    );
  }
}
