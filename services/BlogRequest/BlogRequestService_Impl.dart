// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/services/BlogRequest/BlogRequestService.dart';

final postsRef = FirebaseFirestore.instance.collection('posts');

class BlogRequestServiceImpl implements BlogRequestService {
  @override
  Future<List<QueryDocumentSnapshot>> getArticles(String ownerId) async {
    QuerySnapshot snapshot =
        await postsRef.doc(ownerId).collection('userPosts').get();
    debugPrint('gets friends service_impl finished');
    return snapshot.docs;
  }

  @override
  Future<Map> getArticleLikes(String postId) async {
    DocumentSnapshot snapshot =
        await postsRef.doc(adminId).collection('userPosts').doc(postId).get();

    return snapshot['likes'];
  }

  @override
  Future<int> getArticleLikesCount(String postId) async {
    DocumentSnapshot snapshot =
        await postsRef.doc(adminId).collection('userPosts').doc(postId).get();

    return snapshot['likesCount'];
  }

  @override
  Future<Map> isLikeControl(String postId, String currentUserId) async {
    DocumentSnapshot snapshot =
        await postsRef.doc(adminId).collection('userPosts').doc(postId).get();

    return snapshot['likes'];
  }
}
