// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:friendfit_ready/models/user.dart';
import 'package:friendfit_ready/services/FriendRequest/FriendRequestService.dart';
import 'package:friendfit_ready/services/service_locator.dart';

class MainPageViewModel extends ChangeNotifier {
  final FriendRequestService _friendRequestService =
      serviceLocator<FriendRequestService>();


  List<User> friends = [];
  bool isBusy = false;
  int friendsCount = 0;
  bool isFriend = false;

  static final User defaultUser = User(
      id: '', username: '', photoUrl: '', email: '', displayName: '', bio: '');

  Future<void> getFriends(String currentUserId) async {
    final friendsDocs = await _friendRequestService.getFriends(currentUserId);
    friends = [];

    /* for (int i = 0; i < friendsDocs.length; i++) {
      DocumentSnapshot profileSnapshot =
          await _friendRequestService.getProfileUser(friendsDocs[i].id);
      User friendUser = User.fromDocument(profileSnapshot);

      friends.add(friendUser);
      debugPrint('profile snapshot finished');
    }*/
    await Future.forEach(friendsDocs, (QueryDocumentSnapshot doc) async {
      //  String id = doc==null?"":doc.id;
      DocumentSnapshot a = await _friendRequestService.getProfileUser(doc.id);

      User friendUser = User.fromDocument(a);

      friends.add(friendUser);
    });
  }

  Future<void> loadMainPage(String currentUserId) {
    return getFriends(currentUserId);
    // debugPrint('load main page finished');
  }
}
