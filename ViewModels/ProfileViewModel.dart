// ignore: file_names
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:friendfit_ready/models/user.dart';
import 'package:friendfit_ready/services/FriendRequest/FriendRequestService.dart';
import 'package:friendfit_ready/services/service_locator.dart';

class ProfileViewModel extends ChangeNotifier {
  final FriendRequestService _friendRequestService =
      serviceLocator<FriendRequestService>();

  List<User> searchResults = [];
  User? profileUser;
  bool isLoaded = false;
  bool isProfileDataBusy = false;
  int? friendRequestCount;
  bool? isFriendRequested;
  bool isProfileOwner = false;
  bool? isFriend;

  static final User defaultUser = User(
      id: '', username: '', photoUrl: '', email: '', displayName: '', bio: '');

  Future<void> loadFriendRequestsData(String profileId) async {
    final friendRequestDocs =
        await _friendRequestService.getFriendRequests(profileId);

    friendRequestDocs.forEach((doc) {
      User user = User.fromDocument(doc);

      searchResults.add(user);
      isLoaded = true;
    });

    //return searchResults;
    // notifyListeners();
  }

  loadProfileUser(String profileID) async {
    final DocumentSnapshot profileSnapshot =
        await _friendRequestService.getProfileUser(profileID);

    profileUser = User.fromDocument(profileSnapshot);
    friendRequestCount = await _friendRequestService.getFriendsCount(profileID);
    //isProfileDataBusy = true;
    //notifyListeners();
  }

  addFriend(String userID, String currentUserID, index) async {
    await _friendRequestService.addFriendRequest(userID, currentUserID);
    searchResults.removeAt(index);
    isFriend = true;
    notifyListeners();
  }

  deleteFriend(String userID, String currentUserID, int index) async {
    await _friendRequestService.deleteFriendRequest(userID, currentUserID);
    searchResults.removeAt(index);
    isFriend = false;
    notifyListeners();
  }

  followUser(User currentUser, String profileID) async {
    await _friendRequestService.followUser(currentUser, profileID);
    isFriendRequested = true;
    notifyListeners();
  }

  unfollowUser(User currentUser, String profileID) async {
    isFriendRequested = false;
    isFriend = false;
    await _friendRequestService.unfollowUser(currentUser, profileID);

    notifyListeners();
  }

  isProfileOwnerControl(String currentUserId, String profileID) {
    isProfileOwner = currentUserId == profileID ? true : false;
    //notifyListeners();
  }

  isFriendRequestedControl(String currentUserId, String profileID) async {
    isFriendRequested = await _friendRequestService.isFriendshipRequested(
        currentUserId, profileID);
    //notifyListeners();
  }

  isFriendControl(String currentUserId, String profileID) async {
    isFriend = await _friendRequestService.isFriend(currentUserId, profileID);
    // notifyListeners();
  }

  Future loadProfilePage(String currentUserId, String profileId) async {
    await loadFriendRequestsData(profileId);
    await loadProfileUser(profileId);
    await isFriendControl(currentUserId, profileId);
    await isProfileOwnerControl(currentUserId, profileId);
    await isFriendRequestedControl(currentUserId, profileId);
    isLoaded = true;

    notifyListeners();
  }
}
