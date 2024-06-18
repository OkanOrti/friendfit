// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/models/user.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/services/FriendRequest/FriendRequestService.dart';

class FriendRequestImpl implements FriendRequestService {
  final followingRef = FirebaseFirestore.instance.collection('following');
  final friendsRef = FirebaseFirestore.instance.collection('friends');
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final timestamp = DateTime.now();

  @override
  Future<List<QueryDocumentSnapshot>> getFriendRequests(
      String currentUserId) async {
    QuerySnapshot snapshot =
        await followingRef.doc(currentUserId).collection('userFollowing').get();
    return snapshot.docs;
  }

  @override
  Future<List<QueryDocumentSnapshot>> getFriends(String currentUserId) async {
    QuerySnapshot snapshot =
        await friendsRef.doc(currentUserId).collection('userFriends').get();
    debugPrint('gets friends service_impl finished');
    return snapshot.docs;
  }

  @override
  Future<int> getFriendsCount(String profileId) async {
    QuerySnapshot snapshot =
        await followingRef.doc(profileId).collection('userFollowing').get();
    return snapshot.docs.length;
  }

  @override
  Future<void> addFriendRequest(String userID, String currentUserID) async {
    await friendsRef
        .doc(userID)
        .collection('userFriends')
        .doc(currentUserID)
        .set({});
    await friendsRef
        .doc(currentUserID)
        .collection('userFriends')
        .doc(userID)
        .set({});
    await followingRef
        .doc(currentUserID)
        .collection('userFollowing')
        .doc(userID)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  @override
  Future<void> deleteFriendRequest(String currentUserId, String userID) async {
    await followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(userID)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  @override
  Future<DocumentSnapshot> getProfileUser(String profileID) async {
    DocumentSnapshot snapshot = await usersCollection.doc(profileID).get();
    debugPrint('profile user finished');

    return snapshot;
  }

  @override
  Future<void> followUser(User currentUser, String profileID) async {
    await followingRef
        .doc(profileID)
        .collection('userFollowing')
        .doc(currentUser.id)
        .set({
      "id": currentUser.id,
      //"username": username,
      "photoUrl": currentUser.photoUrl,
      "email": currentUser.email,
      "displayName": currentUser.displayName,
      "bio": "",
      "timestamp": timestamp,
      //"indexes":indexes
    });
  }

  @override
  Future<void> unfollowUser(User currentUser, String profileID) async {
    await friendsRef
        .doc(currentUser.id)
        .collection('userFriends')
        .doc(profileID)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    await friendsRef
        .doc(profileID)
        .collection('userFriends')
        .doc(currentUser.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  @override
  Future<bool> isFriendshipRequested(
      String currentUserId, String profileID) async {
    bool control = false;
    await followingRef
        .doc(profileID)
        .collection('userFollowing')
        .doc(currentUser!.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        control = true;
      }
    });
    return control;
  }

  @override
  Future<bool> isFriend(String currentUserId, String profileID) async {
    bool control = false;
    await friendsRef
        .doc(profileID)
        .collection('userFriends')
        .doc(currentUser!.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        control = true;
      }
    });
    return control;
  }
}
