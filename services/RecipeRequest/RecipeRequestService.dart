// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RecipeRequestService {
  Future<List<QueryDocumentSnapshot>> getRecipes(String ownerId);
  Future<Map> getRecipeLikes(String postId);
  Future<int> getRecipeLikesCount(String postId);
  Future<Map> isLikeControl(String postId, String currentUserId);
}
