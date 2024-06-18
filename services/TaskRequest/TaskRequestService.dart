import 'package:cloud_firestore/cloud_firestore.dart';

abstract class TaskRequestService {
  Future<List<QueryDocumentSnapshot>> getTasks(String ownerId);
  Future<List<QueryDocumentSnapshot>> getTaskTodosById(String ownerId,String taskId);
  Future<Map> getTaskLikes(String postId);
  Future<int> getTaskLikesCount(String postId);
  Future<Map> isLikeControl(String postId,String currentUserId) ;

}
