// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/services/RecipeRequest/RecipeRequestService.dart';

final recipesRef = FirebaseFirestore.instance.collection('recipes');

class RecipeRequestServiceImpl implements RecipeRequestService {
  @override
  Future<List<QueryDocumentSnapshot>> getRecipes(String ownerId) async {
    QuerySnapshot snapshot =
        await recipesRef.doc(ownerId).collection('userRecipes').get();
    debugPrint('gets friends service_impl finished');
    return snapshot.docs;
  }

  Future<Map> getRecipeLikes(String postId) async {
    DocumentSnapshot snapshot = await recipesRef
        .doc(adminId)
        .collection('userRecipes')
        .doc(postId)
        .get();

    return snapshot['likes'];
  }

  Future<int> getRecipeLikesCount(String postId) async {
    DocumentSnapshot snapshot = await recipesRef
        .doc(adminId)
        .collection('userRecipes')
        .doc(postId)
        .get();

    return snapshot['likesCount'];
  }

  Future<Map> isLikeControl(String postId, String currentUserId) async {
    DocumentSnapshot snapshot = await recipesRef
        .doc(adminId)
        .collection('userRecipes')
        .doc(postId)
        .get();

    return snapshot['likes'];
  }
}
