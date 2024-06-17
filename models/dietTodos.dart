// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendfit_ready/utils/uuid.dart';

class DietToDos {
  String? id;
  String? parentId;
  String? phrase;
  List<dynamic>? phrases;
  int? isCompleted;
  String? title;
  bool? isActive;
  Timestamp? startDate;
  Timestamp? startDateToDo;
  Timestamp? endDate;
  String? ownerId;
  int? rank;
  dynamic checkedPhrases;
  String? imageTitleUrl;
  int? dayRank;
  String? taskTitle;

  DietToDos(
      {String? id,
      this.imageTitleUrl,
      this.title,
      this.isActive,
      this.parentId,
      this.phrase,
      this.isCompleted,
      this.ownerId,
      this.startDate,
      this.endDate,
      this.phrases,
      this.startDateToDo,
      this.checkedPhrases,
      this.rank,
      this.taskTitle,
      this.dayRank})
      : this.id = id ?? Uuid().generateV4();

  factory DietToDos.fromDocument(DocumentSnapshot doc) {
    // print(doc);
    return DietToDos(
        id: (doc.data() as Map).containsKey('Id') ? doc['Id'] : null,
        title: (doc.data() as Map).containsKey('title') ? doc['title'] : null,
        isActive: (doc.data() as Map).containsKey('isActive')
            ? doc['isActive']
            : null,
        parentId: (doc.data() as Map).containsKey('parentId')
            ? doc['parentId']
            : null,
        phrase:
            (doc.data() as Map).containsKey('phrase') ? doc['phrase'] : null,
        taskTitle: (doc.data() as Map).containsKey('taskTitle')
            ? doc['taskTitle']
            : null,
        isCompleted: (doc.data() as Map).containsKey('isCompleted')
            ? doc['isCompleted']
            : null,
        startDate: (doc.data() as Map).containsKey('startDate')
            ? doc['startDate']
            : null,
        startDateToDo: (doc.data() as Map).containsKey('startDateToDo')
            ? doc['startDateToDo']
            : null,
        endDate:
            (doc.data() as Map).containsKey('endDate') ? doc['endDate'] : null,
        ownerId:
            (doc.data() as Map).containsKey('ownerId') ? doc['ownerId'] : null,
        phrases:
            (doc.data() as Map).containsKey('phrases') ? doc['phrases'] : null,
        checkedPhrases: (doc.data() as Map).containsKey('checkedPhrases')
            ? doc['checkedPhrases']
            : null,
        rank: (doc.data() as Map).containsKey('Rank') ? doc['Rank'] : null,
        dayRank:
            (doc.data() as Map).containsKey('dayRank') ? doc['dayRank'] : null);
  }
}
