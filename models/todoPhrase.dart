// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendfit_ready/utils/uuid.dart';

class ToDoPhrase {
  final String id;
  final String? parentId;
  String? phrase;
  int isCompleted;
  List checkedUserId;
  bool? isLeft;
  String? title;
  int? rank;
  DateTime? checkedDate;

  ToDoPhrase(
      {String? id,
      this.parentId,
      this.phrase,
      int? isCompleted,
      List? checkedUserId,
      this.isLeft,
      this.title,
      this.checkedDate,
      this.rank})
      : this.id = id ?? Uuid().generateV4(),
        this.checkedUserId = checkedUserId ?? [],
        this.isCompleted = isCompleted ?? 0;

  factory ToDoPhrase.fromDocument(DocumentSnapshot doc) {
    // print(doc);
    return ToDoPhrase(
      id: (doc.data() as Map).containsKey('id') ? doc['id'] : null,
      parentId:
          (doc.data() as Map).containsKey('parentId') ? doc['parentId'] : null,
      phrase: (doc.data() as Map).containsKey('phrase') ? doc['phrase'] : null,
      isCompleted: (doc.data() as Map).containsKey('isCompleted')
          ? doc['isCompleted']
          : null,
      title: (doc.data() as Map).containsKey('title') ? doc['title'] : null,
      checkedUserId: (doc.data() as Map).containsKey('checkedUserId')
          ? doc['checkedUserId']
          : null,
      rank: (doc.data() as Map).containsKey('rank') ? doc['rank'] : null,
      checkedDate: (doc.data() as Map).containsKey('checkedDate')
          ? doc['checkedDate']
          : null,
    );
  }
}
