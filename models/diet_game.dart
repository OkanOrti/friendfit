// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendfit_ready/utils/uuid.dart';

class DietGame {
  final String? id;
  String? title;
  final String? phrase;
  final String? imageTitleUrl;
  final List<dynamic>? categories;
  final List<dynamic>? trackKPIs;
  final String? dietId;
  final List<dynamic>? memberIds; //veganlar için çocuklar için gibi..
  final bool? isActive;
  final Timestamp? startDate;
  final Timestamp? endDate;
  final bool? isAdminTested;

  final String? ownerId;
  String? status;
  String? status2;
  final List<dynamic>? indexes;
  final bool? isAdminPrepared;
  final bool? isDieticianPrepared;
  final bool? isProPrepared;
  final int? gameDuration;
  final String? gameOwnerId;
  final bool? dayProtection;
  final int? likesCount;
  final List<dynamic>? planIds;

  DietGame(
      {String? id,
      this.likesCount,
      this.dayProtection,
      this.dietId,
      this.title,
      this.imageTitleUrl,
      this.categories,
      this.isActive,
      this.memberIds,
      this.endDate,
      this.startDate,
      this.isAdminTested,
      this.ownerId,
      this.indexes,
      this.phrase,
      this.trackKPIs,
      this.gameOwnerId,
      this.isAdminPrepared,
      this.isDieticianPrepared,
      this.isProPrepared,
      this.gameDuration,
      this.planIds,
      this.status})
      : this.id = id ?? Uuid().generateV4();

  factory DietGame.fromDocument(DocumentSnapshot doc) {
    return DietGame(
      id: (doc.data() as Map).containsKey('Id') ? doc['Id'] : null,
      title: (doc.data() != null && (doc.data() as Map).containsKey('title'))
          ? doc['title']
          : null,
      imageTitleUrl: (doc.data() as Map).containsKey('imageTitleUrl')
          ? doc['imageTitleUrl']
          : null,
      isActive:
          (doc.data() as Map).containsKey('isActive') ? doc['isActive'] : null,
      memberIds: (doc.data() as Map).containsKey('memberIds')
          ? doc['memberIds']
          : null,
      startDate: (doc.data() as Map).containsKey('startDate')
          ? doc['startDate']
          : null,
      endDate:
          (doc.data() as Map).containsKey('endDate') ? doc['endDate'] : null,
      isAdminTested: (doc.data() as Map).containsKey('isAdminTested')
          ? doc['isAdminTested']
          : null,
      ownerId:
          (doc.data() as Map).containsKey('ownerId') ? doc['ownerId'] : null,
      phrase: (doc.data() as Map).containsKey('phrase') ? doc['phrase'] : null,
      categories: (doc.data() as Map).containsKey('categories')
          ? doc['categories']
          : null,
      trackKPIs: (doc.data() as Map).containsKey('trackKPIs')
          ? doc['trackKPIs']
          : null,
      dietId: (doc.data() as Map).containsKey('dietId') ? doc['dietId'] : null,
      isAdminPrepared: (doc.data() as Map).containsKey('isAdminPrepared')
          ? doc['isAdminPrepared']
          : null,
      isDieticianPrepared:
          (doc.data() as Map).containsKey('isDieticianPrepared')
              ? doc['isDieticianPrepared']
              : null,
      gameDuration: (doc.data() as Map).containsKey('gameDuration')
          ? doc['gameDuration']
          : null,
      gameOwnerId: (doc.data() as Map).containsKey('gameOwnerId')
          ? doc['gameOwnerId']
          : null,
      dayProtection: (doc.data() as Map).containsKey('dayProtection')
          ? doc['dayProtection']
          : null,
      indexes:
          (doc.data() as Map).containsKey('indexes') ? doc['indexes'] : null,
      status: (doc.data() as Map).containsKey('status') ? doc['status'] : null,
      likesCount: (doc.data() as Map).containsKey('likesCount')
          ? doc['likesCount']
          : null,
      planIds:
          (doc.data() as Map).containsKey('planIds') ? doc['planIds'] : null,
    );
  }
}
