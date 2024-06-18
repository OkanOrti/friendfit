// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/services/TaskRequest/TaskRequestService.dart';

class TaskRequestServiceImpl implements TaskRequestService {
  @override
  Future<List<QueryDocumentSnapshot>> getTasks(String ownerId) async {
    QuerySnapshot snapshot =
        await dietTasksRef.doc(ownerId).collection('userDietTasks').get();
    debugPrint('get Tasks service_impl finished');
    return snapshot.docs;
  }

  Future<List<QueryDocumentSnapshot>> getTaskTodosById(
      String ownerId, String taskId) async {
    QuerySnapshot snapshot = await dietTasksRef
        .doc(ownerId)
        .collection('userDietTasks')
        .doc(taskId)
        .collection('userDietTaskTodos')
        .get();
    debugPrint('gets Todos finished');
    return snapshot.docs;
  }

  Future<Map> getTaskLikes(String postId) async {
    DocumentSnapshot snapshot = await dietTasksRef
        .doc(adminId)
        .collection('userDietTasks')
        .doc(postId)
        .get();

    return snapshot['likes'];
  }

  Future<int> getTaskLikesCount(String postId) async {
    DocumentSnapshot snapshot = await dietTasksRef
        .doc(adminId)
        .collection('userDietTasks')
        .doc(postId)
        .get();

    return snapshot['likesCount'];
  }

  Future<Map> isLikeControl(String postId, String currentUserId) async {
    DocumentSnapshot snapshot = await dietTasksRef
        .doc(adminId)
        .collection('userDietTasks')
        .doc(postId)
        .get();

    return snapshot['likes'];
  }
}
