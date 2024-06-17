// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendfit_ready/utils/uuid.dart';

class DietTask {
  String? id;
  String? title;

  String? desc;
  final String? imageTitleUrl;
  final String? categoryName; //veganlar için çocuklar için gibi..
  final bool? isActive;
  final dynamic likes;
  final int? likesCount;
  final String? language;
  final Timestamp? publishDate;
  final bool?
      isAdminTested; //değer "false" ise sadece admin görebilir makaleyi kontrol amaçlı.
  final String? ownerId;
  final List<dynamic>? indexes;
  final List<dynamic>? iconIds;
  final String? backgroundId;
  int? days;
  DietTask(
      {String? id,
      this.title,
      this.desc,
      this.imageTitleUrl,
      this.categoryName,
      this.isActive,
      this.likes,
      this.likesCount,
      this.language,
      this.publishDate,
      this.isAdminTested,
      this.ownerId,
      this.indexes,
      this.backgroundId,
      this.iconIds,
      this.days})
      : this.id = id ?? Uuid().generateV4();

  factory DietTask.fromDocument(DocumentSnapshot doc) {
    return DietTask(
      id: doc['Id'],
      title: (doc.data() as Map).containsKey('title') ? doc['title'] : null,
      desc: (doc.data() as Map).containsKey('desc') ? doc['desc'] : null,
      imageTitleUrl: (doc.data() as Map).containsKey('imageTitleUrl')
          ? doc['imageTitleUrl']
          : null,
      isActive:
          (doc.data() as Map).containsKey('isActive') ? doc['isActive'] : null,
      likes: (doc.data() as Map).containsKey('likes') ? doc['likes'] : null,
      publishDate: (doc.data() as Map).containsKey('publishDate')
          ? doc['publishDate']
          : null,
      isAdminTested: (doc.data() as Map).containsKey('isAdminTested')
          ? doc['isAdminTested']
          : null,
      ownerId:
          (doc.data() as Map).containsKey('ownerId') ? doc['ownerId'] : null,
      language:
          (doc.data() as Map).containsKey('language') ? doc['language'] : null,
      categoryName: (doc.data() as Map).containsKey('categoryName')
          ? doc['categoryName']
          : null,
      indexes:
          (doc.data() as Map).containsKey('indexes') ? doc['indexes'] : null,
      iconIds:
          (doc.data() as Map).containsKey('iconIds') ? doc['iconIds'] : null,
      backgroundId: (doc.data() as Map).containsKey('backgroundId')
          ? doc['backgroundId']
          : null,
      likesCount: (doc.data() as Map).containsKey('likesCount')
          ? doc['likesCount']
          : null,
      days: (doc.data() as Map).containsKey('days') ? doc['days'] : null,
    );
  }
}
