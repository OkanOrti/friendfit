// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendfit_ready/models/user.dart';

abstract class FriendRequestService {
  Future<List<QueryDocumentSnapshot>> getFriendRequests(String currentUserId);

  Future<List<QueryDocumentSnapshot>> getFriends(String currentUserId);

  Future<int> getFriendsCount(String profileId);

  Future<void> addFriendRequest(String currentUserId, String userID);

  Future<void> deleteFriendRequest(String currentUserId, String userID);

  Future<DocumentSnapshot> getProfileUser(String profileID);

  Future<void> followUser(User currentUser, String profileID);

  Future<void> unfollowUser(User currentUser, String profileID);

  Future<bool> isFriendshipRequested(String currentUserId, String profileID);

  Future<bool> isFriend(String currentUserId, String profileID);
}
