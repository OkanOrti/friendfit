// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BlogRequestService {
  Future<List<QueryDocumentSnapshot>> getArticles(String ownerId);
  Future<Map> getArticleLikes(String postId);
  Future<int> getArticleLikesCount(String postId);
  Future<Map> isLikeControl(String postId, String currentUserId);
}
